//
//  ANSDeviceInfo.m
//  AnalysysAgent
//
//  Created by SoDo on 2018/11/22.
//  Copyright © 2018 analysys. All rights reserved.
//

#import "ANSDeviceInfo.h"
#import "AnalysysLogger.h"
#import <sys/sysctl.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "ANSKeychainItemWrapper.h"
#import "ANSLock.h"
#import "AnalysysAgentConfig.h"


static NSString *const ANSKeychainIdentifier = @"Analysys";

@interface ANSDeviceInfo ()

@property (nonatomic,strong) NSString *carrierName;
@property (nonatomic,strong) CTTelephonyNetworkInfo *networkInfo;

@end

@implementation ANSDeviceInfo

+ (instancetype)shareInstance {
    static ANSDeviceInfo *singleInstance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        singleInstance = [[self alloc] init];
        singleInstance.networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    });
    return singleInstance;
}

+ (NSString *)getSystemName {
    return [UIDevice currentDevice].systemName;
}

+ (NSString *)getSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)getDeviceName {
    return [UIDevice currentDevice].name;
}

+ (NSString *)getDeviceLanguage {
    ANSUserDefaultsLock();
    NSString * retValue = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject] copy];
    ANSUserDefaultsUnlock();
    return retValue;
}

+ (NSString *)getModel {
    return [UIDevice currentDevice].model;
}

+ (NSString *)getBundleId {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)getDeviceModel {
    NSString *model = nil;
    @try {
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char answer[size];
        sysctlbyname("hw.machine", answer, &size, NULL, 0);
        if (size) {
            model = @(answer);
        }
    } @catch (NSException *exception) {
        ANSDebug(@"[Analysys][error] %@", exception);
    }
    return model;
}

+ (NSString *)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getAppBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)getOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getIdfv {
    if (!AnalysysConfig.autoTrackDeviceId) {
        return nil;
    }
    return nil;
//
//    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)getIDFA {
//    @try {
//        Class identifierManager = NSClassFromString(@"ASIdentifierManager");
//        if (!identifierManager) {
//            return nil;
//        }
//        SEL sharedManagerSel = NSSelectorFromString(@"sharedManager");
//        if (![identifierManager respondsToSelector:sharedManagerSel]) {
//            return nil;
//        }
//        id manager = ((id (*)(id, SEL))[identifierManager methodForSelector:sharedManagerSel])(identifierManager, sharedManagerSel);
//        if (@available(iOS 14, *)) {
//            Class atTrackingManager = NSClassFromString(@"ATTrackingManager");
//            if (!atTrackingManager) {
//                return nil;
//            }
//            SEL trackEnableSel = NSSelectorFromString(@"trackingAuthorizationStatus");
//
//            if (![atTrackingManager respondsToSelector:trackEnableSel]) {
//                return nil;
//            }
//
//            NSUInteger authorizationStatus = ((NSUInteger (*)(id, SEL))[atTrackingManager methodForSelector:trackEnableSel])(atTrackingManager, trackEnableSel);
//            if (authorizationStatus == 3) {
//                return [self getIDFAWithIdentifierManager:manager];
//            }
//        } else {
//            SEL trackEnableSel = NSSelectorFromString(@"isAdvertisingTrackingEnabled");
//            if(![manager respondsToSelector:trackEnableSel]) {
//                return nil;
//            }
//            BOOL isTrackingEnable = ((BOOL (*)(id, SEL))[manager methodForSelector:trackEnableSel])(manager, trackEnableSel);
//            if (isTrackingEnable) {
//                return [self getIDFAWithIdentifierManager:manager];
//            }
//        }
//    } @catch (NSException *exception) {
//        ANSDebug(@"********** [Analysys] [Debug] %@ **********", exception.description);
//    }
    
    return nil;
}

+ (NSString *)getIDFAWithIdentifierManager:(id)manager {
    SEL advertisingIdentifierSel = NSSelectorFromString(@"advertisingIdentifier");
    if(!manager){
        return nil;
    }
    if(![manager respondsToSelector:advertisingIdentifierSel]) {
        return nil;
    }
    NSUUID *adUUID = ((NSUUID* (*)(id, SEL))[manager methodForSelector:advertisingIdentifierSel])(manager, advertisingIdentifierSel);
    return [adUUID UUIDString];
}

