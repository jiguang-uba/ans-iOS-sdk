//
//  ViewControllerx.m
//  AnalysysOCDemo
//
//  Created by zurich on 2022/8/12.
//  Copyright © 2022 xiao xu. All rights reserved.
//

#import "ViewControllerx.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
@interface ViewControllerx ()

@end

@implementation ViewControllerx

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ViewController1 *vc = [[ViewController1 alloc] init];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, 150, 300);
    [self.view addSubview:vc.view];

    ViewController2 *vc2 = [[ViewController2 alloc] init];
    vc2.view.frame = CGRectMake(160, 0, 150, 300);
    [self addChildViewController:vc2];
    [self.view addSubview:vc2.view];
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
