//
//  AnalysysLogger.h
//  AnalysysAgent
//
//  Created by SoDo on 2019/10/14.
//  Copyright © 2019 shaochong du. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline void AnsDebugLog(NSString *format, ...) {
    va_list arg_list;
    va_start (arg_list, format);
    NSString *logString = [[NSString alloc] initWithFormat:format arguments:arg_list];
    va_end(arg_list);
    NSLog(@"********** [Analysys] [Debug] %@ **********", logString);
}

//  是否开启调试日志
//#define ANS_DEBUG_ENABLE

#ifdef ANS_DEBUG_ENABLE
#define ANSDebug(...) AnsDebugLog(__VA_ARGS__);
#else
#define ANSDebug(...)
#endif



#define PrintAnalaysLog(module,briefLog,lvl,fmt,...)       \
    [AnalysysLogger logModule : module                 \
                        brief : briefLog               \
                        level : lvl                    \
                        file  : __FILE__               \
                     function : __PRETTY_FUNCTION__    \
                        line  : __LINE__               \
                        format: (fmt), ## __VA_ARGS__]

#define ANSLog(fmt,...) PrintAnalaysLog(@"",NO,AnalysysLoggerInfo,(fmt), ## __VA_ARGS__)

#define ANSBriefLog(fmt,...) PrintAnalaysLog(@"Analysys",YES,AnalysysLoggerInfo,(fmt), ## __VA_ARGS__)
#define ANSBriefWarning(fmt,...) PrintAnalaysLog(@"Analysys",YES,AnalysysLoggerWarning,(fmt), ## __VA_ARGS__)
#define ANSBriefError(fmt,...) PrintAnalaysLog(@"Analysys",YES,AnalysysLoggerError,(fmt), ## __VA_ARGS__)

#define ANSVisualBriefLog(fmt,...) PrintAnalaysLog(@"AnalysysVisual",YES,AnalysysLoggerInfo,(fmt), ## __VA_ARGS__)
#define ANSVisualBriefWarning(fmt,...) PrintAnalaysLog(@"AnalysysVisual",YES,AnalysysLoggerWarning,(fmt), ## __VA_ARGS__)
#define ANSVisualBriefError(fmt,...) PrintAnalaysLog(@"AnalysysVisual",YES,AnalysysLoggerError,(fmt), ## __VA_ARGS__)

typedef NS_ENUM(NSUInteger, AnalysysLoggerLevel) {
    AnalysysLoggerInfo = 0,
    AnalysysLoggerWarning,
    AnalysysLoggerError,
};

typedef NS_ENUM(NSInteger, AnalysysLogMode) {
    AnalysysLogOff = 0,
    AnalysysLogOn = 1,
};


/**
 * @class
 * 日志打印
 *
 * @abstract
 * 日志打印
 *
 * @discussion
 * 日志打印
 */
@interface AnalysysLogger : NSObject

@property (class , readonly, strong) AnalysysLogger *sharedInstance;

@property (nonatomic, assign) AnalysysLogMode logMode;

+ (BOOL)isLoggerEnabled;

+ (void)enableLog:(BOOL)enableLog;

+ (void)logModule:(NSString *)module
            brief:(BOOL)briefLog
            level:(NSInteger)level
             file:(const char *)file
         function:(const char *)function
             line:(NSUInteger)line
           format:(NSString *)format, ... ;

@end


