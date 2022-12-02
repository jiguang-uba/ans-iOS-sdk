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
    _sessionId = [self localSession];
    _lastPageStartDate = [self lastPageAppearDate];
    //  兼容老数据
    if (!_sessionId || !_lastPageStartDate || ![_lastPageStartDate isKindOfClass:NSDate.class]) {
        [self resetSession];
    }
    
    //  启动sdk后检测是否需要切换session
    [self generateSessionId];
    
    //  规则1：App被调起切换session
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWakedUpNotification:) name:@"ANSAppWakedUpNotification" object:nil];
    
    //  规则3：App退入后台>30s切换session
    //  规则4：App启动生成session
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    //  规则2：页面切换时跨天切换session
    void (^viewDidAppearBlock)(id, SEL, id) = ^(UIViewController *controller, SEL sel, NSNumber *num) {
        [self pageDidAppeared];
    };
//    void (^viewDidDisappearBlock)(id, SEL, id) = ^(UIViewController *controller, SEL sel, NSNumber *num) {
//        [self updatePageDisappearDate];
//    };
    
    [ANSSwizzler swizzleSelector:@selector(viewDidAppear:) onClass:[UIViewController class] withBlock:viewDidAppearBlock named:@"ANSSessionViewDidAppear"];
//    [ANSSwizzler swizzleSelector:@selector(viewDidDisappear:) onClass:[UIViewController class] withBlock:viewDidDisappearBlock named:@"ANSSessionViewDidDisappear"];
}

/** 重置session */
- (void)resetSession {
    [self updatePageAppearDate];

    [self createSessionId];
}

- (NSString *)sessionId {
    return [_sessionId copy];
}

#pragma mark - NSNotification

/** App被唤醒重置session */
- (void)appWakedUpNotification:(NSNotification *)notification {
    [self resetSession];
}

/** App 变为活跃状态 */
- (void)appDidBecomeActiveNotification:(NSNotification *)notification {
    [self generateSessionId];
}

/** app变为非活跃状态 */
- (void)appWillResignActiveNotification:(NSNotification *)notification {
    [self updatePageAppearDate];
}

#pragma mark - private method
/** 页面切换 是否跨天 */
- (void)pageDidAppeared {
    if (![self isSameDayWithDate:_lastPageStartDate]) {
        //  页面事件跨天
        [self resetSession];
    }
    [self updatePageAppearDate];
}

/** 生成session */
- (void)generateSessionId {
    if (![self isSameDayWithDate:_lastPageStartDate]) {
        //  页面事件跨天
        [self resetSession];
    } else if ([self isPageChangedWithDate:_lastPageStartDate]) {
        //  页面事件超过30秒
        [self resetSession];
    }
}

/**
 * 更新上一页面开始时间
 * 1.App启动 2.后台切换至前台 3.页面展现
 */
- (void)updatePageAppearDate {
    _lastPageStartDate = [NSDate date];
    [self saveLastPageAppearDate:_lastPageStartDate];
}

/** session标识 */
- (void)createSessionId {
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *randomString = [NSString stringWithFormat:@"iOS%@%u",[NSNumber numberWithLongLong:nowtime], arc4random()%1000000];
    NSString *sessionId = [randomString ansMD516Bit];
    _sessionId = sessionId;
    [self saveSession:_sessionId];
}

/** 传入date与当前时间是否同一天 */
- (BOOL)isSameDayWithDate:(NSDate *)eventDate {
    return [[NSCalendar currentCalendar] isDateInToday:eventDate];
}

/** 页面切换是否大于30秒 */
- (BOOL)isPageChangedWithDate:(NSDate *)pageDate {
    NSDate *systemZoneDate = [NSDate date];
    NSTimeInterval interval = [systemZoneDate timeIntervalSinceDate:pageDate];
    return interval > ANSSessionInterval;
}

#pragma mark - 存储
static NSString *const AnalysysSession = @"AnalysysSession";
static NSString *const AnalysysPageAppearDate = @"AnalysysPageAppearDate";
static NSString *const AnalysysPageDisappearDate = @"AnalysysPageDisappearDate";

/** 会话session */
- (void)saveSession:(NSString *)sessionId {
    [ANSFileManager saveUserDefaultWithKey:AnalysysSession value:sessionId];
}

- (NSString *)localSession {
    NSString *session = [ANSFileManager userDefaultValueWithKey:AnalysysSession];
    return session;
}

/** 上一页面展示时间 */
- (void)saveLastPageAppearDate:(NSDate *)date {
    [ANSFileManager saveUserDefaultWithKey:AnalysysPageAppearDate value:date];
}

- (NSDate *)lastPageAppearDate {
    NSDate *date = [ANSFileManager userDefaultValueWithKey:AnalysysPageAppearDate];
    return date;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
