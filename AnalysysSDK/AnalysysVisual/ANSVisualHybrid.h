//
//  ANSVisualHybrid.h
//  AnalysysVisual
//
//  Created by xiao xu on 2020/5/12.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WKWebViewConfiguration;
@class WKScriptMessage;

@interface ANSVisualHybrid : NSObject

+ (void)setWebViewVisualConfig:(WKWebViewConfiguration *)config scriptMessageHandler:(id)handler;

+ (void)resetWebViewVisualConfig:(WKWebViewConfiguration *)config;

+ (void)setScriptMessage:(WKScriptMessage *)scriptMessage;

@end

