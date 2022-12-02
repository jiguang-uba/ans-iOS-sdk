//
//  AnalysysLogManager.m
//  AnalysysOCDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

#import "AnalysysLogManager.h"
#import "AnalysysLogVC.h"

#define ANSLogButtonWith 60
#define ANSLogButtonHeight 60

@interface AnalysysLogManager()

@property (nonatomic, strong)UIButton *floatBtn;

@end

@implementation AnalysysLogManager

+ (instancetype)sharedManager {
    static id singleInstance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        if (!singleInstance) {
            singleInstance = [[self alloc] init] ;
        }
    });
    return singleInstance;
}

+ (void)showFloatingButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"日志" forState:UIControlStateNormal];
    btn.bounds = CGRectMake(0, 0, ANSLogButtonWith, ANSLogButtonHeight);
    btn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2.0 - ANSLogButtonWith/2.0, ANSLogButtonWith, ANSLogButtonHeight);
    btn.backgroundColor = [UIColor colorWithHexString:@"#686BF4"];
    [btn addTarget:self action:@selector(showLogVC) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = ANSLogButtonWith/2.0;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [btn addGestureRecognizer:pan];
    
    [[UIApplication sharedApplication].keyWindow addSubview:btn];
    [AnalysysLogManager sharedManager].floatBtn = btn;
}

+ (void)showLogVC {
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
    
    AnalysysLogVC *analysysLogVC = [[AnalysysLogVC alloc] init];
    analysysLogVC.callBackBlock = ^{
        [AnalysysLogManager sharedManager].floatBtn.hidden = NO;
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:analysysLogVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [[self getTopViewController] presentViewController:nav animated:true completion:^{
        [AnalysysLogManager sharedManager].floatBtn.hidden = YES;
    }];
}

+ (void)pan:(UIPanGestureRecognizer *)pan {
    UIButton *floatBtn = [AnalysysLogManager sharedManager].floatBtn;
    //获取偏移量
    // 返回的是相对于最原始的手指的偏移量
    CGPoint transP = [pan translationInView:floatBtn];
    
    // 移动图片控件
    floatBtn.transform = CGAffineTransformTranslate(floatBtn.transform, transP.x, transP.y);
    
    CGFloat btnWidth = floatBtn.frame.size.width;
    CGFloat btnHight = floatBtn.frame.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (floatBtn.frame.origin.x < 0) {
        floatBtn.frame = CGRectMake(0, floatBtn.frame.origin.y, ANSLogButtonWith, ANSLogButtonHeight);
    } else if (floatBtn.frame.origin.x > screenWidth - btnWidth) {
        floatBtn.frame = CGRectMake(screenWidth - btnWidth, floatBtn.frame.origin.y, ANSLogButtonWith, ANSLogButtonHeight);
    } else if (floatBtn.frame.origin.y < 0) {
        floatBtn.frame = CGRectMake(floatBtn.frame.origin.x, 0, ANSLogButtonWith, ANSLogButtonHeight);
    } else if (floatBtn.frame.origin.y > screenHeight - btnHight) {
        floatBtn.frame = CGRectMake(floatBtn.frame.origin.x, screenHeight - btnHight, ANSLogButtonWith, ANSLogButtonHeight);
    }
    
    // 复位,表示相对上一次
    [pan setTranslation:CGPointZero inView:floatBtn];
}

+ (UIViewController *)rootViewController {
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController *)getTopViewController {
    UIViewController* currentViewController = [self rootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    return currentViewController;
}


@end
