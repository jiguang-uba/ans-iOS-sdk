//
//  ANSVisualSearch.h
//  AnalysysVisual
//
//  Created by xiao xu on 2020/2/7.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ANSVisualSearch : NSObject
/**
@param bindView 当前点击的控件
@param bindProps 返回当前绑定控件及其关联控件的信息
*/
+ (void)findBindView:(UIView *)bindView withData:(NSArray *)bindData bindProps:(void (^)(NSString*event_id, NSDictionary *props))bindProps;


/**
@param bindView 当前点击的控件
@param related 关联控件的信息
*/
+ (NSMutableArray *)findOriginRelatedPropsWithBindView:(UIView *)bindView relateArray:(NSArray *)related;

/**
@param name 要查找的控件类名
@param roots 从哪个根view开始查找
 @param desViews 找到的控件
*/
+ (void)findViewWithClassName:(NSString *)name fromRoot:(NSArray *)roots desView:(void (^)(UIView *desViews))desViews;

+ (UIView *)bridge_subviewTosuperview:(UIView *)view;
+ (NSMutableArray *)bridge_superviewTosubviews:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
