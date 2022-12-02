//
//  PageViewDuration.m
//  AnalysysAgent
//
//  Created by person on 2021/2/3.
//

#import "PageViewDuration.h"
#import "ANSSwizzler.h"
#import "ANSControllerUtils.h"
#import "ANSQueue.h"
#import "ANSUtil.h"
#import "AnalysysSDK.h"
#import "AnalysysAgent.h"
#import "ANSConst+private.h"

@interface AnalysysSDK (private)

- (NSMutableSet *)getBlackList;

@end

@implementation PageViewDuration
{
    CFTimeInterval startTime;
    __weak UIViewController *currentViewController;
    BOOL flag;  //表示app首次启动，首次启动viewdidappear不发送page_close
}

+ (PageViewDuration *)sharedInstance {
    static PageViewDuration *pv = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pv = [[PageViewDuration alloc] init];
    });
    return pv;
}


-(void)start {
    if (!AnalysysConfig.autoPageViewDuration) {
        return;
    }
    
    flag = NO;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(applicationDidBecomeActiveNotification:)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];
    
}


- (void)ans_ViewDidAppear:(UIViewController *)controller {
    if (!AnalysysConfig.autoPageViewDuration) {
        return;
    }
    
    @try {
        if ([[ANSControllerUtils systemBuildInClasses] containsObject:NSStringFromClass([controller class])]) {
            return;
        }
        
        if ([controller isKindOfClass:[UINavigationController class]] ||
            [controller isKindOfClass:[UITabBarController class]]) {
            return;
        }
        if (currentViewController) {
            if ([controller isEqual:currentViewController]) {
                //当前控制器与变化控制器相同，返回，防止点击tab会刷新viewdidappear
                return;
            }
            if ([currentViewController.childViewControllers containsObject:controller]) {
                //不处理子控制作为view出现的事件
                return;
            }
            
            if (currentViewController.childViewControllers.count > 0) {
                for (UIViewController *controllerc in currentViewController.childViewControllers) {
                    
                    if ([controllerc.childViewControllers containsObject:controller]) {
                        return;
                    }
                    
                    for (UIViewController *controllerx in controllerc.childViewControllers) {
                        if ([controllerx.childViewControllers containsObject:controller]) {
                            return;
                        }
                    }
                }
                
                
                
            }
            
            

            
        }
        
        
        
        
        if(!flag) {
            flag = TRUE;
            startTime = CACurrentMediaTime();

            currentViewController = controller;
            return;
        }
        
        
        
        CFAbsoluteTime endTime = CACurrentMediaTime();
        
        CFAbsoluteTime duration = endTime - startTime;
        
        [self sendClose:duration controller:controller];
        
        
        
        startTime = CACurrentMediaTime();

        currentViewController = controller;
    } @catch (NSException *exception) {
        
    }

    
}
         

/** App 变为活跃状态 */
- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification {
    if (!AnalysysConfig.autoPageViewDuration) {
        return;
    }
    startTime = CACurrentMediaTime();
}

/** app变为非活跃状态 */
- (void)applicationWillResignActiveNotification:(NSNotification *)notification {
    if (!AnalysysConfig.autoPageViewDuration) {
        return;
    }
    @try {
        CFAbsoluteTime endTime = CACurrentMediaTime();
        CFAbsoluteTime duration = endTime - startTime;
        

        [self sendClose:duration controller:nil];
    } @catch (NSException *exception) {
        
    }
    

}

- (void)sendClose:(CFAbsoluteTime) time controller:(UIViewController *)controller {
    if(!currentViewController) {
        UIWindow *win = [ANSUtil currentKeyWindow];
        if(win) {
            currentViewController = win.rootViewController;
        }
    }
    
    if(!currentViewController){
        return;
    }
    
    //以毫秒为时间
    time = time * 1000;
    NSNumber *num = [NSNumber numberWithLongLong:time];
    

    NSString *url = NSStringFromClass([currentViewController class]);

    NSLog(@"BlackList == %@",[[AnalysysSDK sharedManager] getBlackList]);
    if ([[AnalysysSDK sharedManager] isIgnoreTrackWithClassName:url]) {
        NSLog(@"return BlackList == %@",url);
        return;
    }
    
    NSString *title = [ANSControllerUtils titleFromViewController:currentViewController];
    NSMutableDictionary *pvProperties = [NSMutableDictionary dictionary];
    
    if ([currentViewController conformsToProtocol:@protocol(ANSAutoPageTracker)]) {
        id<ANSAutoPageTracker> vc = (id<ANSAutoPageTracker> )currentViewController;
        if ([currentViewController respondsToSelector:@selector(registerPageProperties)]) {
            NSDictionary *propertiesDic = [vc registerPageProperties];
            for (NSString *key in propertiesDic.allKeys) {
                if ([key isEqualToString:ANSPageTitle]) {
                    if ([propertiesDic objectForKey:ANSPageTitle] != nil) {
                        title = propertiesDic[ANSPageTitle];
                    }
                }
                if ([propertiesDic objectForKey:key] != nil) {
                    [pvProperties setValue:[propertiesDic objectForKey:key] forKey:key];
                }
            }
            
        }
        if ([currentViewController respondsToSelector:@selector(registerPageUrl)]) {
            NSString *pageUrl = [vc registerPageUrl];
            if (pageUrl && [pageUrl isKindOfClass:NSString.class]) {
                url = pageUrl;
            }
        }
    }

    [pvProperties setValue:num forKey:ANSPageStayTime];
    [pvProperties setValue:url forKey:ANSPageUrl];
    [pvProperties setValue:title forKey:ANSPageTitle];
    
    
    [[AnalysysSDK sharedManager] track:ANSPage_close properties:pvProperties];
}





@end
