//
//  ANSWKScriptMessageHandler.m
//  AnalysysAgent
//
//  Created by person on 2021/1/29.
//

#import "ANSWKScriptMessageHandler.h"
#import "ANSHybrid.h"
#import "ANSModuleProcessing.h"

@implementation ANSWKScriptMessageHandler

+ (instancetype)shareInstance {
    static ANSWKScriptMessageHandler *ans = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^(){
        ans = [[ANSWKScriptMessageHandler alloc] init];
    });
    return ans;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {

    [ANSHybrid setAnalysysAgentHybridScriptMessage:message];

    [ANSModuleProcessing setScriptMessage:message];
}

@end
