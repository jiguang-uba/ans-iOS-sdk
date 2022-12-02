//
//  ANSDeviceInfo.m
//  AnalysysAgent
//
//  Created by SoDo on 2018/11/22.
//  Copyright © 2018 analysys. All rights reserved.
//

#import "ANSDeviceInfo.h"
#import <sys/sysctl.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "ANSKeychainItemWrapper.h"
#import "ANSLock.h"

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
        NSLog(@"[Analysys][error] %@", exception);
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
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)getIDFA {
    @try {
        Class identifierManager = NSClassFromString(@"ASIdentifierManager");
        if (!identifierManager) {
            return nil;
        }
        SEL sharedManagerSel = NSSelectorFromString(@"sharedManager");
        if (![identifierManager respondsToSelector:sharedManagerSel]) {
            return nil;
        }
        id manager = ((id (*)(id, SEL))[identifierManager methodForSelector:sharedManagerSel])(identifierManager, sharedManagerSel);
        if (@available(iOS 14, *)) {
            Class atTrackingManager = NSClassFromString(@"ATTrackingManager");
            if (!atTrackingManager) {
                return nil;
            }
            SEL trackEnableSel = NSSelectorFromString(@"trackingAuthorizationStatus");
            NSUInteger authorizationStatus = ((NSUInteger (*)(id, SEL))[atTrackingManager methodForSelector:trackEnableSel])(atTrackingManager, trackEnableSel);
            if (authorizationStatus == 3) {
                return [self getIDFAWithIdentifierManager:manager];
            }
        } else {
            SEL trackEnableSel = NSSelectorFromString(@"isAdvertisingTrackingEnabled");
            BOOL isTrackingEnable = ((BOOL (*)(id, SEL))[manager methodForSelector:trackEnableSel])(manager, trackEnableSel);
            if (isTrackingEnable) {
                return [self getIDFAWithIdentifierManager:manager];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"********** [Analysys] [Debug] %@ **********", exception.description);
    }
    
    return nil;
}

+ (NSString *)getIDFAWithIdentifierManager:(id)manager {
    SEL advertisingIdentifierSel = NSSelectorFromString(@"advertisingIdentifier");
    NSUUID *adUUID = ((NSUUID* (*)(id, SEL))[manager methodForSelector:advertisingIdentifierSel])(manager, advertisingIdentifierSel);
    return [adUUID UUIDString];
}

+ (NSString *)getDeviceID {
    ANSKeychainItemWrapper *keychainItem = [[ANSKeychainItemWrapper alloc] initWithIdentifier:ANSKeychainIdentifier accessGroup:nil];
    NSString *uuid = [[keychainItem objectForKey:(__bridge id)kSecValueData] objectForKey:@"UUID"]?:@"";
    NSLog(@"uuid = %@",uuid);
    
    if (uuid.length > 0) {
        return uuid;
    } else {
        uuid = [[NSUUID UUID] UUIDString];
        [keychainItem setObject:@{@"UUID":(uuid?:@"")} forKey:(__bridge id)kSecValueData];
        return uuid;
    }
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

+ (NSString *)getCarrierName {
    @try {
        CTCarrier *carrier = nil;
        if (@available(iOS 12.0, *)) {
            carrier = [ANSDeviceInfo shareInstance].networkInfo.serviceSubscriberCellularProviders.allValues.lastObject;
        }
        if(!carrier) {
            carrier = [[ANSDeviceInfo shareInstance].networkInfo subscriberCellularProvider];
        }
        if ([carrier mobileNetworkCode]) {
            [ANSDeviceInfo shareInstance].carrierName = carrier.carrierName;
        } else {
            [ANSDeviceInfo shareInstance].carrierName = nil;
        }
        return [ANSDeviceInfo shareInstance].carrierName;
    } @catch (NSException *exception) {
        NSLog(@"set mobile operatorInfo error : %@",exception);
    }
}

@end
