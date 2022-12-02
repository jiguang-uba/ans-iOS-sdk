//
//  AnalysysSSManagerAAABBB.m
//  gyro
//
//  Created by jesse on 2022/10/28.
//
#ifndef INTERNAL_LOCK
#define INTERNAL_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef INTERNAL_UNLOCK
#define INTERNAL_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif

#import "AnalysysSSManagerAAABBB.h"
#import <CoreMotion/CoreMotion.h>
#import "AnalysysAgent.h"
#import "AnalysysLogger.h"

@interface AnalysysSSManagerAAABBB ()
@property(atomic,strong) CMMotionManager* motionManager;
@property(atomic,assign) int dataLength;
@property(nonatomic,assign) BOOL internalUseGravity;
@property(nonatomic,assign) BOOL collectReverse;
@property(nonatomic,assign) int runingDuration;
@property(nonatomic,assign) float refreshRate;
@property(nonatomic,strong) NSMutableArray *gyroDataArray;
@property(nonatomic,strong) NSMutableArray *accDataArray;
@end

static dispatch_semaphore_t param_locker () {
    static dispatch_semaphore_t _locker;
    static dispatch_once_t _once;
    dispatch_once(&_once, ^{
        _locker = dispatch_semaphore_create(1);
    });
    return _locker;
}

@implementation AnalysysSSManagerAAABBB
{
    dispatch_source_t _fire_timer;
    dispatch_semaphore_t _timer_locker;
}

+ (instancetype)sharedManager {
    static id singleInstance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        ANSLog(@"%s",__func__);
        singleInstance = [[self alloc] init] ;
    });
    return singleInstance;
}

- (instancetype)init {
    ANSLog(@"%s",__func__);
    self = [super init];
    if (self) {
        CMMotionManager *manager = [[CMMotionManager alloc] init];
        self.motionManager = manager;
        self.gyroDataArray = [[NSMutableArray alloc] init];
        self.accDataArray = [[NSMutableArray alloc] init];
        _timer_locker = dispatch_semaphore_create(1);
    }
    return self;
}

-(void) setCacheDataLength:(int)length {
    ANSLog(@"%s",__func__);
    self.dataLength = length;
}

-(void) setCollectDataReverse:(BOOL)reverse {
    ANSLog(@"%s",__func__);
    INTERNAL_LOCK(param_locker())
    self.collectReverse = reverse;
    INTERNAL_UNLOCK(param_locker())
}

-(void) setRate:(float)rate {
    ANSLog(@"%s",__func__);
    INTERNAL_LOCK(param_locker())
    self.refreshRate = rate;
    INTERNAL_UNLOCK(param_locker())
}

-(void) setUseGravity:(BOOL)useGravity{
    ANSLog(@"%s",__func__);
    INTERNAL_LOCK(param_locker())
    self.internalUseGravity = useGravity;
    INTERNAL_UNLOCK(param_locker())
}

-(void) setListenDuration:(int)duration {
    ANSLog(@"%s",__func__);
    INTERNAL_LOCK(param_locker())
    self.runingDuration = duration;
    INTERNAL_UNLOCK(param_locker())
    [self start_timer:duration];
}

-(void) start_timer:(int)duration {
    ANSLog(@"%s",__func__);
    INTERNAL_LOCK(_timer_locker)
    [self stop_heartbeat_timer];
    _fire_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    __weak typeof(self) weakSelf = self;
    ANSLog(@"%s starting fire timer. duration:%d",__func__, duration);
    dispatch_source_set_event_handler(_fire_timer, ^{
        ANSLog(@"%s timer fired",__func__);
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        [strongSelf stopListen];
    });
    dispatch_time_t tt = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
    dispatch_source_set_timer(_fire_timer, tt, DISPATCH_TIME_FOREVER, 0);
    dispatch_resume(_fire_timer);
    INTERNAL_UNLOCK(_timer_locker)
}

-(void) stop_heartbeat_timer {
    ANSLog(@"%s",__func__);
    if (_fire_timer)
    {
        dispatch_source_cancel(_fire_timer);
        _fire_timer = NULL;
    }
}

