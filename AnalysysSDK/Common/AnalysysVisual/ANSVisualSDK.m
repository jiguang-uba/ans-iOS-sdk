//
//  ANSVisualSDK.m
//  AnalysysVisual
//
//  Created by SoDo on 2019/2/12.
//  Copyright © 2019 analysys. All rights reserved.
//

#import "ANSVisualSDK.h"

#import "AnalysysSDK.h"
#import "AnalysysAgentConfig.h"

#import "ANSFileManager.h"
#import "ANSNetworking.h"
#import "ANSABTestDesignerConnection.h"
#import "ANSEventBinding.h"
#import "AnalysysLogger.h"

#import "ANSSwizzler.h"
#import "ANSTelephonyNetwork.h"
#import "ANSDeviceInfo.h"
#import "ANSReachability.h"
#import "ANSUtil.h"
#import "ANSControllerUtils.h"

#import "ANSConst+private.h"
#import "UIView+ANSHelper.h"
#import "UIView+ANSVisualIdentifer.h"
#import "NSObject+ANSSwizzling.h"

#import "ANSBundleUtil.h"
#import "ANSJsonUtil.h"
#import "ANSVisualSearch.h"
#import "ANSVisualData.h"
#import "ANSVisualSwizzler.h"

#import <WebKit/WebKit.h>

#define AgentLock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER);
#define AgentUnlock() dispatch_semaphore_signal(self->_lock);

//  可视化埋点 默认端口
static NSString *const ANSWebsocketDefaultPort = @"4091";
//  可视化配置 默认端口
static NSString *const ANSVisualConfigDefaultPort = @"4089";

@implementation UIGestureRecognizer (ANSVisualGestureRecognizer)
- (instancetype)ans_visual_initWithTarget:(id)target action:(SEL)action {
    [self ans_visual_initWithTarget:target action:action];
    //  仅处理tap手势
    if ([self isKindOfClass:UITapGestureRecognizer.class]) {
        [self removeTarget:target action:action];
        [self addTarget:target action:action];
    }
    return self;
}

- (void)ans_visual_addTarget:(id)target action:(SEL)action {
    //  仅处理tap手势
    if ([self isKindOfClass:UITapGestureRecognizer.class]) {
        [self ans_visual_addTarget:self action:@selector(visualClick:)];
    }
    [self ans_visual_addTarget:target action:action];
}

- (void)visualClick:(UIGestureRecognizer *)gesture {
    if([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        if (gesture.state != UIGestureRecognizerStateEnded) {
            return;
        }
        UIView *view = gesture.view;
        if (!view ||
            [view isKindOfClass:NSClassFromString(@"RNCSlider")]) {
            return;
        }
        [[ANSVisualSDK sharedManager] findBindView:view];
    } else {
        
    }
}
@end

@implementation UICollectionView (SearchPath)

- (void)ans_visual_setDataSource:(id)dataSource {
    [self ans_visual_setDataSource:dataSource];
    
    [ANSVisualSwizzler swizzleSelector:@selector(collectionView:cellForItemAtIndexPath:) onClass:[dataSource class] withBlock:^(UICollectionViewCell *cell, id self, SEL _cmd, UICollectionView *collectionView, NSIndexPath *indexPath){
        
        cell.ans_visual_collection_cell_indexPath = indexPath;
        
    } named:[NSString stringWithFormat:@"%@_collectionView:cellForItemAtIndexPath:",NSStringFromClass([dataSource class])]];
    
    [ANSVisualSwizzler swizzleSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:) onClass:[dataSource class] withBlock:^(UICollectionReusableView *reusableView, id self, SEL _cmd, UICollectionView *collectionView, NSString *kind, NSIndexPath *indexPath){
        
        if ([reusableView isKindOfClass:[UICollectionReusableView class]]) {
            reusableView.ans_visual_collection_reusable_kind = kind;
            reusableView.ans_visual_collection_reusableView_indexPath = indexPath;
        }
        
    } named:[NSString stringWithFormat:@"%@_collectionView:viewForSupplementaryElementOfKind:atIndexPath:",NSStringFromClass([dataSource class])]];
}

