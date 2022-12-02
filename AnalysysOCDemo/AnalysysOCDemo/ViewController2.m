//
//  ViewController2.m
//  AnalysysOCDemo
//
//  Created by zurich on 2022/8/12.
//  Copyright © 2022 xiao xu. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIColor *random = [UIColor colorWithRed:(arc4random_uniform(256)) / 255.0 green:(arc4random_uniform(256)) / 255.0 blue:(arc4random_uniform(256)) / 255.0 alpha:1.0];
    self.view.backgroundColor = random;
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
