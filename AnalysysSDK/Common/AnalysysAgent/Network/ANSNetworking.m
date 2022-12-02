//
//  ANSNetworking.m
//  AnalysysAgent
//
//  Created by analysys on 2018/3/1.
//  Copyright © 2018年 analysys. All rights reserved.
//

#import "ANSNetworking.h"
#import <UIKit/UIKit.h>
#import "ANSSecurityPolicy.h"

typedef NSURLSessionAuthChallengeDisposition (^ANSURLSessionDidReceiveAuthenticationChallengeBlock)(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential);

typedef NSURLSessionAuthChallengeDisposition (^ANSURLSessionTaskDidReceiveAuthenticationChallengeBlock)(NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential);

/** 超时时长 */
static double const ANSHttpRequestTimeOutInterval = 30.0;

@interface ANSNetworking ()<NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURL *serverURL;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, copy) ANSURLSessionDidReceiveAuthenticationChallengeBlock sessionDidReceiveAuthenticationChallenge;
@property (nonatomic, copy) ANSURLSessionTaskDidReceiveAuthenticationChallengeBlock authenticationChallengeHandler;

@end


@implementation ANSNetworking

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.serverURL = url;
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    self.securityPolicy = [ANSSecurityPolicy defaultPolicy];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.allowsCellularAccess = true;
    sessionConfig.timeoutIntervalForRequest = ANSHttpRequestTimeOutInterval;
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:self.operationQueue];
    
    return self;
}

#pragma mark - public method

- (void)setSecurityPolicy:(ANSSecurityPolicy *)securityPolicy {
    if (securityPolicy == nil) {
        return;
    }
    if (securityPolicy.SSLPinningMode != ANSSSLPinningModeNone && ![self.serverURL.scheme isEqualToString:@"https"]) {
        NSString *pinningMode = @"Unknown Pinning Mode";
        switch (securityPolicy.SSLPinningMode) {
            case ANSSSLPinningModeNone:        pinningMode = @"AFSSLPinningModeNone"; break;
            case ANSSSLPinningModeCertificate: pinningMode = @"AFSSLPinningModeCertificate"; break;
            case ANSSSLPinningModePublicKey:   pinningMode = @"AFSSLPinningModePublicKey"; break;
        }
        NSString *reason = [NSString stringWithFormat:@"A security policy configured with `%@` can only be applied on a manager with a secure base URL (i.e. https)", pinningMode];
        @throw [NSException exceptionWithName:@"Invalid Security Policy" reason:reason userInfo:nil];
    }
    
    _securityPolicy = securityPolicy;
}

/** post请求 */
- (void)postRequestWithHeader:(NSDictionary *)header
                         body:(id)body
                      success:(SuccessBlock)successBlock
                      failure:(FailureBlock)failureBlock {
    [self requestWithHTTPMethod:@"POST"
                     parameters:nil
                         header:header
                           body:body
                        success:successBlock
                        failure:failureBlock];
}

/** get请求 */
- (void)getRequestWithParameters:(nullable NSDictionary *)parameters
                         success:(SuccessBlock)successBlock
                         failure:(FailureBlock)failureBlock {
    [self requestWithHTTPMethod:@"GET"
                     parameters:parameters
                         header:nil
                           body:nil
                        success:successBlock
                        failure:failureBlock];
}

#pragma mark - private method

/// url地址拼接参数
/// @param parameters 参数信息
- (NSURL *)getHttpURLWithParameters:(NSDictionary *)parameters {
    if (parameters.allKeys.count == 0) {
        return self.serverURL;
    }
    NSString *paramString = nil;
    for (NSString *key in parameters.allKeys) {
        if (paramString == nil) {
            paramString = [NSString stringWithFormat:@"%@=%@",key,parameters[key]];
        } else {
            paramString = [NSString stringWithFormat:@"%@&%@=%@",paramString,key,parameters[key]];
        }
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",self.serverURL, paramString]];
}

/** body信息 */
- (NSString *)httpRequestBody:(id)body {
    NSString *bodyString;
    if ([body isKindOfClass:[NSString class]]) {
        bodyString = body;
    } else if ([body isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *stringComponents = [NSMutableArray array];
        [body enumerateKeysAndObjectsUsingBlock:^(id nestedKey, id nestedValue, BOOL *stop){
            NSString *stringComponent = [NSString stringWithFormat:@"%@=%@", nestedKey, [nestedValue description]];
            [stringComponents addObject:stringComponent];
        }];
        bodyString = [stringComponents componentsJoinedByString:@"&"];
    } else {
        
    }
    return bodyString;
}

/** 发起请求 */
- (void)requestWithHTTPMethod:(NSString *)method
                   parameters:(NSDictionary *)parameters
                       header:(NSDictionary *)header
                         body:(id)body
                      success:(SuccessBlock)successBlock
                      failure:(FailureBlock)failureBlock {
    
    NSURL *requestURL = [self getHttpURLWithParameters:parameters];
    
    if (requestURL == nil || requestURL.absoluteString.length == 0) {
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    request.HTTPMethod = method;
    NSArray *headerKeys = [header allKeys];
    [headerKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [request setValue:header[key] forHTTPHeaderField:key];
    }];
    //  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //  request.allHTTPHeaderFields
    NSString *bodyStr = [self httpRequestBody:body];
    if (bodyStr) {
        [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failureBlock) {
                failureBlock(error);
            }
        } else {
            if (successBlock) {
                successBlock(response, data);
            }
        }
    }];
    
    [sessionDataTask resume];
}

#pragma mark - NSURLSessionDelegate
// 询问>>服务器客户端配合验证--会话级别
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if (self.sessionDidReceiveAuthenticationChallenge) {
        disposition = self.sessionDidReceiveAuthenticationChallenge(session, challenge, &credential);
    } else {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([self.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

#pragma mark - NSURLSessionTaskDelegate
// 询问>>服务器需要客户端配合验证--任务级别
// 会话级别除非未实现对应代理、否则不会调用任务级别验证方法
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if (self.authenticationChallengeHandler) {
        disposition = self.authenticationChallengeHandler(session, task, challenge, &credential);
    } else {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([self.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                disposition = NSURLSessionAuthChallengeUseCredential;
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}


#pragma mark - NSURLSessionDelegate

- (void)setSessionDidReceiveAuthenticationChallengeBlock:(NSURLSessionAuthChallengeDisposition (^)(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential))block {
    self.sessionDidReceiveAuthenticationChallenge = block;
}

- (void)setTaskDidReceiveAuthenticationChallengeBlock:(NSURLSessionAuthChallengeDisposition (^)(NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential))block {
    self.authenticationChallengeHandler = block;
}

@end
