//
//  ANSConfigVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class ANSConfigVC: UIViewController {

    @IBOutlet weak var appkey_tf: UITextField!
    @IBOutlet weak var channel_tf: UITextField!
    @IBOutlet weak var upload_url_tf: UITextField!
    @IBOutlet weak var debug_url_tf: UITextField!
    @IBOutlet weak var config_url_tf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.appkey_tf.text = AnalysysDataCache.get_appkey()
        self.channel_tf.text = AnalysysDataCache.get_channel()
        self.upload_url_tf.text = AnalysysDataCache.get_upload_url()
        self.debug_url_tf.text = AnalysysDataCache.get_debug_url()
        self.config_url_tf.text = AnalysysDataCache.get_config_url()
    }

    @IBAction func resetConfig(_ sender: Any) {
        
        AnalysysDataCache.set_appkey(appkey: "heatmaptest0916")
        AnalysysDataCache.set_channel(channel: "App Store")
        AnalysysDataCache.set_upload_url(upload_url: "http://192.168.220.105:8089")
        AnalysysDataCache.set_debug_url(debug_url: "ws://192.168.220.105:9091")
        AnalysysDataCache.set_config_url(config_url: "http://192.168.220.105:8089")
        
        self.appkey_tf.text = AnalysysDataCache.get_appkey()
        self.channel_tf.text = AnalysysDataCache.get_channel()
        self.upload_url_tf.text = AnalysysDataCache.get_upload_url()
        self.debug_url_tf.text = AnalysysDataCache.get_debug_url()
        self.config_url_tf.text = AnalysysDataCache.get_config_url()
        
        let dic: Dictionary = [
            "AppKey" : "heatmaptest0916",
            "Channel" : "App Store",
            "UploadURL" : "http://192.168.220.105:8089",
            "DebugURL" : "ws://192.168.220.105:9091",
            "ConfigURL" : "http://192.168.220.105:8089"
        ]
        
        self.show(title: "恢复默认配置,杀掉app，重启生效", message: "\(dic)")
        
    }
    
    @IBAction func changeConfig(_ sender: Any) {
        if (self.appkey_tf.text?.count == 0) {
            AnalysysHUD.show(title: "提示", message: "请输入AppKey")
        } else if (self.channel_tf.text?.count == 0) {
            AnalysysHUD.show(title: "提示", message: "请输入Channel")
        } else if (self.upload_url_tf.text?.count == 0) {
           AnalysysHUD.show(title: "提示", message: "请输入UploadURL")
        } else if (self.debug_url_tf.text?.count == 0) {
           AnalysysHUD.show(title: "提示", message: "请输入DebugURL")
        } else if (self.config_url_tf.text?.count == 0) {
           AnalysysHUD.show(title: "提示", message: "请输入ConfigURL")
        }
        
        
        AnalysysDataCache.set_appkey(appkey: self.appkey_tf.text!)
        AnalysysDataCache.set_channel(channel: self.channel_tf.text!)
        AnalysysDataCache.set_upload_url(upload_url: self.upload_url_tf.text!)
        AnalysysDataCache.set_debug_url(debug_url: self.debug_url_tf.text!)
        AnalysysDataCache.set_config_url(config_url: self.config_url_tf.text!)
        
        AnalysysHUD.show(title: "提示", message: "配置修改成功,杀掉app，重启生效")
        self.navigationController?.popViewController(animated: true)
        
    }

}
