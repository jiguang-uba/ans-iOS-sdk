//
//  UIView+ANSVisualIdentiferProtocol.m
//  AnalysysAgent
//
//  Created by xiao xu on 2019/11/6.
//  Copyright © 2019 shaochong du. All rights reserved.
//

#import "UIView+ANSVisualIdentifer.h"
#import <objc/runtime.h>
#import "ANSControllerUtils.h"
#import "ANSUtil.h"
#import "ANSVisualConst.h"
#import "ANSVisualSearch.h"
#pragma mark - UIView
@implementation UIView (ANSVisualIdentifer)

- (BOOL)isControllerView {
    if ([[self nextResponder] isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)[self nextResponder];
        if (self == vc.view) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (NSString *)ans_visual_viewIndex {
    NSUInteger viewIndex = 0;
    if (self.superview) {
        if ([self isKindOfClass:NSClassFromString(@"UISegment")] && [self.superview isKindOfClass:NSClassFromString(@"UISegmentedControl")]) {
            UISegmentedControl *segmentedControl = (UISegmentedControl *)self.superview;
            if (segmentedControl && (segmentedControl.numberOfSegments == segmentedControl.subviews.count)) {
                NSUInteger originIndex = [segmentedControl.subviews indexOfObject:self];
                viewIndex = originIndex + segmentedControl.numberOfSegments + 1;
            } else {
                NSUInteger originIndex = [segmentedControl.subviews indexOfObject:self];
                viewIndex = originIndex;
            }
            return [NSString stringWithFormat:@"%lu",(unsigned long)viewIndex];
        } else {
            viewIndex = [self.superview.subviews indexOfObject:self];
            return [NSString stringWithFormat:@"%lu",(unsigned long)viewIndex];
        }
    } else {
        if ([self isKindOfClass:[UIWindow class]]) {
            viewIndex = [[ANSUtil windows] indexOfObject:self];
            return [NSString stringWithFormat:@"%lu",(unsigned long)viewIndex];
        } else {
            return nil;
        }
    }
}

- (NSString *)ans_visual_viewType {
    return NSStringFromClass(self.class);
}

- (NSString *)ans_visual_viewText {
    if ([self isKindOfClass:[NSClassFromString(@"_UIButtonBarButton") class]] ||
        [self isKindOfClass:[NSClassFromString(@"UITabBarButton") class]]) {
        return [ANSControllerUtils contentFromView:self];
    } else if ([self isKindOfClass:NSClassFromString(@"RCTView")] ||
               [self isKindOfClass:NSClassFromString(@"RCTTextView")]) {
        if ([self respondsToSelector:@selector(accessibilityLabel)]) {
            NSString *text = [self performSelector:@selector(accessibilityLabel)];
            return text;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSString *)ans_visual_viewControllerName {
    if ([self isControllerView]) {
        return NSStringFromClass([self.nextResponder class]);
    } else {
        return nil;
    }
}

- (NSString *)ans_visual_cellReuseIdentifier {
    return nil;
}

- (NSDictionary *)ans_visual_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ans_visual_viewType forKey:ANSViewClassName];
    if (self.ans_visual_viewControllerName) {
        [dic setObject:self.ans_visual_viewControllerName forKey:ANSViewControllerName];
    } else {
        if ([self.ans_visual_viewType isEqualToString:@"_UIBarBackground"]) {
            [dic setObject:@"0" forKey:ANSViewIndex];
        } else if ([self.ans_visual_viewType isEqualToString:@"_UINavigationBarContentView"]) {
            [dic setObject:@"1" forKey:ANSViewIndex];
        } else if (self.ans_visual_viewType) {
            [dic setObject:self.ans_visual_viewIndex forKey:ANSViewIndex];
        }
    }
    
    return dic;
}

- (NSArray *)ans_visual_viewPath {
    NSMutableArray *array = [NSMutableArray array];
    UIView *currentView = self;
    do {
        [array addObject:currentView.ans_visual_viewIdentifer];
//        if (currentView.isControllerView) {
//            break;
//        }
        currentView = [ANSVisualSearch bridge_subviewTosuperview:currentView.superview];
    } while (currentView);
    
    return [[array reverseObjectEnumerator] allObjects];
}

@end

@implementation UILabel (ANSVisualIdentiferProtocol)

- (NSString *)ans_visual_viewText {
    return [NSString stringWithFormat:@"%@",self.text?:@""];
}

- (NSDictionary *)ans_visual_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.ans_visual_viewIndex) {
        [dic setObject:self.ans_visual_viewIndex forKey:ANSViewIndex];
    }
    [dic setObject:self.ans_visual_viewType forKey:ANSViewClassName];
//    [dic setObject:self.ans_analysysViewText forKey:@"viewText"];
    return dic;
}

