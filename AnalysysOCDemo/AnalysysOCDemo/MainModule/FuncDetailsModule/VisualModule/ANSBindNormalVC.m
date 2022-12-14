//
//  ANSBindNormalVC.m
//  AnalysysSDKDemo
//
//  Created by xiao xu on 2020/2/5.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import "ANSBindNormalVC.h"

@interface ANSBindNormalVC ()
- (IBAction)clickWithBind:(id)sender;
- (IBAction)switchAction:(id)sender;
- (IBAction)segmentAction:(id)sender;
- (IBAction)stepAction:(id)sender;
- (IBAction)sliderAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ans_image;

@end

@implementation ANSBindNormalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.ans_image.accessibilityLabel = @"This is a image";
    self.ans_image.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    
    [self.ans_image addGestureRecognizer:tap];
}

- (void)click {
    NSLog(@"click");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickWithBind:(id)sender {
}

- (IBAction)switchAction:(id)sender {
}

- (IBAction)segmentAction:(id)sender {
}

- (IBAction)sliderAction:(id)sender {
}

- (IBAction)stepAction:(id)sender {
}

@end
