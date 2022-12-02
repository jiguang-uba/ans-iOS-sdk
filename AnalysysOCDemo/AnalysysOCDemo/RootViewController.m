//
//  RootViewController.m
//  AnalysysOCDemo
//
//  Created by zurich on 2022/8/12.
//  Copyright © 2022 xiao xu. All rights reserved.
//

#import "RootViewController.h"
#import "ViewControllerx.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ViewControllerx *vc = [[ViewControllerx alloc] init];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    //[AnalysysAgent track:@"12"];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
