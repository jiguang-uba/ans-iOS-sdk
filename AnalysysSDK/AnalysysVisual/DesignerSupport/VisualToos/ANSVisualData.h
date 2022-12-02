//
//  ANSViewTool.h
//  AnalysysVisual
//
//  Created by xiao xu on 2020/2/4.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ANSVisualData : NSObject
// 服务端下发的新版path数据
@property (nonatomic,strong) NSMutableArray *nVData;

// 服务端下发的旧版path数据
@property (nonatomic,strong) NSMutableArray *oVData;

// websocket下发的新版可视化数据
@property (nonatomic,strong) NSMutableArray *websocketnVData;

// 是否开启可视化Debug模式
@property (nonatomic, assign) BOOL isOpenVisualDebug;

// 是否处于websocket连接模式
@property (nonatomic, assign) BOOL isConnectingWS;

+ (instancetype)sharedManager;
+ (void)dealWithResponseData:(NSDictionary *)responseData;

// 从本地获取https拉取下来的Hybrid线上数据
+ (NSArray *)getWebViewData;

// 从本地获取wss拉取下来的Hybrid调试数据
+ (NSArray *)getWebViewDebugData;
@end

NS_ASSUME_NONNULL_END
