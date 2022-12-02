//
//  ANSVisualSearch.m
//  AnalysysVisual
//
//  Created by xiao xu on 2020/2/7.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import "ANSVisualSearch.h"
#import "UIView+ANSVisualIdentifer.h"
#import "ANSVisualData.h"
#import "ANSControllerUtils.h"
#import "ANSDeviceInfo.h"
#import "ANSVisualConst.h"
#import "ANSVisualRegular.h"
#import "ANSUtil.h"
#import "ANSJsonUtil.h"
#import <WebKit/WebKit.h>

@implementation ANSVisualSearch

+ (void)findBindView:(UIView *)bindView withData:(NSArray *)bindData bindProps:(void (^)(NSString*event_id, NSDictionary *props))bindProps {
    
    __block NSArray *tmp_ans_analysysViewPath = bindView.ans_visual_viewPath;
    
    [bindData enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //匹配当前页面
        NSArray *bind_page = [[obj objectForKey:@"binding_range"] objectForKey:@"pages"];
        if (bind_page && ![bind_page containsObject:NSStringFromClass([ANSControllerUtils currentViewController].class)]) {
            return;
        }
        
        //匹配当前app版本号
        NSArray *bind_version = [[obj objectForKey:@"binding_range"] objectForKey:@"versions"];
        if (bind_version && ![bind_version containsObject:[ANSDeviceInfo getAppVersion]]) {
            return;
        }
        
        NSArray *newPath = [obj objectForKey:@"new_path"];
        NSArray *force_binding = [obj objectForKey:@"props_binding"];
        NSString *event_id = [obj objectForKey:@"event_id"];
        //按newPath查找对应的绑定控件
        if (newPath) {
            if (![self compare_path:tmp_ans_analysysViewPath dataCachePath:newPath]) {
                return;
            }
            
            //按属性查找对应控件
            if (force_binding && ![self compare_props_bind:force_binding bindView:bindView]) {
                return;
            }
            
            //找到绑定的控件/属性
            __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSDictionary *bindProperties = [self getPropsFromView:bindView withProps:[obj objectForKey:@"properties"]];
            [dic addEntriesFromDictionary:bindProperties];
            
            //查找绑定控件的关联控件/属性
            [self findRelatedPropsWithBindView:bindView relateArray:[obj objectForKey:@"related"] successBlock:^(NSArray *all_releate_props) {
                
                [all_releate_props enumerateObjectsUsingBlock:^(NSDictionary *relateProp, NSUInteger idx, BOOL * _Nonnull stop) {
                    [dic addEntriesFromDictionary:relateProp];
                }];
                
                bindProps(event_id,dic);
            }];
            
//            *stop = YES;
//            return;
            
        } else if (force_binding && [self compare_props_bind:force_binding bindView:bindView]) {
            //按force_binding查找对应的绑定控件
            //找到绑定的控件/属性
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSDictionary *bindProperties = [self getPropsFromView:bindView withProps:[obj objectForKey:@"properties"]];
            [dic addEntriesFromDictionary:bindProperties];

            //查找绑定控件的关联控件/属性
            [self findRelatedPropsWithBindView:bindView relateArray:[obj objectForKey:@"related"] successBlock:^(NSArray *all_releate_props) {
                
                [all_releate_props enumerateObjectsUsingBlock:^(NSDictionary *relateProp, NSUInteger idx, BOOL * _Nonnull stop) {
                    [dic addEntriesFromDictionary:relateProp];
                }];
                
                bindProps(event_id,dic);
            }];
            
//            *stop = YES;
//            return;
        }

    }];
}

/**
 * @param bindView 绑定控件
 * @param related 关联控件路径及相关埋点信息（可以关联多个控件）
 * @param success_block 找到关联控件从中获取的关联控件的属性(如:text、backgroundcolor、alpha)
 */
