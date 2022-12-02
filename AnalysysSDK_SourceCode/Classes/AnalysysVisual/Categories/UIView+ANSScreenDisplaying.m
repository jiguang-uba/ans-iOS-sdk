//
//  UIView+ANSScreenDisplaying.m
//  AnalysysVisual
//
//  Created by SoDo on 2020/7/29.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import "UIView+ANSScreenDisplaying.h"

#import "ANSUtil.h"

@implementation UIView (ANSScreenDisplaying)

- (BOOL)ansIsViewDisplayedInScreen {
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 坐标转换至window层
    //    CGRect rect = [self convertRect:self.frame fromView:nil];
    UIWindow * window = [ANSUtil currentKeyWindow];
    CGRect rect = [self convertRect:self.bounds toView:window];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    if (self.hidden) {
        return FALSE;
    }
    
    if (self.superview == nil) {
        return FALSE;
    }
    
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取view与window交叉Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}

@end
