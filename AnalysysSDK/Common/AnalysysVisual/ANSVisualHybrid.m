//
//  ANSVisualHybrid.m
//  AnalysysVisual
//
//  Created by xiao xu on 2020/5/12.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import "ANSVisualHybrid.h"
#import "AnalysysLogger.h"
#import "AnalysysSDK.h"
#import <WebKit/WebKit.h>
#import "ANSVisualData.h"
#import "ANSJsonUtil.h"
#import "ANSVisualSDK.h"
#import "ANSVisualSearch.h"
@implementation ANSVisualHybrid

+ (void)setWebViewVisualConfig:(WKWebViewConfiguration *)config scriptMessageHandler:(id)handler{
    @try {
        //NSString *func = @"window.AnalysysAgentHybrid={isHybrid:function(){return true}}";
        NSString *res = [NSString stringWithFormat:@"{\"is_appstart\":true,\"userId\":\"%@\"}",[AnalysysSDK sharedManager].getXwho];
        NSString *func = [NSString stringWithFormat:@"window.AnalysysAgentHybrid={isHybrid:function(){return true},getAppStartInfo:function(){return %@}}",res];
        // 生成WKUserScript对象
        WKUserScript *script = [[WKUserScript alloc] initWithSource:func
                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                   forMainFrameOnly:YES];
        // 生成WKWebViewConfiguration配置信息
        [config.userContentController addUserScript:script]; // 添加脚本
        [config.userContentController addScriptMessageHandler:handler name:@"AnalysysAgentGetEventList"];
        [config.userContentController addScriptMessageHandler:handler name:@"AnalysysAgentGetProperty"];
        [config.userContentController addScriptMessageHandler:handler name:@"AnalysysAgentTrack"];
    } @catch (NSException *exception) {
        ANSDebug(@"%@",exception);
    }
    
}

+ (void)resetWebViewVisualConfig:(WKWebViewConfiguration *)config {
    [config.userContentController removeScriptMessageHandlerForName:@"AnalysysAgentGetEventList"];
    [config.userContentController removeScriptMessageHandlerForName:@"AnalysysAgentGetProperty"];
    [config.userContentController removeScriptMessageHandlerForName:@"AnalysysAgentTrack"];
}

+ (void)setScriptMessage:(WKScriptMessage *)scriptMessage {
    WKWebView *web = scriptMessage.webView;
    
    @try {
        if ([scriptMessage.name isEqualToString:@"AnalysysAgentGetEventList"]) {
            NSString *javaScript = [NSString stringWithFormat:@"window.AnalysysAgent.onEventList(%@)",[ANSJsonUtil convertToStringWithObject:[[ANSVisualData sharedManager] isConnectingWS]?[ANSVisualData getWebViewDebugData]:[ANSVisualData getWebViewData]]];
            [web evaluateJavaScript:javaScript completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
                if (error) {
                    ANSDebug(@"onEventList --- error");
                }
            }];
        } else if ([scriptMessage.name isEqualToString:@"AnalysysAgentGetProperty"]) {
            NSString *relateStr = [((NSArray *)scriptMessage.body) firstObject];
            NSString *callBackIdStr = [((NSArray *)scriptMessage.body) lastObject];
            
            NSArray *relate = [ANSJsonUtil convertToArrayWithString:relateStr];
            if (relate) {
                //获取原生控件属性
                NSArray *originProps = [ANSVisualSearch findOriginRelatedPropsWithBindView:web relateArray:relate];
                NSString *javaScript = [NSString stringWithFormat:@"window.AnalysysAgent.onProperty('%@','%@')",[ANSJsonUtil convertToStringWithObject:originProps], callBackIdStr];
                [web evaluateJavaScript:javaScript completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
                    if (error) {
                        ANSDebug(@"onProperty --- error");
                    }
                }];
            }

        } else if ([scriptMessage.name isEqualToString:@"AnalysysAgentTrack"]) {
            NSArray *body = scriptMessage.body;
            NSString *event_id = body[0];
            NSDictionary *props = [ANSJsonUtil convertToMapWithString:body[1]];
            NSDictionary *position = [ANSJsonUtil convertToMapWithString:body[2]];
            
            if ([[ANSVisualData sharedManager] isConnectingWS]) {
                CGFloat x = [[position objectForKey:@"$pos_left"] floatValue];
                CGFloat y = [[position objectForKey:@"$pos_top"] floatValue];
                CGFloat width = [[position objectForKey:@"$pos_width"] floatValue];
                CGFloat height = [[position objectForKey:@"$pos_height"] floatValue];
                
                [[ANSVisualSDK sharedManager] echoWebVisualEvent:event_id position:CGRectMake(x, y, width, height) withProperties:props];
            } else {
                [[AnalysysSDK sharedManager] track:event_id properties:props];
            }
        }
    } @catch (NSException *exception) {
        ANSDebug(@"%@",exception);
    }
}

+ (void)analysysAgentGetEventList:(WKWebView *)web {
    NSString *javaScript = [NSString stringWithFormat:@"window.AnalysysAgent.onEventList(%@)",[ANSJsonUtil convertToStringWithObject:[[ANSVisualData sharedManager] isConnectingWS]?[ANSVisualData getWebViewDebugData]:[ANSVisualData getWebViewData]]];
    [web evaluateJavaScript:javaScript completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
        if (error) {
            ANSDebug(@"onEventList --- error");
        }
    }];
}

+ (void)analysysAgentGetProperty:(WKWebView *)web withParams:(NSArray *)params {
    NSString *relateStr = [params firstObject];
    NSString *callBackIdStr = [params lastObject];
    
    NSArray *relate = [ANSJsonUtil convertToArrayWithString:relateStr];
    if (relate) {
        //获取原生控件属性
        NSArray *originProps = [ANSVisualSearch findOriginRelatedPropsWithBindView:web relateArray:relate];
        NSString *javaScript = [NSString stringWithFormat:@"window.AnalysysAgent.onProperty('%@','%@')",[ANSJsonUtil convertToStringWithObject:originProps], callBackIdStr];
        [web evaluateJavaScript:javaScript completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
            if (error) {
                ANSDebug(@"onProperty --- error");
            }
        }];
    }
}

+ (void)analysysAgentTrack:(WKWebView *)web withParams:(NSArray *)params {
    NSString *event_id = params[0];
    NSDictionary *props = [ANSJsonUtil convertToMapWithString:params[1]];
    NSDictionary *position = [ANSJsonUtil convertToMapWithString:params[2]];
    
    if ([[ANSVisualData sharedManager] isConnectingWS]) {
        CGFloat x = [[position objectForKey:@"$pos_left"] floatValue];
        CGFloat y = [[position objectForKey:@"$pos_top"] floatValue];
        CGFloat width = [[position objectForKey:@"$pos_width"] floatValue];
        CGFloat height = [[position objectForKey:@"$pos_height"] floatValue];
        
        [[ANSVisualSDK sharedManager] echoWebVisualEvent:event_id position:CGRectMake(x, y, width, height) withProperties:props];
    } else {
        [[AnalysysSDK sharedManager] track:event_id properties:props];
    }
}

@end
