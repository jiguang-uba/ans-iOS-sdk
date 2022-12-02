//
//  ANSViewTool.m
//  AnalysysVisual
//
//  Created by xiao xu on 2020/2/4.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import "ANSVisualData.h"
#import "ANSBundleUtil.h"

@interface ANSVisualData()

@end

@implementation ANSVisualData
+ (instancetype)sharedManager {
    static id singleInstance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        if (!singleInstance) {
            singleInstance = [[self alloc] init];
        }
    });
    return singleInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.nVData = [NSMutableArray array];
        self.oVData = [NSMutableArray array];
        self.websocketnVData = [NSMutableArray array];
    }
    return self;
}


//+ (NSDictionary *)getBindingData {
////    return [ANSBundleUtil loadConfigsWithFileName:@"BindTest" fileType:@"json"];
//    return [[self sharedManager] visualData];
//}


+ (void)dealWithResponseData:(NSDictionary *)responseData {
    [[[self sharedManager] nVData] removeAllObjects];
    [[[self sharedManager] oVData] removeAllObjects];
    
    NSArray *dataArr = [responseData objectForKey:@"data"];
    if (dataArr && dataArr.count>0) {
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (([obj objectForKey:@"new_path"] || [obj objectForKey:@"props_binding"]) && [obj objectForKey:@"path"]) {
                [[[self sharedManager] nVData] addObject:obj];
            } else {
                [[[self sharedManager] oVData] addObject:obj];
            }
        }];
    }
}

+ (NSArray *)getWebViewData {
    NSMutableArray *tmpData = [NSMutableArray array];
    [[[self sharedManager] nVData] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj objectForKey:@"is_hybrid"] ||
            ([obj objectForKey:@"props_binding"] && ![obj objectForKey:@"new_path"])) {
            [tmpData addObject:obj];
        }
    }];
    return tmpData;
}

+ (NSArray *)getWebViewDebugData {
    NSMutableArray *tmpData = [NSMutableArray array];
    [[[self sharedManager] websocketnVData] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj objectForKey:@"is_hybrid"] ||
            ([obj objectForKey:@"props_binding"] && ![obj objectForKey:@"new_path"])) {
            [tmpData addObject:obj];
        }
    }];
    return tmpData;
}

@end
