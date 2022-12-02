//
//  ANSSessionManager.m
//  AnalysysAgent
//
//  Created by SoDo on 2018/12/5.
//  Copyright © 2018 analysys. All rights reserved.
//

#import "ANSSessionManager.h"
#import <UIKit/UIKit.h>
#import "NSString+ANSMD5.h"
#import "ANSFileManager.h"
#import "ANSLock.h"
#import "ANSSwizzler.h"

//  页面切换session时长/秒
static const NSTimeInterval ANSSessionInterval = 30.0;

@implementation ANSSessionManager {
    NSDate *_lastPageStartDate; //  上一页面开始时间或退入后台时间，用于session切割
    NSDate *_lastPageEndDate; //  上一页面结束时间，用于30秒session切换
    NSString *_sessionId;   //sessionId
}

+ (instancetype)sharedManager {
    static id singleInstance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        singleInstance = [[self alloc] init];
    });
    return singleInstance;
}

- (void)monitorSession {

    //  规则1：App被调起切换session
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWakedUpNotification:) name:@"ANSAppWakedUpNotification" object:nil];
    
    // viewDidAppear还是通过自动hook发送pv页面的调用，避免自动pageview同此先后顺序无法控制
//    [ANSSwizzler swizzleSelector:@selector(viewDidAppear:) onClass:[UIViewController class] withBlock:viewDidAppearBlock named:@"ANSSessionViewDidAppear"];
    
    void (^viewDidDisappearBlock)(id, SEL, id) = ^(UIViewController *controller, SEL sel, NSNumber *num) {
//        [self _lastPageEndDate] = [NSDate date];
        [self viewDidDisappearBlock];
    };
    [ANSSwizzler swizzleSelector:@selector(viewDidDisappear:) onClass:[UIViewController class] withBlock:viewDidDisappearBlock named:@"ANSSessionViewDidDisappear"];
}


- (NSString *)sessionId {
    return [[self sessionGenerate:3] copy];
}

/*pageview更新session**/
- (void)pvSession {
    [self sessionGenerate:1];
    
    _lastPageStartDate = [NSDate date];
    [self saveLastPageAppearDate:_lastPageStartDate];
}

/*startup更新session**/
- (void)startUpSession {
    [self sessionGenerate:2];
}

- (void)resetSession {
    [self sessionGenerate:0];
}

- (void)updateEnd {
    _lastPageEndDate = [NSDate date];
    [self saveLastPageDisAppearDate:_lastPageEndDate];
}

/* type类型：0代表外界传入，1代表pageview传入,2代表sessionId为空的时候生成一个(主要场景是startup),3代表正常非pv情况sessionId获取**/
- (NSString *)sessionGenerate:(NSInteger)type {
    @synchronized (self) {
        @try {
            if (type==0) {
                [self createSessionId];
            } else if (type==1) {
                if(!_lastPageStartDate) {
                    _lastPageStartDate = [self lastPageAppearDate];
                }
                
                if(!_lastPageEndDate) {
                    _lastPageEndDate = [self lastPageDisAppearDate];
                }
                
                if (![self isSameDayWithDate:_lastPageStartDate]) {
                    //  页面事件跨天
                    [self createSessionId];
                }
                
                
                //暂时去掉：因为home键有可能不会调用viewDidDisappear导致结束时间不准
//                else if ([self isPageChangedWithDate:_lastPageEndDate]) {
//                    //  页面事件超过30秒
//                    [self createSessionId];
//                }
            } else if(type==2) {
                if(!_sessionId) {
                    _sessionId = [self localSession];
                    
                    if(!_lastPageStartDate) {
                        _lastPageStartDate = [self lastPageAppearDate];
                    }
                    
                    if(!_lastPageEndDate) {
                        _lastPageEndDate = [self lastPageDisAppearDate];
                    }
                   
                    
                    if(_sessionId.length<=0) {
                        [self createSessionId];
                    } else {
                        if (![self isSameDayWithDate:_lastPageStartDate]) {
                            
                            //  页面事件跨天
                            [self createSessionId];
                        }

                        if([self isPageChangedWithDate:_lastPageEndDate]) {
                            [self createSessionId];
                        }
                    }
                } else {
                    if(_sessionId.length<=0) {
                        [self createSessionId];
                    } else {
                        
                        if (![self isSameDayWithDate:_lastPageStartDate]) {
                            //  页面事件跨天
                            [self createSessionId];
                        }
                        
                        if([self isPageChangedWithDate:_lastPageEndDate]) {
                            [self createSessionId];
                        }
                    }
                }
            } else if(type==3) {
                if(!_sessionId) {
                    _sessionId = [self localSession];
                    if(!_sessionId){
                        [self createSessionId];
                    }
                }
            }
        } @catch (NSException *exception) {
            
        }
        return _sessionId;
    }
}

