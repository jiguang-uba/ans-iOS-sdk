//
//  PageViewDuration.h
//  AnalysysAgent
//
//  Created by person on 2021/2/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageViewDuration : NSObject

+(PageViewDuration *)sharedInstance;

-(void)start;

-(void)ans_ViewDidAppear:(UIViewController *)controller;

-(void)applicationWillResignActiveNotification:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
