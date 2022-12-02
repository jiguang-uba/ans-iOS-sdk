//
//  ANSConfigVC.m
//  AnalysysOCDemo
//
//  Created by xiao xu on 2020/7/17.
//  Copyright © 2020 xiao xu. All rights reserved.
//

#import "ANSConfigVC.h"
#import "AnalysysDataCache.h"

#define kDefaultAppKey @"heatmaptest0916"
#define kDefaultUploadUrl @"http://192.168.220.105:8089"
#define kDefaultVisualUrl @"ws://192.168.220.105:9091"
#define kDefaultConfigUrl @"http://192.168.220.105:8089"

@interface ANSConfigVC ()
- (IBAction)changeConfig:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *appkey_tf;
@property (weak, nonatomic) IBOutlet UITextField *channel_tf;
@property (weak, nonatomic) IBOutlet UITextField *upload_url_tf;
@property (weak, nonatomic) IBOutlet UITextField *debug_url_tf;
@property (weak, nonatomic) IBOutlet UITextField *config_url_tf;
@end

@implementation ANSConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改配置";
    
    self.appkey_tf.text = [AnalysysDataCache get_appkey]?:kDefaultAppKey;
    self.channel_tf.text = [AnalysysDataCache get_channel]?:@"App Store";
    self.upload_url_tf.text = [AnalysysDataCache get_upload_url]?:kDefaultUploadUrl;
    self.debug_url_tf.text = [AnalysysDataCache get_debug_url]?:kDefaultVisualUrl;
    self.config_url_tf.text = [AnalysysDataCache get_config_url]?:kDefaultConfigUrl;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)resetConfig:(id)sender {
    //  存储
    [AnalysysDataCache set_appkey:kDefaultAppKey];
    [AnalysysDataCache set_channel:@"App Store"];
    [AnalysysDataCache set_upload_url:kDefaultUploadUrl];
    [AnalysysDataCache set_debug_url:kDefaultVisualUrl];
    [AnalysysDataCache set_config_url:kDefaultConfigUrl];
    
    //  更新UI
    self.appkey_tf.text = kDefaultAppKey;
    self.channel_tf.text = @"App Store";
    self.upload_url_tf.text = kDefaultUploadUrl;
    self.debug_url_tf.text = kDefaultVisualUrl;
    self.config_url_tf.text = kDefaultConfigUrl;
    
    // 重新设置SDK
    AnalysysConfig.appKey = kDefaultAppKey;
    AnalysysConfig.channel = @"App Store";
    [AnalysysAgent startWithConfig:AnalysysConfig];
    
    [AnalysysAgent setUploadURL:kDefaultUploadUrl];
    [AnalysysAgent setVisitorDebugURL:kDefaultVisualUrl];
    [AnalysysAgent setVisitorConfigURL:kDefaultConfigUrl];
    
    
    [self showTitle:@"恢复默认配置" message:[NSString stringWithFormat:@"%@",@{@"AppKey" : kDefaultAppKey, @"Channel" : @"App Store", @"UploadURL" : kDefaultUploadUrl, @"DebugURL" : kDefaultVisualUrl, @"ConfigURL" : kDefaultUploadUrl}]];
}

- (IBAction)changeConfig:(id)sender {
    if (self.appkey_tf.text.length == 0) {
        [AnalysysHUD showTitle:@"提示" message:@"请输入AppKey"];
        return;
    } else if (self.channel_tf.text.length == 0) {
        [AnalysysHUD showTitle:@"提示" message:@"请输入Channel"];
        return;
    } else if (self.upload_url_tf.text.length == 0) {
        [AnalysysHUD showTitle:@"提示" message:@"请输入UploadURL"];
        return;
    } else if (self.debug_url_tf.text.length == 0) {
        [AnalysysHUD showTitle:@"提示" message:@"请输入DebugURL"];
        return;
    } else if (self.config_url_tf.text.length == 0) {
        [AnalysysHUD showTitle:@"提示" message:@"请输入ConfigURL"];
        return;
    }
    
    [AnalysysDataCache set_appkey:self.appkey_tf.text];
    [AnalysysDataCache set_channel:self.channel_tf.text];
    [AnalysysDataCache set_upload_url:self.upload_url_tf.text];
    [AnalysysDataCache set_debug_url:self.debug_url_tf.text];
    [AnalysysDataCache set_config_url:self.config_url_tf.text];
    
    // 重新设置SDK
    AnalysysConfig.appKey = self.appkey_tf.text;
    AnalysysConfig.channel = self.channel_tf.text;
    [AnalysysAgent startWithConfig:AnalysysConfig];
    
    [AnalysysAgent setUploadURL:self.upload_url_tf.text];
    [AnalysysAgent setVisitorDebugURL:self.debug_url_tf.text];
    [AnalysysAgent setVisitorConfigURL:self.config_url_tf.text];
    
    
    [AnalysysHUD showTitle:@"提示" message:@"配置修改成功,杀掉app，重启生效"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
