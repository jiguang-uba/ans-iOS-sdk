//
//  ViewController1.m
//  AnalysysOCDemo
//
//  Created by zurich on 2022/8/12.
//  Copyright © 2022 xiao xu. All rights reserved.
//

#import "ViewController1.h"
#import "SecondViewController.h"
@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIColor *random = [UIColor colorWithRed:(arc4random_uniform(256)) / 255.0 green:(arc4random_uniform(256)) / 255.0 blue:(arc4random_uniform(256)) / 255.0 alpha:1.0];
    self.view.backgroundColor = random;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = UIColor.yellowColor;
    btn.frame = CGRectMake(50, 200, 50, 20);
    btn.titleLabel.text = @"1";
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)push {
    
//    SecondViewController *vc = [[SecondViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
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