@end

@implementation UITextView (ANSVisualIdentiferProtocol)

- (NSString *)ans_visual_viewText {
    return [NSString stringWithFormat:@"%@",self.text?:@""];
}

@end

@implementation UISearchBar (ANSVisualIdentiferProtocol)

- (NSString *)ans_visual_viewText {
    return [NSString stringWithFormat:@"%@",self.text?:@""];
}

@end

#pragma mark - UIControl
@implementation UIButton (ANSVisualIdentiferProtocol)

//暂时不适应UIButton的text文本作为控件标识唯一性判断，因为在tableview列表中复用的button会出现文案不匹配情况
- (NSString *)ans_visual_viewText {
    return [NSString stringWithFormat:@"%@",self.titleLabel.text?:@""];
}

- (NSDictionary *)ans_visual_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.ans_visual_viewIndex) {
        [dic setObject:self.ans_visual_viewIndex forKey:ANSViewIndex];
    }
    [dic setObject:self.ans_visual_viewType forKey:ANSViewClassName];
    return dic;
}

@end

@implementation UITextField (ANSVisualIdentiferProtocol)

- (NSString *)ans_visual_viewText {
    return [NSString stringWithFormat:@"%@",self.text?:@""];
}

@end

#pragma mark - Cell
@implementation UITableViewHeaderFooterView (ANSVisualIdentiferProtocol)

static const char * ans_visual_tableView_headerFooter_kind = "ans_visual_tableView_headerFooter_kind";
- (NSString *)ans_visual_tableView_headerFooter_kind {
    return objc_getAssociatedObject(self, ans_visual_tableView_headerFooter_kind);
}
- (void)setAns_visual_tableView_headerFooter_kind:(NSString *)visual_kind {
    objc_setAssociatedObject(self, ans_visual_tableView_headerFooter_kind, visual_kind, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

static const char * ans_visual_tableView_section = "ans_visual_tableView_section";
- (NSInteger)ans_visual_tableView_section {
    return [objc_getAssociatedObject(self, ans_visual_tableView_section) integerValue];
}
- (void)setAns_visual_tableView_section:(NSInteger)visual_section {
    objc_setAssociatedObject(self, ans_visual_tableView_section, @(visual_section), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)ans_analysysHeaderFooterReuseIdentifier {
    return self.reuseIdentifier;
}

- (NSDictionary *)ans_visual_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ans_visual_viewType forKey:ANSViewClassName];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.ans_visual_tableView_section] forKey:ANSSection];
    if (self.ans_analysysHeaderFooterReuseIdentifier) {
        [dic setObject:self.ans_analysysHeaderFooterReuseIdentifier forKey:ANSReuseIdentifier];
    }
    if (self.ans_visual_tableView_headerFooter_kind) {
        [dic setObject:self.ans_visual_tableView_headerFooter_kind forKey:ANSKind];
    }
    
    return dic;
}
@end

@implementation UITableViewCell (ANSVisualIdentiferProtocol)

