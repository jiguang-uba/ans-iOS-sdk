//
//  ANSVisualRegular.h
//  AnalysysVisual
//
//  Created by xiao xu on 2020/3/30.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ANSVisualRegular : NSObject

+ (NSArray<NSString *> *)regularExtract:(NSString *)regex checkString:(NSString *)checkString;

@end

NS_ASSUME_NONNULL_END