-(void) startListen {
    ANSLog(@"%s",__func__);
    [self.motionManager stopDeviceMotionUpdates];
    [self.motionManager stopGyroUpdates];
    [self.motionManager stopAccelerometerUpdates];
    
    float _refresh_rate = 0.02;
    bool _use_gravity = false;
    
    INTERNAL_LOCK(param_locker())
    [self.gyroDataArray removeAllObjects];
    [self.accDataArray removeAllObjects];
    if (self.refreshRate >0.001) {
        _refresh_rate = self.refreshRate;
    }
    _use_gravity = self.internalUseGravity;
    INTERNAL_UNLOCK(param_locker())
    
    if (_use_gravity) {
        if (self.motionManager.isGyroAvailable) {
            self.motionManager.gyroUpdateInterval = _refresh_rate;
            if (!self.motionManager.isGyroActive) {
                [self.motionManager startGyroUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
                    if (!error && gyroData) {
                        NSString *gyroString = [NSString stringWithFormat:@"%f,%f,%f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z];
                        [self addString:gyroString toContainer:self.gyroDataArray];
                    }
                }];
            }
        }
        if (self.motionManager.isAccelerometerAvailable) {
            self.motionManager.accelerometerUpdateInterval = _refresh_rate;
            if (!self.motionManager.isAccelerometerActive) {
                [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
                    if (!error && accelerometerData) {
                        NSString *accString = [NSString stringWithFormat:@"%f,%f,%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z];
                        [self addString:accString toContainer:self.accDataArray];
                    }
                }];
            }
        }
    }else {
        if (self.motionManager.isDeviceMotionAvailable ) {
            self.motionManager.deviceMotionUpdateInterval = _refresh_rate;
            if (!self.motionManager.isDeviceMotionActive) {
                
                [self.motionManager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
                    if (!error && motion) {
                        NSString *gyroString = [NSString stringWithFormat:@"%f,%f,%f",motion.rotationRate.x,motion.rotationRate.y,motion.rotationRate.z];
                        NSString *accString = [NSString stringWithFormat:@"%f,%f,%f",motion.userAcceleration.x,motion.userAcceleration.y,motion.userAcceleration.z];
                        [self addString:gyroString toContainer:self.gyroDataArray];
                        [self addString:accString toContainer:self.accDataArray];
                    }
                }];
            }
        }
    }
}


-(void) addString:(NSString *)obj toContainer:(NSMutableArray *)root {
    [self addString:obj toContainer:root containerLength:self.dataLength];
}

-(void) addString:(NSString *)obj toContainer:(NSMutableArray *)root containerLength:(int)_length{
    INTERNAL_LOCK(param_locker())
    [root addObject:obj?:@""];
    
    if (root.count > _length) {
        if (self.collectReverse) {
            [root removeLastObject];
        }else {
            [root removeObjectAtIndex:0];
        }
    }
    INTERNAL_UNLOCK(param_locker())
}



-(void) stopListen {
    ANSLog(@"%s",__func__);
    [self.motionManager stopDeviceMotionUpdates];
    [self.motionManager stopGyroUpdates];
    [self.motionManager stopAccelerometerUpdates];
    
    INTERNAL_LOCK(param_locker())
    NSArray *tempSendingGyroArray = [NSArray arrayWithArray:[self.gyroDataArray mutableCopy]];
    NSArray *tempSendingAccArray = [NSArray arrayWithArray:[self.accDataArray mutableCopy]];
    
    [self.gyroDataArray removeAllObjects];
    [self.accDataArray removeAllObjects];
    INTERNAL_UNLOCK(param_locker())
    
    if (tempSendingGyroArray.count == 0 || tempSendingAccArray.count == 0) {
        ANSLog(@"%s tempSendingGyroArray.count:%d tempSendingAccArray.count:%d",__func__,tempSendingGyroArray.count,tempSendingAccArray.count);
        return;
    }
    
    NSMutableDictionary* sendingDictionary = [NSMutableDictionary dictionary];
    sendingDictionary[@"gyro"] = tempSendingGyroArray?:@[];
    sendingDictionary[@"acc"]  = tempSendingAccArray?:@[];
    [AnalysysAgent track:@"sensor" properties:sendingDictionary];
}

@end