- (void)ans_visual_setDelegate:(id)delegate {
    [self ans_visual_setDelegate:delegate];
    
    [ANSVisualSwizzler swizzleSelector:@selector(collectionView:didSelectItemAtIndexPath:) onClass:[delegate class] withBlock:^(id self, SEL _cmd, UICollectionView *collectionView, NSIndexPath *indexPath){
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [[ANSVisualSDK sharedManager] findBindView:cell];
        
    } named:[NSString stringWithFormat:@"%@_collectionView:didSelectItemAtIndexPath:",NSStringFromClass([delegate class])]];
    
    [ANSVisualSwizzler swizzleSelector:@selector(collectionView:didDeselectItemAtIndexPath:) onClass:[delegate class] withBlock:^(id self, SEL _cmd, UICollectionView *collectionView, NSIndexPath *indexPath){
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [[ANSVisualSDK sharedManager] findBindView:cell];
        
    } named:[NSString stringWithFormat:@"%@_collectionView:didDeselectItemAtIndexPath:",NSStringFromClass([delegate class])]];
    
}

@end

@implementation UITableView (SearchPath)

- (void)ans_visual_setDataSource:(id)dataSource {
    [self ans_visual_setDataSource:dataSource];
    
    [ANSVisualSwizzler swizzleSelector:@selector(tableView:cellForRowAtIndexPath:) onClass:[dataSource class] withBlock:^(UITableViewCell *cell, id self, SEL _cmd, UITableView *tableView, NSIndexPath *indexPath){
        
        cell.ans_visual_tableView_cell_indexPath = indexPath;
        
    } named:[NSString stringWithFormat:@"%@_tableView:cellForRowAtIndexPath:",NSStringFromClass([dataSource class])]];
}

- (void)ans_visual_setDelegate:(id)delegate {
    [self ans_visual_setDelegate:delegate];
    
    [ANSVisualSwizzler swizzleSelector:@selector(tableView:viewForHeaderInSection:) onClass:[delegate class] withBlock:^(UITableViewHeaderFooterView *sectionHeader, id self, SEL _cmd, UITableView *tableView, NSInteger section){
        
        if ([sectionHeader isKindOfClass:[UITableViewHeaderFooterView class]]) {
            sectionHeader.ans_visual_tableView_headerFooter_kind = @"UITableViewElementKindSectionHeader";
            sectionHeader.ans_visual_tableView_section = section;
        }
        
    } named:[NSString stringWithFormat:@"%@_tableView:viewForHeaderInSection:",NSStringFromClass([delegate class])]];
    
    [ANSVisualSwizzler swizzleSelector:@selector(tableView:viewForFooterInSection:) onClass:[delegate class] withBlock:^(UITableViewHeaderFooterView *sectionFooter, id self, SEL _cmd, UITableView *tableView, NSInteger section){
        
        if ([sectionFooter isKindOfClass:[UITableViewHeaderFooterView class]]) {
            sectionFooter.ans_visual_tableView_headerFooter_kind = @"UITableViewElementKindSectionFooter";
            sectionFooter.ans_visual_tableView_section = section;
        }
        
    } named:[NSString stringWithFormat:@"%@_tableView:viewForFooterInSection:",NSStringFromClass([delegate class])]];
    
    [ANSVisualSwizzler swizzleSelector:@selector(tableView:didSelectRowAtIndexPath:) onClass:[delegate class] withBlock:^(id self, SEL _cmd, UITableView *tableView, NSIndexPath *indexPath){
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[ANSVisualSDK sharedManager] findBindView:cell];
        
    } named:[NSString stringWithFormat:@"%@_tableView:didSelectRowAtIndexPath:",NSStringFromClass([delegate class])]];
    
    [ANSVisualSwizzler swizzleSelector:@selector(tableView:didDeselectRowAtIndexPath:) onClass:[delegate class] withBlock:^(id self, SEL _cmd, UITableView *tableView, NSIndexPath *indexPath){
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[ANSVisualSDK sharedManager] findBindView:cell];
        
    } named:[NSString stringWithFormat:@"%@_tableView:didDeselectRowAtIndexPath:",NSStringFromClass([delegate class])]];
}

@end


@interface ANSVisualSDK ()

@property (nonatomic, strong) ANSNetworking *visualNetworking;
@property (nonatomic, strong) NSSet *eventBindings;
@property (nonatomic, strong) ANSABTestDesignerConnection *designerConnection;
@property (nonatomic, copy) NSString *connectUrl;
@property (nonatomic, copy) NSString *configUrl;
@property (nonatomic, assign) BOOL isOpenVisual;
@end