/** 生成session标识 */
- (void)createSessionId {
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *randomString = [NSString stringWithFormat:@"iOS%@%u",[NSNumber numberWithLongLong:nowtime], arc4random()%1000000];
    NSString *sessionId = [randomString ansMD516Bit];
    _sessionId = sessionId;
    
    _lastPageStartDate = [NSDate date];
    [self saveLastPageAppearDate:_lastPageStartDate];
    
    [self saveSession:_sessionId];
}

/** 传入date与当前时间是否同一天 */
- (BOOL)isSameDayWithDate:(NSDate *)eventDate {
    
    if(!eventDate) {
        return FALSE;
    }
    return [[NSCalendar currentCalendar] isDateInToday:eventDate];
}

/** 页面切换是否大于30秒 */
- (BOOL)isPageChangedWithDate:(NSDate *)pageDate {

    if(!_lastPageEndDate) {
        //主要是第一次app安装打开的时候_lastPageEndDate为空
        return FALSE;
    }
    NSDate *systemZoneDate = [NSDate date];
    NSTimeInterval interval = [systemZoneDate timeIntervalSinceDate:pageDate];
    return interval > ANSSessionInterval;
}


#pragma mark - 生命周期监听
/** App被唤醒重置session */
- (void)appWakedUpNotification:(NSNotification *)notification {
    [self sessionGenerate:0];
}

/** 页面消失的时候更新pageview页面时间*/
- (void)viewDidDisappearBlock {
    _lastPageEndDate = [NSDate date];
    [self saveLastPageDisAppearDate:_lastPageEndDate];
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 存储
static NSString *const AnalysysSession = @"AnalysysSession";
static NSString *const AnalysysPageAppearDate = @"AnalysysPageAppearDate";
static NSString *const AnalysysPageDisappearDate = @"AnalysysPageDisappearDate";


/*获取sessionID**/
- (NSString *)localSession {
    NSString *session = [ANSFileManager userDefaultValueWithKey:AnalysysSession];
    return session;
}

/** 会话session */
- (void)saveSession:(NSString *)sessionId {
    [ANSFileManager saveUserDefaultWithKey:AnalysysSession value:sessionId];
}

/** 上一页面展示时间 */
- (void)saveLastPageAppearDate:(NSDate *)date {
    [ANSFileManager saveUserDefaultWithKey:AnalysysPageAppearDate value:date];
}

/*上一页面展示时间**/
- (NSDate *)lastPageAppearDate {
    NSDate *date = [ANSFileManager userDefaultValueWithKey:AnalysysPageAppearDate];
    return date;
}

/** 上一个页面结束时间*/
- (void)saveLastPageDisAppearDate:(NSDate *)date {
    [ANSFileManager saveUserDefaultWithKey:AnalysysPageDisappearDate value:date];
}

/* 上一个页面结束时间**/
- (NSDate *)lastPageDisAppearDate {
    NSDate *date = [ANSFileManager userDefaultValueWithKey:AnalysysPageDisappearDate];
    return date;
}

@end
