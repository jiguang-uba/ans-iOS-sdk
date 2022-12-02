//
//  FastExperienceVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/21.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class FastExperienceVC: UIViewController {

    @IBAction func normal_click(_ sender: Any) {
        AnalysysAgent.track("track_text")
        self.show(title: "提示", message: "触发事件")
    }
    
    @IBAction func event_name_click(_ sender: Any) {
        if self.event_name_tf.text?.count == 0 {
            AnalysysHUD.show(title: "提示", message: "请输入自定义事件名称")
            return
        }
        AnalysysAgent.track(self.event_name_tf.text)
        self.show(title: "提示", message: "触发事件:\(self.event_name_tf.text!)")
    }
    
    @IBAction func key_value_click(_ sender: Any) {
        if self.action_key_tf.text?.count == 0 ||
        self.action_value_tf.text?.count == 0{
            AnalysysHUD.show(title: "提示", message: "请输入Key-Value")
            return;
        }
        AnalysysAgent.track("custom_key_value", properties: [self.action_key_tf.text : self.action_value_tf.text ?? []])
        self.show(title: "提示", message: "触发事件:track_property:\(self.action_key_tf.text!)-\(self.action_value_tf.text!)")
    }
    
    @IBOutlet weak var event_name_tf: UITextField!
    @IBOutlet weak var action_key_tf: UITextField!
    @IBOutlet weak var action_value_tf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "易观方舟 Demo"
        
        // Do any additional setup after loading the view.
        let rightItem: UIBarButtonItem = UIBarButtonItem(title: "修改配置", style: .plain, target: self, action: #selector(changeConfig))
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    @objc func changeConfig() -> Void {
        let config: ANSConfigVC = ANSConfigVC()
        config.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(config, animated: true)
        
    }

}
