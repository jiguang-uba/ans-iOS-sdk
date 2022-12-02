//
//  ANSNetworking.h
//  AnalysysAgent
//
//  Created by analysys on 2018/3/1.
//  Copyright © 2018年 analysys. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ANSSecurityPolicy;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(NSURLResponse * _Nullable response, NSData *responseData);
typedef void(^FailureBlock)(NSError *error);

/**
 * @class
 * ANSNetworking
 *
 * @abstract
 * 上传模块
 *
 * @discussion
 * 处理数据上传
 */

@interface ANSNetworking : NSObject

/// 服务器证书验证
@property (nonatomic, strong) ANSSecurityPolicy *securityPolicy;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)url;

/**
 post请求

 @param header 请求头信息
 @param body 请求body体
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)postRequestWithHeader:(NSDictionary *)header body:(id)body success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 get请求

 @param parameters 参数信息
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)getRequestWithParameters:(nullable NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/// 设置block，当连接认证发生时，由`NSURLSessionDelegate` 方法 `URLSession:didReceiveChallenge:completionHandler:`处理
/// @param block 块
- (void)setSessionDidReceiveAuthenticationChallengeBlock:(nullable NSURLSessionAuthChallengeDisposition (^)(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * _Nullable __autoreleasing * _Nullable credential))block;

/// 设置block，当会话任务收到一个特定的身份验证时，由' NSURLSessionTaskDelegate '方法' URLSession:task:didReceiveChallenge:completionHandler: '处理。
/// @param block 块
- (void)setTaskDidReceiveAuthenticationChallengeBlock:(nullable NSURLSessionAuthChallengeDisposition (^)(NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, NSURLCredential * _Nullable __autoreleasing * _Nullable credential))block;

@end

NS_ASSUME_NONNULL_END
