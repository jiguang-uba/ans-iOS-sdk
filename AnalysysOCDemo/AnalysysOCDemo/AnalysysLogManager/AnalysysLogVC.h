//
//  AnalysysLogVC.h
//  AnalysysOCDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlock)(void);

@interface AnalysysLogVC : UIViewController

@property (nonatomic, copy) CallBackBlock callBackBlock;

@end