@implementation ANSVisualSDK {
    dispatch_queue_t _networkQueue;
    dispatch_semaphore_t _lock;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedManager {
    static id singleInstance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        if (!singleInstance) {
            singleInstance = [[self alloc] init] ;
        }
    });
    return singleInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = dispatch_semaphore_create(0);
        NSString *netLabel = [NSString stringWithFormat:@"com.analysys.VisualNetworkQueue"];
        _networkQueue = dispatch_queue_create([netLabel UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)openVisual {
    self.isOpenVisual = YES;
    @try {
        if ([[ANSVisualData sharedManager] isOpenVisualDebug]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
            });
            
            [ANSSwizzler swizzleSelector:@selector(motionBegan:withEvent:) onClass:[UIApplication class] withBlock:^(id view, SEL command, UIEventSubtype motion, UIEvent *event) {
                [self monitorVisualMotionBegan:motion withEvent:event];
            } named:@"ANSVisualMotion"];
        }
        
        [UIGestureRecognizer ansExchangeOriginalSel:@selector(initWithTarget:action:) replacedSel:@selector(ans_visual_initWithTarget:action:)];
        [UIGestureRecognizer ansExchangeOriginalSel:@selector(addTarget:action:) replacedSel:@selector(ans_visual_addTarget:action:)];
        
        [UICollectionView ansExchangeOriginalSel:@selector(setDataSource:) replacedSel:@selector(ans_visual_setDataSource:)];
        [UICollectionView ansExchangeOriginalSel:@selector(setDelegate:) replacedSel:@selector(ans_visual_setDelegate:)];
        
        [UITableView ansExchangeOriginalSel:@selector(setDataSource:) replacedSel:@selector(ans_visual_setDataSource:)];
        [UITableView ansExchangeOriginalSel:@selector(setDelegate:) replacedSel:@selector(ans_visual_setDelegate:)];
        
        [ANSSwizzler swizzleSelector:@selector(sendEvent:) onClass:[UIApplication class] withBlock:^(id view, SEL command, UIEvent *event){
            [self monitoVisualSendEvent:event];
        } named:@"ANSVisualSendEvent"];
        
        [ANSSwizzler swizzleSelector:@selector(sendAction:to:from:forEvent:) onClass:[UIApplication class] withBlock:^(id vc, SEL cmd, SEL sel, id target, id sender, UIEvent *event){
            
            // 忽略可视化绑定控件
            NSArray *ignoreActions = @[@"ans_preVerify:forEvent:", @"ans_execute:forEvent:", @"autotracker_monitorAction:"];
            if ([ignoreActions containsObject:NSStringFromSelector(sel)]) {
                return;
            }
            
            //忽略WKWebView的WKContentView事件
            if ([sender isKindOfClass:NSClassFromString(@"WKContentView")] ||
                [sender isKindOfClass:NSClassFromString(@"RNCSlider")]) {
                return;
            }
            
            if ([sender isKindOfClass:[UISwitch class]] ||
                [sender isKindOfClass:[UIStepper class]] ||
                [sender isKindOfClass:[UISegmentedControl class]]) {
                
                [self findBindView:sender];
                return;
            }
            
            if (event.type == UIEventTypeTouches) {
                UITouch *touch = [event.allTouches anyObject];
                if (touch.phase == UITouchPhaseEnded && [sender isKindOfClass:[UIView class]]) {
                    
                    [self findBindView:sender];
                }
            }
        } named:@"ANSVisual_sendAction:to:from:forEvent:"];
        
        [self registNotifications];
        
        [self unarchiveEventBindings];
        
        [self executeEventBindings];
        
    } @catch (NSException *exception) {
        ANSDebug(@"%@",exception);
    }
}

+ (void)visual_viewClicked:(NSNumber * _Nonnull)view_id {
    if ([[self sharedManager] isOpenVisual]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Class mager = NSClassFromString(@"ANSReactNativeManager");
            SEL viewWithReactTag = NSSelectorFromString(@"viewWithReactTag:");
            if ([mager respondsToSelector:viewWithReactTag]) {

                id view = [mager performSelector:viewWithReactTag withObject:view_id];
                if (view) {
                    if ([view isKindOfClass:NSClassFromString(@"RCTView")] ||
                        [view isKindOfClass:NSClassFromString(@"RNCSlider")] || [view isKindOfClass:NSClassFromString(@"RCTTextView")]) {
                        [[self sharedManager] findBindView:view];
                    }
                }
            }
        });
    } else {
        
    }
    
}