+ (NSString *)getDeviceID {
//    ANSKeychainItemWrapper *keychainItem = [[ANSKeychainItemWrapper alloc] initWithIdentifier:ANSKeychainIdentifier accessGroup:nil];
//    NSString *uuid = [[keychainItem objectForKey:(__bridge id)kSecValueData] objectForKey:@"UUID"]?:@"";
//    ANSDebug(@"uuid = %@",uuid);
//
//    if (uuid.length > 0) {
//        return uuid;
//    } else {
//        uuid = [[NSUUID UUID] UUIDString];
//        [keychainItem setObject:@{@"UUID":(uuid?:@"")} forKey:(__bridge id)kSecValueData];
//        return uuid;
//    }
    return @"";
}

+ (CGFloat)getScreenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)getScreenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (NSString *)getTimeZone {
    NSString *timeZone = [[NSTimeZone localTimeZone] localizedName:NSTimeZoneNameStyleStandard locale:[NSLocale systemLocale]];
    if ([timeZone isEqualToString:@"GMT"]) {
        timeZone = @"GMT+00:00";
    }
    return timeZone;
}

//+ (NSString *)getCarrierName {
//    @try {
//        CTCarrier *carrier = nil;
//        if (@available(iOS 12.0, *)) {
//            carrier = [ANSDeviceInfo shareInstance].networkInfo.serviceSubscriberCellularProviders.allValues.lastObject;
//        }
//        if(!carrier) {
//            carrier = [[ANSDeviceInfo shareInstance].networkInfo subscriberCellularProvider];
//        }
//        if ([carrier mobileNetworkCode]) {
//            [ANSDeviceInfo shareInstance].carrierName = carrier.carrierName;
//        } else {
//            [ANSDeviceInfo shareInstance].carrierName = nil;
//        }
//        return [ANSDeviceInfo shareInstance].carrierName;
//    } @catch (NSException *exception) {
//        ANSDebug(@"set mobile operatorInfo error : %@",exception);
//    }
//}

+ (NSString* )getCarrierName {
    #if TARGET_IPHONE_SIMULATOR
        return @"SIMULATOR";
    #else
    static dispatch_queue_t _queue;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"com.carr.%@", self] UTF8String], NULL);
    });
    __block NSString *  carr = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(_queue, ^(){
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.1) {
            if ([info respondsToSelector:@selector(serviceSubscriberCellularProviders)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
                NSArray *carrierKeysArray = [info.serviceSubscriberCellularProviders.allKeys sortedArrayUsingSelector:@selector(compare:)];
                carrier = info.serviceSubscriberCellularProviders[carrierKeysArray.firstObject];
                if (!carrier.mobileNetworkCode) {
                    carrier = info.serviceSubscriberCellularProviders[carrierKeysArray.lastObject];
                }
#pragma clang diagnostic pop
            }
        }
        if(!carrier) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored  "-Wdeprecated-declarations"
            carrier = info.subscriberCellularProvider;
#pragma clang diagnostic pop
        }
        if (carrier != nil) {
            NSString *networkCode = [carrier mobileNetworkCode];
            NSString *countryCode = [carrier mobileCountryCode];
            
            if (countryCode && [countryCode isEqualToString:@"460"] && networkCode) {
            
                if ([networkCode isEqualToString:@"00"] || [networkCode isEqualToString:@"02"] || [networkCode isEqualToString:@"07"] || [networkCode isEqualToString:@"08"]) {
                    carr= @"中国移动";
                }
                if ([networkCode isEqualToString:@"01"] || [networkCode isEqualToString:@"06"] || [networkCode isEqualToString:@"09"]) {
                    carr= @"中国联通";
                }
                if ([networkCode isEqualToString:@"03"] || [networkCode isEqualToString:@"05"] || [networkCode isEqualToString:@"11"]) {
                    carr= @"中国电信";
                }
                if ([networkCode isEqualToString:@"04"]) {
                    carr= @"中国卫通";
                }
                if ([networkCode isEqualToString:@"20"]) {
                    carr= @"中国铁通";
                }
            }else {
                carr = [carrier.carrierName copy];
            }
        }
        if (carr.length <= 0) {
            carr =  @"unknown";
        }
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_time_t  t = dispatch_time(DISPATCH_TIME_NOW, 0.5* NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, t);
    [ANSDeviceInfo shareInstance].carrierName = [carr copy];
    return [carr copy];
#endif
}



@end