+ (void)findRelatedPropsWithBindView:(UIView *)bindView relateArray:(NSArray *)related successBlock:(void (^)(NSArray *all_releate_props))success_block {
    //原生+web 公用的关联属性数组
    __block NSMutableArray *related_props = [NSMutableArray array];
    
    //web关联数据
    __block NSMutableArray *h5_data_arr = [NSMutableArray array];
    
    //原生关联数据
    __block NSMutableArray *orgin_data_arr = [NSMutableArray array];
    
    //将原生关联数据 和 web关联数据分开
    [related enumerateObjectsUsingBlock:^(NSDictionary *relateDic, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[relateDic objectForKey:@"target"] objectForKey:@"h5_path"]) {
            [h5_data_arr addObject:relateDic];
        } else {
            [orgin_data_arr addObject:relateDic];
        }
    }];
    
    if (h5_data_arr.count > 0) {
        //先处理web数据关联，再处理原生数据关联
        [self findWebViewRelatedPropsWithBindView:bindView relateArray:h5_data_arr successBlock:^(BOOL success, NSArray *web_related_props) {
            
            //success:成功则代表所有web关联数据获取成功
            if (success) {
                [web_related_props enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
                    [related_props addObject:[ANSJsonUtil convertToMapWithString:str]];
                }];
                
                //获取原生关联属性
                [related_props addObjectsFromArray:[self findOriginRelatedPropsWithBindView:bindView relateArray:orgin_data_arr]];
            } else {
                NSLog(@"获取webview关联属性失败");
            }
            
            success_block(related_props);
        }];
    } else {
        //只处理原生数据关联
        NSArray *arr = [self findOriginRelatedPropsWithBindView:bindView relateArray:orgin_data_arr];
        success_block(arr);
    }
}

/**
* @param bindView 原生绑定控件
* @param related 关联控件路径及相关埋点信息（可以关联多个控件）
* @return array 找到关联控件从中获取的关联控件的属性(如:text、backgroundcolor、alpha)
*/
+ (NSMutableArray *)findOriginRelatedPropsWithBindView:(UIView *)bindView relateArray:(NSArray *)related {
    NSMutableArray *related_props = [NSMutableArray array];
    [related enumerateObjectsUsingBlock:^(NSDictionary *relateDic, NSUInteger idx, BOOL * _Nonnull stop) {
        //如果有控件关联，需要根据associated_step、控件属性信息，找到公共的父view，然后在从父控件向下查找关联元素
        NSArray *associated_newPath = [[relateDic objectForKey:@"target"] objectForKey:@"path"];
        NSInteger associated_step = [[[relateDic objectForKey:@"target"] objectForKey:@"step"] integerValue];
        if (associated_newPath) {
            [ANSVisualSearch findAssociatedWithViewPath:associated_newPath step:associated_step withOriginalView:bindView successBlock:^(UIView * _Nonnull associatedView) {
                //已找到关联的view，从中提取出想要获取的view属性
                NSDictionary *relateProps = [self getPropsFromView:associatedView withProps:[relateDic objectForKey:@"properties"]];
                [related_props addObject:relateProps];
            }];
        }
    }];
    return related_props;
}