- (void)findBindView:(UIView *)sender {
    @try {
        NSArray *bindData;
        if (self.designerConnection.connected) {
            bindData = [[ANSVisualData sharedManager] websocketnVData];
        } else {
            bindData = [[ANSVisualData sharedManager] nVData];
        }
        
        [ANSVisualSearch findBindView:sender withData:bindData bindProps:^(NSString*event_id, NSDictionary *props) {
            [self trackEventID:event_id trackView:sender withProperties:props];
        }];
    } @catch (NSException *exception) {
        ANSDebug(@"%@",exception);
    }
    
}

#pragma mark - SDK配置

/** 初始化埋点及下发地址 */
- (void)setVisualBaseUrl:(NSString *)baseUrl {
    if (baseUrl.length == 0) {
        ANSVisualBriefLog(@"Please set baseURL first.");
        return;
    }
    NSString *serverlUrl = [NSString stringWithFormat:@"wss://%@:%@", baseUrl, ANSWebsocketDefaultPort];
    [self setVisualServerUrl:serverlUrl];
    
    NSString *configUrl = [NSString stringWithFormat:@"https://%@:%@", baseUrl, ANSVisualConfigDefaultPort];
    [self setVisualConfigUrl:configUrl];
}

/** 设置可视化埋点地址 */
- (void)setVisualServerUrl:(NSString *)visualUrl {
    self.connectUrl = @"";
    if (self.designerConnection) {
        [self.designerConnection close];
    }
        
    NSString *url = [ANSUtil getSocketUrlString:visualUrl];
    if (url.length > 0) {
        self.connectUrl = [NSString stringWithFormat:@"%@?appkey=%@&version=%@&os=ios",url, AnalysysConfig.appKey, [ANSDeviceInfo getAppVersion]];
        [ANSVisualData sharedManager].isOpenVisualDebug = YES;
        ANSVisualBriefLog(@"Set visual url success. url: %@", self.connectUrl);
    } else {
        ANSVisualBriefWarning(@"Set visual url failed. Visual url must start with 'ws://' or 'wss://'.");
    }
}

/** 设置可视化埋点配置下发地址 */
- (void)setVisualConfigUrl:(NSString *)configUrl {
    self.configUrl = @"";
    
    NSString *url = [ANSUtil getHttpUrlString:configUrl];
    if (url.length > 0) {
        
        self.configUrl = [NSString stringWithFormat:@"%@/configure", url];
        
        NSString *absoluteURLString = [NSString stringWithFormat:@"%@?appKey=%@&appVersion=%@&lib=iPhone",self.configUrl, AnalysysConfig.appKey, [ANSDeviceInfo getAppVersion]];
        ANSVisualBriefLog(@"Set visual config url success. url: %@", absoluteURLString);
        
        self.visualNetworking = [[ANSNetworking alloc] initWithURL:[NSURL URLWithString:self.configUrl]];
        self.visualNetworking.securityPolicy = AnalysysConfig.securityPolicy;
        
        [self openVisual];
        
        [self loadServerBindings];
    } else {
        ANSVisualBriefWarning(@"Set visual config url failed. Visual config url must start with 'http://' or 'https://'.");
    }
}

#pragma mark - 可视化操作

/// 摇一摇连接可视化
/// @param motion object
/// @param event event
- (void)monitorVisualMotionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        [self connectToServer:NO];
    }
}

/** 触发新版可视化埋点事件 */
- (void)trackEventID:(NSString *)event_id trackView:(id)trackView withProperties:(NSDictionary *)properties {
    if (self.designerConnection.connected) {
        [self echoVisualEvent:event_id view:trackView withProperties:properties];
        return;
    }
    ANSVisualBriefLog(@"Report event:%@ properties:%@", event_id, [ANSJsonUtil convertToStringWithObject:properties]);
    [[AnalysysSDK sharedManager] track:event_id properties:properties];
}

/// 事件点击 获取当前控件文本信息
/// @param event event
- (void)monitoVisualSendEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        UITouch *touch = [event.allTouches anyObject];
        if (touch.view && touch.phase == UITouchPhaseBegan) {
            self.currentPage = NSStringFromClass([ANSControllerUtils currentViewController].class);
            self.controlText = [touch.view ansElementText];
        }
    }
}

#pragma mark - websocket连接

