//
//  UIAlertController+Extended.m
//  AnalysysOCDemo
//
//  Created by 少冲 on 2020/9/23.
//  Copyright © 2020 xiao xu. All rights reserved.
//

#import "UIAlertController+Extended.h"

@implementation UIAlertController (Extended)

// 处理低版本UIAlertController弹出后，点击悬浮球导致弹框上移无法返回问题
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.preferredStyle == UIAlertControllerStyleAlert) {
        __weak UIAlertController *pSelf = self; dispatch_async(dispatch_get_main_queue(), ^{
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            [pSelf.view setCenter:CGPointMake(screenWidth / 2.0, screenHeight / 2.0)];
            [pSelf.view setNeedsDisplay];
        });
    }
}


@end
