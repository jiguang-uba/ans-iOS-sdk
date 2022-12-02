//
//  AnalysysLogData.m
//  AnalysysOCDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

#import "AnalysysLogData.h"
@interface AnalysysLogData()

@end

@implementation AnalysysLogData

+ (instancetype)sharedSingleton {
    static AnalysysLogData *_dataSingleTon = nil;
    static dispatch_once_t onceTask;
    dispatch_once(&onceTask, ^{
        _dataSingleTon = [[AnalysysLogData alloc] init];
    });
    return _dataSingleTon;
}

- (NSMutableArray *)logData {
    if (!_logData) {
        _logData = [NSMutableArray array];
    }
    return _logData;
}

/// SDK数据上报回调
/// @param eventData 上报数据
- (void)onEventDataReceived:(id)eventData {
    if (eventData) {
        NSMutableArray *logArray = [NSMutableArray arrayWithArray:self.logData];
        [logArray insertObject:eventData atIndex:0];
        self.logData = logArray;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AnalysysDataUpdate" object:nil];
    }
}

@end