/** 开始长连接 是否重连 */
- (void)connectToServer:(BOOL)reconnect {
    if (self.connectUrl.length == 0) {
        ANSVisualBriefLog(@"Please set visual url first!");
        return;
    }
    
    if ([self.designerConnection isKindOfClass:[ANSABTestDesignerConnection class]] && ((ANSABTestDesignerConnection *)self.designerConnection).connected) {
        ANSDebug(@"websocket connection already exists");
        return;
    }
    
    ANSVisualBriefLog(@"Gesture detected");
    
    void (^connectCallback)(void) = ^{
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [ANSVisualData sharedManager].isConnectingWS = true;
        //  连接websocket后，停止configure请求的所有binding事件
        for (ANSEventBinding *binding in self.eventBindings) {
            [binding stop];
        }
        [self synchronousWebData:nil];
    };
    
    void (^disconnectCallback)(void) = ^{
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        [ANSVisualData sharedManager].isConnectingWS = false;
        [[ANSVisualData sharedManager].websocketnVData removeAllObjects];
        [self synchronousWebData:nil];
    };
    
    NSURL *designerURL = [NSURL URLWithString:self.connectUrl];
    self.designerConnection = [[ANSABTestDesignerConnection alloc] initWithURL:designerURL
                                                                    keepTrying:reconnect
                                                               connectCallback:connectCallback
                                                            disconnectCallback:disconnectCallback];
}

/** 新版可视化App端埋点后 点击回显 */
- (void)echoVisualEvent:(NSString *)event view:(id)trackView withProperties:(NSDictionary *)properties{
    if ([trackView isKindOfClass:[UIView class]]) {
        UIWindow *window = [ANSUtil currentKeyWindow];
        UIView *view = (UIView *)trackView;
        CGRect position = [view convertRect:view.bounds toView:window];
        if (position.origin.y > window.frame.size.height) {
            position = [view.superview convertRect:view.bounds toView:window];
        }
        [self echoWebVisualEvent:event position:position withProperties:properties];
    }
}

/**
 可视化埋点状态下 服务器回显
 
 @param eventName 绑定事件名称
 @param position 控件绝对坐标
 */

- (void)echoWebVisualEvent:(NSString *)eventName position:(CGRect)position withProperties:(NSDictionary *)properties{
    NSMutableDictionary *responseInfo = [NSMutableDictionary dictionary];
    responseInfo[@"$event_id"] = eventName;
    responseInfo[@"$app_version"] = [ANSDeviceInfo getAppVersion];
    responseInfo[@"$manufacturer"] = @"Apple";
    responseInfo[@"$model"] = [ANSDeviceInfo getDeviceModel];
    responseInfo[@"$os_version"] = [ANSDeviceInfo getOSVersion];
    responseInfo[@"$lib_version"] = ANSSDKVersion;
    responseInfo[@"$network"] = [[ANSTelephonyNetwork shareInstance] telephonyNetworkDescrition];
    responseInfo[@"$screen_width"] = [NSString stringWithFormat:@"%.0f",[ANSDeviceInfo getScreenWidth]];
    responseInfo[@"$screen_height"] = [NSString stringWithFormat:@"%.0f",[ANSDeviceInfo getScreenHeight]];
    responseInfo[@"$pos_left"] = [NSString stringWithFormat:@"%.1f",position.origin.x];
    responseInfo[@"$pos_top"] = [NSString stringWithFormat:@"%.1f",position.origin.y];
    responseInfo[@"$pos_width"] = [NSString stringWithFormat:@"%.1f",position.size.width];
    responseInfo[@"$pos_height"] = [NSString stringWithFormat:@"%.1f",position.size.height];
    if (properties) {
        [responseInfo addEntriesFromDictionary:properties];
    }
    [self.designerConnection sendJsonMessage:@{
        @"event_info": responseInfo,
        @"type":@"eventinfo_request",
        @"target_page": self.currentPage ?: @""
    }];
}

#pragma mark - 内部方法

- (void)registNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(reachabilityChangedNotification:)
                               name:ANSNetworkChangedNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(synchronousWebData:)
                               name:@"ANSVisualSynchronousWebData"
                             object:nil];
}

/** 解档本地数据 */
- (void)unarchiveEventBindings {
    self.eventBindings = [ANSFileManager unarchiveEventBindings];
    [ANSVisualData sharedManager].nVData = [[[ANSFileManager unarchiveNewEventBindings] allObjects] mutableCopy];
}

/** 归档可视化数据 */
- (void)archiveEventBindings {
    [ANSFileManager archiveEventBindings:self.eventBindings];
    [ANSFileManager archiveNewEventBindings:[NSSet setWithArray:[ANSVisualData sharedManager].nVData]];
}

