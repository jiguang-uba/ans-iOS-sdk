//
//  ANSSessionManager.h
//  AnalysysAgent
//
//  Created by SoDo on 2018/12/5.
//  Copyright © 2018 analysys. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class
 * ANSSessionManager
 *
 * @abstract
 * session模块
 *
 * @discussion
 * 生成数据中sessionid，跟随上传事件
 * session切换规则，以page展现为判断点（优先级高->低）：
 * 1. App被调起；
 * 2. 两次触发事件跨天；
 * 3. App首次启动；
 * 4. A页面结束时间与B页面开始时间 间隔大于30s
 */


@interface ANSSessionManager : NSObject

/** 当前session */
@property (nonatomic, copy) NSString *sessionId;

+ (instancetype)sharedManager;

/// 开启session监控
- (void)monitorSession;

/// session重置
- (void)resetSession;


@end


