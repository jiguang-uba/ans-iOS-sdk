//
//  ANSWKScriptMessageHandler.h
//  AnalysysAgent
//
//  Created by person on 2021/1/29.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ANSWKScriptMessageHandler : NSObject <WKScriptMessageHandler>

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
