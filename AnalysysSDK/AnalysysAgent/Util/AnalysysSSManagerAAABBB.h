//
//  AnalysysSSManagerAAABBB.h
//  gyro
//
//  Created by jesse on 2022/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnalysysSSManagerAAABBB : NSObject

+ (instancetype)sharedManager;

-(void) setCacheDataLength:(int)length;
-(void) setCollectDataReverse:(BOOL)reverse;
-(void) setUseGravity:(BOOL)useGravity;
-(void) setRate:(float)rate;

-(void) setListenDuration:(int)duration;
-(void) startListen;
-(void) stopListen;

@end

NS_ASSUME_NONNULL_END