/** 绑定本地可视化数据 */
- (void)executeEventBindings {
    for (id binding in self.eventBindings) {
        if ([binding isKindOfClass:[ANSEventBinding class]]) {
            [binding executeVisualEventBinding];
        }
    }
}

/** 请求服务器绑定事件 */
- (void)loadServerBindings {
    if (self.configUrl.length == 0) {
        ANSVisualBriefWarning(@"Please set visual config url first!");
        return;
    }
    
    if (![[ANSTelephonyNetwork shareInstance] hasNetwork]) {
        ANSVisualBriefWarning(@"Please check the network.");
        return;
    }
    
    if (self.designerConnection.connected) {
        ANSDebug(@"-----------正在进行可视化埋点，不重新获取configure数据-----------");
        return;
    }
    
    dispatch_async(_networkQueue, ^{
        __weak typeof(self) weakSelf = self;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"appKey"] = AnalysysConfig.appKey;
        params[@"appVersion"] = [ANSDeviceInfo getAppVersion];
        params[@"lib"] = @"iPhone";

        [self.visualNetworking getRequestWithParameters:params success:^(NSURLResponse *response, NSData *responseData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSError *error;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            
            if (error) {
                ANSVisualBriefLog(@"Get visual config list failed: %@.", error.description);
                AgentUnlock()
                return;
            }
            
            NSMutableArray *eventArray = [NSMutableArray array];
            NSArray *dataArr = responseDict[@"data"];
            for (NSDictionary *eventDic in dataArr) {
                NSDictionary *info = @{@"event_id": eventDic[@"event_id"] ?: @"",
                                       @"event_name": eventDic[@"event_name"] ?: @""};
                [eventArray addObject:info];
            }
            ANSVisualBriefLog(@"Get visual config list success.\n%@", [ANSJsonUtil convertToStringWithObject:eventArray]);
            
            //将新版可视化数据和旧版可视化数据区分开
            [ANSVisualData dealWithResponseData:responseDict];
            
            NSMutableSet *serverEventBindings = [NSMutableSet set];
            id visualEvents = [ANSVisualData sharedManager].oVData;
            
            if ([visualEvents isKindOfClass:[NSArray class]]) {
                //  停止已绑定事件
                [self.eventBindings makeObjectsPerformSelector:NSSelectorFromString(@"stop")];
                
                //  停止可视化连接中已绑定的控件，防止重复绑定
                //  原因：可视化埋点后（更新等），主动断开websocket，可能修改埋点与已部署埋点控件为同一个
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AnalysysCleanBindings" object:nil];
                
                for (id obj in visualEvents) {
                    ANSEventBinding *binding = [ANSEventBinding bindingWithJSONObject:obj];
                    if (binding) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [binding executeVisualEventBinding];
                        });
                        [serverEventBindings addObject:binding];
                    }
                }
            } else {
                ANSVisualBriefLog(@"Get visual config list failed: %@.", responseDict);
                AgentUnlock()
                return;
            }
            
            strongSelf.eventBindings = [serverEventBindings copy];
            [strongSelf archiveEventBindings];
            
            AgentUnlock()
        } failure:^(NSError *error) {
            AgentUnlock()
            ANSVisualBriefLog(@"Get visual config list failed: %@.", error.description);
        }];
        
        AgentLock()
    });
}

#pragma mark - 通知
/** 网络变化，防止App首次启动无网未获取数据 */
- (void)reachabilityChangedNotification:(NSNotification *)notification {
    ANSReachability *reachability = notification.object;
    if (self.eventBindings.count == 0 &&
        reachability.networkStatus != ANSNotReachable) {
        [self loadServerBindings];
    }
}

/** 接收到ws协议，增删改，每次同步数据给js-sdk*/
- (void)synchronousWebData:(NSNotification *)notification {
    @try {
        [ANSVisualSearch findViewWithClassName:@"WKWebView" fromRoot:[ANSUtil windows] desView:^(UIView * _Nonnull desViews) {
            if (desViews) {
                NSString *javaScript = [NSString stringWithFormat:@"window.AnalysysAgent.onEventList(%@)",[ANSJsonUtil convertToStringWithObject:[ANSVisualData sharedManager].isConnectingWS?[ANSVisualData getWebViewDebugData]:[ANSVisualData getWebViewData]]];
                [((WKWebView *)desViews) evaluateJavaScript:javaScript completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
                    
                }];
            }
        }];
    } @catch (NSException *exception) {
        ANSVisualBriefError(@"%@",exception);
    }
}


@end
