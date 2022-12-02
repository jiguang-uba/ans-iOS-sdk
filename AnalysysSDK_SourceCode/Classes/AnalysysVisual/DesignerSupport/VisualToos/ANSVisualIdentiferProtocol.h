//
//  ANSAllBuryIdentiferProtocol.h
//  AnalysysAgent
//
//  Created by xiao xu on 2019/11/6.
//  Copyright © 2019 shaochong du. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol ANSVisualIdentiferProtocol <NSObject>

/** view是否是控制器view */
@property (nonatomic, assign, readonly) BOOL isControllerView;

/** 控件相对于父控件index */
@property (nonatomic, copy, readonly) NSString *ans_visual_viewIndex;

/** 控件类型 如：uibutton、uiswitch等 */
@property (nonatomic, copy, readonly) NSString *ans_visual_viewType;

/** 控件上的文本 如：uibutton-title、uilabel-text等 */
@property (nonatomic, copy, readonly) NSString *ans_visual_viewText;

/** 控件所属控制器名称 如：UIViewController等 */
@property (nonatomic, copy, readonly) NSString *ans_visual_viewControllerName;

/** cell - reuseIdentifier */
@property (nonatomic, copy, readonly) NSString *ans_visual_cellReuseIdentifier;

/** 控件标识*/
@property (nonatomic, copy, readonly) NSDictionary *ans_visual_viewIdentifer;

/** 控件路径*/
@property (nonatomic, copy, readonly) NSArray *ans_visual_viewPath;

@end

NS_ASSUME_NONNULL_END
