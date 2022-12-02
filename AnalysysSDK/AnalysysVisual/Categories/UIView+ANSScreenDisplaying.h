//
//  UIView+ANSScreenDisplaying.h
//  AnalysysVisual
//
//  Created by SoDo on 2020/7/29.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ANSScreenDisplaying)

/// 判断View是否显示在当前屏幕上
- (BOOL)ansIsViewDisplayedInScreen;

@end

NS_ASSUME_NONNULL_END
