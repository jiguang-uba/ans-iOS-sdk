//
//  UIView+ANSAllBuryIdentifer.m
//  AnalysysAgent
//
//  Created by xiao xu on 2019/11/6.
//  Copyright © 2019 shaochong du. All rights reserved.
//

#import "UIView+ANSAllBuryIdentifer.h"
#import <objc/runtime.h>
#pragma mark - UIView
@implementation UIView (ANSAllBuryIdentifer)
- (NSString *)ans_bury_viewIndex {
    NSUInteger viewIndex = 0;
    if (self.superview) {
        viewIndex = [self.superview.subviews indexOfObject:self];
    }
    return [NSString stringWithFormat:@"%lu",(unsigned long)viewIndex];
}

- (NSString *)ans_bury_viewType {
    return NSStringFromClass(self.class);
}

- (NSString *)ans_bury_viewText {
    return nil;
}

- (NSString *)ans_bury_viewControllerName {
    if ([self.nextResponder isKindOfClass:[UIViewController class]]) {
        return NSStringFromClass([self.nextResponder class]);
    } else {
        return nil;
    }
}

- (NSString *)ans_bury_cellReuseIdentifier {
    return nil;
}

- (NSDictionary *)ans_bury_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ans_bury_viewIndex forKey:@"viewIndex"];
    [dic setObject:self.ans_bury_viewType forKey:@"viewType"];
    if (self.ans_bury_viewControllerName) {
        [dic setObject:self.ans_bury_viewControllerName forKey:@"ViewControllerName"];
    }
    return dic;
}

- (NSArray *)ans_bury_viewPath {
    NSMutableArray *array = [NSMutableArray array];
    UIView *currentView = self;
    do {
        [array addObject:currentView.ans_bury_viewIdentifer];
        currentView = currentView.superview;
    } while (currentView);
    
    return [[array reverseObjectEnumerator] allObjects];
}

@end

@implementation UILabel (ANSAllBuryIdentifer)

- (NSString *)ans_bury_viewText {
    return [NSString stringWithFormat:@"%@",self.text?:@""];
}

- (NSDictionary *)ans_bury_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ans_bury_viewIndex forKey:@"viewIndex"];
    [dic setObject:self.ans_bury_viewType forKey:@"viewType"];
    [dic setObject:self.ans_bury_viewText forKey:@"viewText"];
    return dic;
}

@end

#pragma mark - UIControl
@implementation UIButton (ANSAllBuryIdentifer)

- (NSString *)ans_bury_viewText {
    return [NSString stringWithFormat:@"%@",self.titleLabel.text?:@""];
}

- (NSDictionary *)ans_bury_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ans_bury_viewIndex forKey:@"viewIndex"];
    [dic setObject:self.ans_bury_viewType forKey:@"viewType"];
    [dic setObject:self.ans_bury_viewText forKey:@"viewText"];
    return dic;
}

@end

#pragma mark - Cell

@implementation UITableViewCell (ANSAllBuryIdentifer)

static const char * ans_bury_table_cellIndexPath = "ans_bury_table_cellIndexPath";
- (NSIndexPath *)ans_bury_table_cellIndexPath {
    return objc_getAssociatedObject(self, ans_bury_table_cellIndexPath);
}
- (void)setAns_bury_table_cellIndexPath:(NSIndexPath *)cellIndexPath {
    objc_setAssociatedObject(self, ans_bury_table_cellIndexPath, cellIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)ans_bury_cellReuseIdentifier {
    return self.reuseIdentifier;
}

- (NSDictionary *)ans_bury_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ans_bury_viewType forKey:@"viewType"];
    if (self.ans_bury_cellReuseIdentifier) {
        [dic setObject:self.ans_bury_cellReuseIdentifier forKey:@"viewReuseIdentifier"];
    }
    if (self.ans_bury_table_cellIndexPath) {
        [dic setObject:@(self.ans_bury_table_cellIndexPath.section) forKey:@"section"];
        [dic setObject:@(self.ans_bury_table_cellIndexPath.row) forKey:@"row"];
    }
    return dic;
}

@end

@implementation UICollectionViewCell (ANSAllBuryIdentifer)

static const char * ans_bury_collection_cellIndexPath = "ans_bury_collection_cellIndexPath";
- (NSIndexPath *)ans_bury_collection_cellIndexPath {
    return objc_getAssociatedObject(self, ans_bury_collection_cellIndexPath);
}
- (void)setAns_bury_collection_cellIndexPath:(NSIndexPath *)cellIndexPath {
    objc_setAssociatedObject(self, ans_bury_collection_cellIndexPath, cellIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)ans_bury_cellReuseIdentifier {
    return self.reuseIdentifier;
}

- (NSDictionary *)ans_bury_viewIdentifer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ans_bury_viewType forKey:@"viewType"];
    if (self.ans_bury_cellReuseIdentifier) {
        [dic setObject:self.ans_bury_cellReuseIdentifier forKey:@"viewReuseIdentifier"];
    }
    if (self.ans_bury_collection_cellIndexPath) {
        [dic setObject:@(self.ans_bury_collection_cellIndexPath.section) forKey:@"section"];
        [dic setObject:@(self.ans_bury_collection_cellIndexPath.item) forKey:@"item"];
    }
    return dic;
}
@end
