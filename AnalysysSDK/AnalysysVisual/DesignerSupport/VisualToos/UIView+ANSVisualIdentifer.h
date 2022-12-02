//
//  UIView+ANSVisualIdentifer.h
//  AnalysysAgent
//
//  Created by xiao xu on 2019/11/6.
//  Copyright © 2019 shaochong du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ANSVisualIdentiferProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIView (ANSVisualIdentifer) <ANSVisualIdentiferProtocol>

@end

@interface UILabel (ANSVisualIdentifer) <ANSVisualIdentiferProtocol>

@end

@interface UITextView (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UIProgressView (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UIImageView (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UITabBar (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UINavigationBar (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UISearchBar (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end



#pragma mark - UIControl

@interface UIControl (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UIButton (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UIDatePicker (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UIPageControl (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UISegmentedControl (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UITextField (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UISlider (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UISwitch (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

@interface UIStepper (ANSVisualIdentifer)<ANSVisualIdentiferProtocol>

@end

#pragma mark - Cell

@interface UITableViewHeaderFooterView (ANSVisualIdentifer) <ANSVisualIdentiferProtocol>
@property (nonatomic, copy) NSString *ans_visual_tableView_headerFooter_kind;
@property (nonatomic, assign) NSInteger ans_visual_tableView_section;
@end

@interface UITableViewCell (ANSVisualIdentifer) <ANSVisualIdentiferProtocol>
@property (nonatomic, strong) NSIndexPath *ans_visual_tableView_cell_indexPath;
@end

@interface UICollectionReusableView (ANSVisualIdentifer) <ANSVisualIdentiferProtocol>
@property (nonatomic,copy) NSString *ans_visual_collection_reusable_kind;
@property (nonatomic, strong) NSIndexPath *ans_visual_collection_reusableView_indexPath;
@end

@interface UICollectionViewCell (ANSVisualIdentifer) <ANSVisualIdentiferProtocol>
@property (nonatomic, strong) NSIndexPath *ans_visual_collection_cell_indexPath;
@end

NS_ASSUME_NONNULL_END