static const char * ans_visual_tableView_cell_indexPath = "ans_visual_tableView_cell_indexPath";
- (NSIndexPath *)ans_visual_tableView_cell_indexPath {
    return objc_getAssociatedObject(self, ans_visual_tableView_cell_indexPath);
}
- (void)setAns_visual_tableView_cell_indexPath:(NSIndexPath *)visual_cell_indexPath {
    objc_setAssociatedObject(self, ans_visual_tableView_cell_indexPath, visual_cell_indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)ans_visual_cellReuseIdentifier {
    return self.reuseIdentifier;
}

- (NSDictionary *)ans_visual_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ans_visual_viewType forKey:ANSViewClassName];
    if (self.ans_visual_cellReuseIdentifier) {
        [dic setObject:self.ans_visual_cellReuseIdentifier forKey:ANSReuseIdentifier];
    }
    if (self.ans_visual_tableView_cell_indexPath) {
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.ans_visual_tableView_cell_indexPath.section] forKey:ANSSection];
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.ans_visual_tableView_cell_indexPath.row] forKey:ANSRow];
    }
    return dic;
}

@end

@implementation UICollectionReusableView (ANSVisualIdentiferProtocol)

static const char * ans_visual_collection_reusable_kind = "ans_visual_collection_reusable_kind";
- (NSString *)ans_visual_collection_reusable_kind {
    return objc_getAssociatedObject(self, ans_visual_collection_reusable_kind);
}
- (void)setAns_visual_collection_reusable_kind:(NSString *)visual_kind {
    objc_setAssociatedObject(self, ans_visual_collection_reusable_kind, visual_kind, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

static const char *ans_visual_collection_reusableView_indexPath = "ans_visual_collection_reusableView_indexPath";
- (NSIndexPath *)ans_visual_collection_reusableView_indexPath {
    return objc_getAssociatedObject(self, ans_visual_collection_reusableView_indexPath);
}
- (void)setAns_visual_collection_reusableView_indexPath:(NSIndexPath *)visual_reusableView_indexPath {
    objc_setAssociatedObject(self, ans_visual_collection_reusableView_indexPath, visual_reusableView_indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)ans_analysysCollectionReuseIdentifier {
    return self.reuseIdentifier;
}

- (NSDictionary *)ans_visual_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ans_visual_viewType forKey:ANSViewClassName];
    if (self.ans_analysysCollectionReuseIdentifier) {
        [dic setObject:self.ans_analysysCollectionReuseIdentifier forKey:ANSReuseIdentifier];
    }
    if (self.ans_visual_collection_reusable_kind) {
        [dic setObject:self.ans_visual_collection_reusable_kind forKey:ANSKind];
    }
    if (self.ans_visual_collection_reusableView_indexPath) {
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.ans_visual_collection_reusableView_indexPath.section] forKey:ANSSection];
    }
    return dic;
}

@end

@implementation UICollectionViewCell (ANSVisualIdentiferProtocol)

static const char * ans_visual_collection_cell_indexPath = "ans_visual_collection_cell_indexPath";
- (NSIndexPath *)ans_visual_collection_cell_indexPath {
    return objc_getAssociatedObject(self, ans_visual_collection_cell_indexPath);
}
- (void)setAns_visual_collection_cell_indexPath:(NSIndexPath *)visual_cell_indexPath {
    objc_setAssociatedObject(self, ans_visual_collection_cell_indexPath, visual_cell_indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)ans_visual_cellReuseIdentifier {
    return self.reuseIdentifier;
}

- (NSDictionary *)ans_visual_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ans_visual_viewType forKey:ANSViewClassName];
    if (self.ans_visual_cellReuseIdentifier) {
        [dic setObject:self.ans_visual_cellReuseIdentifier forKey:ANSReuseIdentifier];
    }
    if (self.ans_visual_collection_cell_indexPath) {
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.ans_visual_collection_cell_indexPath.section] forKey:ANSSection];
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.ans_visual_collection_cell_indexPath.item] forKey:ANSItem];
    }
    return dic;
}
@end