/**
* @param bindView WKWebView控件
* @param related 关联控件路径及相关埋点信息（可以关联多个控件）
* @param success_block 找到关联控件从中获取的关联控件的属性(如:text、backgroundcolor、alpha)
*/
+ (void)findWebViewRelatedPropsWithBindView:(UIView *)bindView relateArray:(NSArray *)related successBlock:(void (^)(BOOL success, NSArray *web_related_props))success_block {
    __block NSMutableArray *web_related_props = [NSMutableArray array];
    __block NSInteger h5_data_count = [related count];
    if (h5_data_count > 0) {
        //处理web数据关联
        __block NSInteger h5_ret_data_count = 0;
        [related enumerateObjectsUsingBlock:^(NSDictionary *relateDic, NSUInteger idx, BOOL * _Nonnull stop) {
            //如果有控件关联，需要根据associated_step、控件属性信息，找到公共的父view，然后在从父控件向下查找关联元素
            NSArray *associated_newPath = [[relateDic objectForKey:@"target"] objectForKey:@"path"];
            NSArray *h5_path = [[relateDic objectForKey:@"target"] objectForKey:@"h5_path"];
            NSInteger associated_step = [[[relateDic objectForKey:@"target"] objectForKey:@"step"] integerValue];
            if (associated_newPath && h5_path) {
                [ANSVisualSearch findAssociatedWithViewPath:associated_newPath step:associated_step withOriginalView:bindView successBlock:^(UIView * _Nonnull associatedView) {
                    
                    //web获取关联属性
                    NSString *jsStr = [NSString stringWithFormat:@"window.AnalysysAgent.getProperty(%@)",[ANSJsonUtil convertToStringWithObject:relateDic]];
                    [((WKWebView *)associatedView) evaluateJavaScript:jsStr completionHandler:^(NSString *props, NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"WebView: getProperty error");
                        } else {
                            [web_related_props addObject:props];
                        }
                        
                        //回调计数器自增
                        h5_ret_data_count += 1;
                        
                        //执行getProperty方法回调次数等于h5数据源数量则认为所有web关联数据已处理完成
                        if (h5_data_count == h5_ret_data_count) {
                            //web所有关联属性获取成功block回调返回
                            success_block(true,web_related_props);
                        }
                    }];
                }];
            } else {
                NSLog(@"WebView: new_pat/h5_path error");
            }
        }];
    }
}

/**
 @param associated_newPath  关联控件的相对path
 @param step 绑定控件到关联控件的公共父节点的深度(用来查找公共父节点元素)
 @param originalView 当前绑定的控件
 @param successBlock 找到的关联控件
*/
+ (void)findAssociatedWithViewPath:(NSArray *)associated_newPath step:(NSInteger)step withOriginalView:(nonnull UIView *)originalView successBlock:(nonnull void (^)(UIView * _Nonnull))successBlock{
    
    //由当前点击的view，向上遍历父view
    UIView *rootView;
    
    //当前点击的控件如果到公共父节点的深度为-1（不符合逻辑）
    if (step == -1) {
        return;
    }
    
    if (step == 0) {
        //step = 0:即当前点击的控件就是公共父view
        rootView = originalView;
    } else {
        //step = x:即当前点击的控件向上走x步找到公共父view
        NSInteger tmpStep = step;
        UIView *tmpView = originalView.superview;
        while (tmpView) {
            
            tmpView = [self bridge_subviewTosuperview:tmpView];
            
            tmpStep-=1;
            if ((tmpStep == 0) &&[self compare_viewIdentifer:tmpView.ans_visual_viewIdentifer dataCacheViewIdentifer:[associated_newPath firstObject]]) {
                rootView = tmpView;
                break;
            }
            tmpView = tmpView.superview;
        }
    }
    
    
    //由公共父view按照路径，向下查找子view，如果associated_newPath.count == 1，则认为关联控件和绑定控件为同一个控件
    if (rootView && (step == 0) && (associated_newPath.count == 1)) {
        successBlock(rootView);
    } else {
        [self findDesViewFromRootView:rootView withRootPath:associated_newPath successBlock:^(UIView *associatedView) {
            successBlock(associatedView);
        }];
    }
}

/**
 * @param rootView 绑定控件和关联控件的公共父控件
 * @param rootPath 从公共父view到关联控件的相对路径
 * @param successBlock 找到的关联控件
 */
