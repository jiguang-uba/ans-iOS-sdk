//
//  AnalysysLogDetailVC.m
//  AnalysysOCDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

#import "AnalysysLogDetailVC.h"
#import "AnalysysJson.h"
@interface AnalysysLogDetailVC ()

@end

@implementation AnalysysLogDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"日志详情";
    
    NSString *str = [AnalysysJson convertToStringWithObject:self.logDic];
    if (str) {
        self.logTextView.text = str;
    }
}


@end
