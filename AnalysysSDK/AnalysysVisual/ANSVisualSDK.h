//
//  ANSVisualSDK.h
//  AnalysysVisual
//
//  Created by SoDo on 2019/2/12.
//  Copyright © 2019 analysys. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIGestureRecognizer (ANSVisualGestureRecognizer)

@end

@interface UICollectionView (SearchPath)

@end

@interface UITableView (SearchPath)

@end

@interface ANSVisualSDK : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, copy) NSString *currentPage;//  当前点击页面
@property (nonatomic, copy) NSString *controlText;//  控件文本


#pragma mark - SDK配置

/** 初始化埋点及下发地址 */
- (void)setVisualBaseUrl:(NSString *)baseUrl;

/** 设置可视化埋点地址 */
- (void)setVisualServerUrl:(NSString *)visualUrl;

/** 设置可视化埋点配置下发地址 */
- (void)setVisualConfigUrl:(NSString *)configUrl;

#pragma mark - 可视化操作
/**
 * 可视化查找控件及上报
 * @param sender 当前点击的控件
 */
- (void)findBindView:(UIView *)sender;

/// 触发可视化埋点事件
/// @param event_id 事件标识
/// @param trackView 控件对象
/// @param properties 控件属性
- (void)trackEventID:(NSString *)event_id trackView:(id)trackView withProperties:(NSDictionary *)properties;

- (void)echoWebVisualEvent:(NSString *)eventName position:(CGRect)position withProperties:(NSDictionary *)properties;

@end