+ (void)findDesViewFromRootView:(UIView *)rootView withRootPath:(NSArray *)rootPath successBlock:(void (^)(UIView *))successBlock{
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:rootPath];
    [tmpArray removeObjectAtIndex:0];
    if (tmpArray.count == 0) {
        return;
    }
    
    if ([rootView isKindOfClass:[UIWindow class]]) {
        NSMutableArray *rootviews = [self bridge_superviewTosubviews:rootView];
        [rootviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([self compare_viewIdentifer:obj.ans_visual_viewIdentifer dataCacheViewIdentifer:[tmpArray firstObject]]) {
                *stop = YES;
                if (tmpArray.count == 1) {
                    successBlock(obj);
                } else {
                    [self findDesViewFromRootView:obj withRootPath:tmpArray successBlock:successBlock];
                }
            }
            
        }];
    } else {
        [rootView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([self compare_viewIdentifer:obj.ans_visual_viewIdentifer dataCacheViewIdentifer:[tmpArray firstObject]]) {
                *stop = YES;
                if (tmpArray.count == 1) {
                    successBlock(obj);
                } else {
                    [self findDesViewFromRootView:obj withRootPath:tmpArray successBlock:successBlock];
                }
            }
            
        }];
    }
}

/**
 * 比较：每个节点元素、数据缓存的节点元素 是否匹配（针对于cell复用标识单独处理，为了满足单行编辑、多行编辑的需求）
 * @param idf1 SDK遍历到的控件标识
 * @param idf2 从服务端拉取下来的path中控件标识（缓存数据）
 * @return bool 两个标识是否相同
 */
+ (BOOL)compare_viewIdentifer:(NSDictionary *)idf1 dataCacheViewIdentifer:(NSDictionary *)idf2 {
    if ([idf2 objectForKey:ANSReuseIdentifier]) {
        if ([idf2 objectForKey:ANSSection]) {
            return [idf1 isEqualToDictionary:idf2];
        } else {
            return [[NSSet setWithArray:idf2.allValues] isSubsetOfSet:[NSSet setWithArray:idf1.allValues]];
        }
    } else {
        return [idf1 isEqualToDictionary:idf2];
    }
}

/**
* 判断两条控件路径是否相同
* @param path1 SDK遍历生成的控件路径
* @param path2 从服务端拉取下来的控件路径（缓存数据）
* @return bool 两个路径是否相同
*/
+ (BOOL)compare_path:(NSArray *)path1 dataCachePath:(NSArray *)path2 {
    if (path1 && path2) {
        if (path1.count == path2.count) {
            __block BOOL b = YES;
            [path1 enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![self compare_viewIdentifer:obj dataCacheViewIdentifer:[path2 objectAtIndex:idx]]) {
                    *stop = YES;
                    b = NO;
                }
            }];
            return b;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

/**
 * 判断控件属性是否相同
 * @param force_binding 从服务端拉取下来的控件属性（缓存数据）
 * @param bindView 当前点击的控件
 * @return bool 当前控件属性是否与缓存属性信息相同
 */
+ (BOOL)compare_props_bind:(NSArray *)force_binding bindView:(UIView *)bindView {
    
    NSInteger i = 0;
    for (NSDictionary *force_bindingDic in force_binding) {
        if (![force_bindingDic isKindOfClass:[NSDictionary class]]) {
            break;
        }
        NSString *name = [force_bindingDic objectForKey:@"prop_name"];
        NSString *val = [force_bindingDic objectForKey:@"value"];
        if ([name isEqualToString:@"class"] && [((UIView *)bindView).ans_visual_viewType isEqualToString:val]) {
            NSLog(@"class 属性匹配成功");
            i += 1;
        } else if ([name isEqualToString:@"text"] && [((UIView *)bindView).ans_visual_viewText isEqualToString:val]) {
            NSLog(@"text 属性匹配成功");
            i += 1;
        } else {
            NSLog(@"force_binding 匹配失败");
            break;
        }
    }
    
    if (i == force_binding.count) {
        return YES;
    } else {
        return NO;
    }
}

/**
 * 根据服务端下发的properties 获取 view属性/自定义属性
 * @param view 获取属性的控件
 * @param props 要获取的相关属性列表
 */
+ (NSDictionary *)getPropsFromView:(UIView *)view withProps:(NSArray *)props {
    NSMutableDictionary *retProps = [NSMutableDictionary dictionary];
    [props enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *key = [obj objectForKey:@"key"];
        NSString *prop_type = [obj objectForKey:@"prop_type"];
        NSString *prop_name = [obj objectForKey:@"prop_name"];
        NSString *regex = [obj objectForKey:@"regex"];
        
        id value = [obj objectForKey:@"value"];
        if (value) {
            //用户手动输入的值
            [retProps setObject:value forKey:key];
        } else {
            //SDK获取的UI控件的属性
            NSString *ret = [self getPropValueFromView:view type:prop_type name:prop_name];
            
            if (regex) {
                //如果存在正则，用正则提取信息
                ret = [[ANSVisualRegular regularExtract:regex checkString:ret] firstObject];
            }
            
            //将控件的属性进行类型转换
            id convert_ret = [self convertPropsValue:ret withType:prop_type];
            
            if (convert_ret) {
                [retProps setObject:convert_ret forKey:key];
            }
        }
    }];
    return retProps;
}

