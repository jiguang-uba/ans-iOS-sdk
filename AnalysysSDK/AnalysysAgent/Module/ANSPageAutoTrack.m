//
//  ANSPageAutoTrack.m
//  AnalysysAgent
//
//  Created by SoDo on 2018/12/10.
//  Copyright © 2018 analysys. All rights reserved.
//

#import "ANSPageAutoTrack.h"

#import <UIKit/UIKit.h>

#import "ANSQueue.h"
#import "ANSSwizzler.h"
#import "AnalysysSDK.h"
#import "AnalysysAgent.h"
#import "NSThread+ANSHelper.h"
#import "ANSConst+private.h"
#import "ANSControllerUtils.h"

@interface ANSPageAutoTrack () 

@property (nonatomic, weak) UIViewController *lastViewController;

@end

@implementation ANSPageAutoTrack

+ (instancetype)shareInstance {
    static id singleInstance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        singleInstance = [[self alloc] init] ;
    });
    return singleInstance;
}

+ (void)autoTrack {
    [NSThread ansRunOnMainThread:^{
        void (^viewDidAppearBlock)(id, SEL, id) = ^(id obj, SEL sel, NSNumber *num) {
            UIViewController *controller = (UIViewController *)obj;
            [[ANSPageAutoTrack shareInstance] trackViewAppear:controller isFromBackground:NO];
        };

        [ANSSwizzler swizzleSelector:@selector(viewDidAppear:) onClass:[UIViewController class] withBlock:viewDidAppearBlock named:@"ANSViewDidAppear"];
    }];
}

+ (void)autoTrackLastVisitPage {
    UIViewController *lastVC = [ANSPageAutoTrack shareInstance].lastViewController;
    //  需要判断黑白名单
    [[ANSPageAutoTrack shareInstance] trackViewAppear:lastVC isFromBackground:YES];
}

#pragma mark - private method

/** 是否可以进行跟踪 */
- (BOOL)canTrackViewController:(UIViewController *)controller {
    Class vClass = [controller class];
    if (!vClass) {
        return NO;
    }
    if ([controller isKindOfClass:[UINavigationController class]] ||
        [controller isKindOfClass:[UITabBarController class]]) {
        return NO;
    }
    NSString *className = NSStringFromClass(vClass);
    
    if ([[AnalysysSDK sharedManager] isViewAutoTrack]) {
        if ([[AnalysysSDK sharedManager] isIgnoreTrackWithClassName:className]) {
            return NO;
        } else if ([[AnalysysSDK sharedManager] hasPageViewWhiteList]) {
            if ([[AnalysysSDK sharedManager] isTrackWithClassName:className]) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

/** 页面显示 */
- (void)trackViewAppear:(UIViewController *)controller isFromBackground:(BOOL)background {
    [ANSQueue dispatchAsyncLogSerialQueueWithBlock:^{
        if ([[ANSControllerUtils systemBuildInClasses] containsObject:NSStringFromClass(controller.class)]) {
            return;
        }
        
        if ([self canTrackViewController:controller]) {
            if (!background && self.lastViewController == controller) {
                //  前台页面切换 防止右滑手势多次触发
                return ;
            }
            [self autoTrackViewController:controller];
        }
        
        self.lastViewController = controller;
    }];
}

/** 自定义参数 */
- (void)autoTrackViewController:(UIViewController *)controller {    
    NSMutableDictionary *pageProperties = [NSMutableDictionary dictionary];
    [pageProperties addEntriesFromDictionary:[self pageInfoWithViewController:controller]];
    
    if (_referrerPageUrl) {
        [pageProperties setValue:_referrerPageUrl forKey:ANSPageReferrerUrl];
    }
    
    NSString *userPageUrl;
    if ([controller conformsToProtocol:@protocol(ANSAutoPageTracker)]) {
        id<ANSAutoPageTracker> vc = (id<ANSAutoPageTracker> )controller;
        if ([controller respondsToSelector:@selector(registerPageProperties)]) {
            NSDictionary *userPageProperties = [vc registerPageProperties];
            if (userPageProperties && [userPageProperties isKindOfClass:NSDictionary.class]) {
                [pageProperties addEntriesFromDictionary:userPageProperties];
            }
        }
        if ([controller respondsToSelector:@selector(registerPageUrl)]) {
            NSString *pageUrl = [vc registerPageUrl];
            if (pageUrl && [pageUrl isKindOfClass:NSString.class]) {
                [pageProperties setValue:pageUrl forKey:ANSPageUrl];
                userPageUrl = pageUrl;
                if (_referrerPageUrl) {
                    [pageProperties setValue:_referrerPageUrl forKey:ANSPageReferrerUrl];
                }
                _referrerPageUrl = pageUrl;
            }
        }
    }
    //  取自动采集
    if (!userPageUrl) {
        _referrerPageUrl = NSStringFromClass([controller class]);
    }
    
    [[AnalysysSDK sharedManager] autoPageViewWithProperties:pageProperties];
}

/// controller页面信息
- (NSDictionary *)pageInfoWithViewController:(UIViewController *)viewController {
    NSString *className = NSStringFromClass([viewController class]);
    NSString *controllerTitle = [ANSControllerUtils titleFromViewController:viewController];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          className, ANSPageUrl,
                          controllerTitle, ANSPageTitle,
                          nil];
    return info;
}

@end
