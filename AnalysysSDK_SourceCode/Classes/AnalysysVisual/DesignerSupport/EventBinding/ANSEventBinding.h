//
//  ANSEventBinding.h
//  AnalysysAgent
//
//  Created by analysys on 2018/4/9.
//  Copyright © 2018年 analysys. All rights reserved.
//
//  Copyright (c) 2014 Mixpanel. All rights reserved.

#import <Foundation/Foundation.h>

#import "ANSObjectSelector.h"

@interface ANSEventBinding : NSObject<NSCoding>

/** 控件唯一标识 自动生成 */
@property (nonatomic) NSUInteger ID;
/** UUID */
@property (nonatomic, copy) NSString *name;
/** 控件路径对象 */
@property (nonatomic, strong) ANSObjectSelector *path;
/** 关联控件路径对象 */
@property (nonatomic, strong) ANSObjectSelector *associated_path;
/** 埋点名称 */
@property (nonatomic, copy) NSString *eventName;
/** 需要匹配文本时对应的文本 */
@property (nonatomic, copy) NSString *matchText;
/** 服务器下发原始json数据，用于Hybrid传输 */
@property (nonatomic, copy) NSDictionary *bindingInfo;
/** 是否当前页面生效 */
@property (nonatomic, copy) NSString *targetPage;

//  tableview对应的代理类
@property (nonatomic, assign) Class swizzleClass;

@property (nonatomic) BOOL running;

+ (id)bindingWithJSONObject:(id)object;

- (instancetype)init __unavailable;
- (instancetype)initWithEventBindingInfo:(NSDictionary *)bindingInfo;

/*!
 Intercepts track calls and adds a property indicating the track event
 was from a binding
 */
+ (void)trackObject:(id)object withEventBinding:(ANSEventBinding *)eventBinding;

/*!
 Method stubs. Implement them in subclasses
 */
+ (NSString *)typeName;
- (void)executeVisualEventBinding;
- (void)stop;


@end