/**
* 获取具体属性值并进行类型转换
* @param currentView 当前获取属性的view
* @param name 要获取具体属性信息（如：text、class）
*/
+ (id)getPropValueFromView:(UIView *)currentView type:(NSString *)type name:(NSString *)name {
    if (!type || !name) {
        return nil;
    }
    
    if ([name isEqualToString:@"text"]) {
        NSString *text = currentView.ans_visual_viewText;
        return text;
    } else if ([name isEqualToString:@"class"]) {
        NSString *cla = NSStringFromClass([currentView class]);
        return cla;
    } else {
        return nil;
    }
}

/**
* 属性值进行上报类型转换
* @param value 获取的属性（如：text、class）
* @param type 要进行转换的类型（如：number、string、bool）
*/
+ (id)convertPropsValue:(NSString *)value withType:(NSString *)type {
    if (!value || !type) {
        return nil;
    }
    
    if ([type isEqualToString:@"number"]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        if ([f numberFromString:value]) {
            return [NSNumber numberWithFloat:[value floatValue]];
        } else {
            return value;
        }
    } else if ([type isEqualToString:@"bool"]) {
        return [NSNumber numberWithBool:[value boolValue]];
    } else {
        return value;
    }
}

/**
* 通过控件类名从某个根view查找该类型的控件
* @param name 要查找的控件类名（如：UIButton、UILabel、WKWebView 等）
* @param roots 查找的根源（如：UIWindow 等）
* @param desViews 查找到的view
*/
+ (void)findViewWithClassName:(NSString *)name fromRoot:(NSArray *)roots desView:(void (^)(UIView * desViews))desViews {
    [roots enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(name)]) {
            desViews(obj);
        }
        [self findViewWithClassName:name fromRoot:obj.subviews desView:desViews];
    }];
}

/**
* case1:以iOS13系统在UIWindow下新增了UITransitionView、UIDropShadowView 为了统一new_path由 子->父 需要将该两节点去掉
*/
+ (UIView *)bridge_subviewTosuperview:(UIView *)view {
    if ([NSStringFromClass([view class]) isEqualToString:@"UIDropShadowView"] &&
        [NSStringFromClass([view.superview class]) isEqualToString:@"UITransitionView"]) {
        return view.superview.superview;
    } else {
        return view;
    }
}

/**
* case1:以iOS13系统在UIWindow下新增了UITransitionView、UIDropShadowView 为了统一节点匹配 由 父->子 需要将该两节点去掉
*/
+ (NSMutableArray *)bridge_superviewTosubviews:(UIView *)view {
    NSMutableArray *rootviews = [NSMutableArray array];
    [((UIWindow *)view).subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"UITransitionView"] &&
            [NSStringFromClass([[[obj subviews] firstObject] class]) isEqualToString:@"UIDropShadowView"]) {
            if (((UIWindow *)view).rootViewController) {
                [rootviews addObject:((UIWindow *)view).rootViewController.view];
            }
        } else {
            [rootviews addObject:obj];
        }
    }];
    return rootviews;
}

@end
