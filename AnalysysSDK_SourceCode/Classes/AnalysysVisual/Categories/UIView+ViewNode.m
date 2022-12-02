//
//  UIView+ViewNode.m
//  AnalysysVisual
//
//  Created by xiao xu on 2020/5/15.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import "UIView+ViewNode.h"
#import <objc/runtime.h>
@implementation UIView (ViewNode)

- (void)setH5_views:(NSString *)h5_views {
    objc_setAssociatedObject(self, @selector(h5_views), h5_views, OBJC_ASSOCIATION_COPY);
}

- (NSArray *)h5_views {
    return objc_getAssociatedObject(self, @selector(h5_views));
}

@end
