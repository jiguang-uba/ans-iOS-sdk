//
//  AnalysysLogData.h
//  AnalysysOCDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalysysLogData : NSObject

@property (nonatomic,strong) NSMutableArray *logData;

+ (instancetype)sharedSingleton;

@end

