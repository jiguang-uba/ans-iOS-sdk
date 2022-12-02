//
//  OtherVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let analysys_version: String = "当前SDK版本"
let analysys_network: String = "上数网络环境"
let analysys_debug_mode: String = "上数调试模式"
let analysys_encrypt_type: String = "数据加密类型"
let analysys_interval_time: String = "设置上传间隔"
let analysys_max_event_size: String = "设置累积条数"
let analysys_max_cache_size: String = "设置最大缓存"
let analysys_allow_time_check: String = "是否允许时间校准"
let analysys_max_diff_time_interval: String = "最大时间误差"
let analysys_track_device_id: String = "是否上报设备标识"
let analysys_crash: String = "制造崩溃"
let analysys_crash_switch: String = "崩溃自动收集开关(打开/关闭)"
let analysys_page_switch: String = "页面自动收集开关(打开/关闭)"
let analysys_all_bury_switch: String = "全埋点事件自动收集开关(打开/关闭)"
let analysys_heat_map_switch: String = "热图事件自动收集开关(打开/关闭)"
let analysys_get_preset_properties: String = "获取预制属性"
let analysys_clear_db: String = "清理数据库"
let analysys_reset: String = "清除本地设置"


var encrypt_type_switch = 0;
var time_check = 0;
var device_id_switch = 0;
var crash_switch = 0;
var page_switch = 0;
var all_bury_switch = 0;
var heat_map_switch = 0;


class OtherVC: FuncDetailsBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let str: String = self.data?.object(at: indexPath.row) as? String ?? ""
        
        if str == analysys_version {
            
            let sdk_version: String = AnalysysAgent.sdkVersion()
            self.show(title: str, message: "version : \(sdk_version)")
            
        } else if str == analysys_network {
            
            self.showActionSheet(str: str)
            
        } else if str == analysys_debug_mode {
            
            self.showDebugMode(str: str)
            
        } else if str == analysys_encrypt_type {
            
            encrypt_type_switch += 1
            if encrypt_type_switch%2==0 {
                AnalysysAgentConfig.shareInstance()?.encryptType = .AES
                self.show(title: str, message: "AnalysysEncryptAES")
            } else {
                AnalysysAgentConfig.shareInstance()?.encryptType = .AESCBC128
                self.show(title: str, message: "AnalysysEncryptAESCBC128")
            }
            
        } else if str == analysys_max_diff_time_interval {
            
            AnalysysAgentConfig.shareInstance()?.maxDiffTimeInterval = 60
            self.show(title: str, message: "60秒")
            
        } else if str == analysys_interval_time {
            
            AnalysysAgent.setIntervalTime(30)
            self.show(title: str, message: "30秒")
            
        } else if str == analysys_max_event_size {
            
            AnalysysAgent.setMaxEventSize(20)
            self.show(title: str, message: "20条")
            
        } else if str == analysys_max_cache_size {
            
            AnalysysAgent.setMaxCacheSize(200)
            self.show(title: str, message: "200条")
            
        } else if str == analysys_allow_time_check {
            
            time_check += 1
            if time_check%2 == 0 {
                AnalysysAgentConfig.shareInstance()?.allowTimeCheck = false
                self.show(title: str, message: "不允许")
            } else {
                AnalysysAgentConfig.shareInstance()?.allowTimeCheck = true
                self.show(title: str, message: "允许")
            }
            
        } else if str == analysys_track_device_id {
            
            device_id_switch += 1
            if device_id_switch%2 == 0 {
                AnalysysAgentConfig.shareInstance()?.autoTrackDeviceId = false
                self.show(title: str, message: "不上报")
            } else {
                AnalysysAgentConfig.shareInstance()?.autoTrackDeviceId = true
                self.show(title: str, message: "上报")
            }
            
        } else if str == analysys_crash {
            
            let ttaar = NSArray()
            print(ttaar[66])
            
        } else if str == analysys_crash_switch {
            
            crash_switch += 1
            if (crash_switch % 2) == 1 {
                AnalysysAgentConfig.shareInstance()?.autoTrackCrash = true
                self.show(title: str, message: "打开")
            } else {
                AnalysysAgentConfig.shareInstance()?.autoTrackCrash = false
                self.show(title: str, message: "关闭")
            }
            
        } else if str == analysys_page_switch {
            
            page_switch += 1
            if (page_switch % 2) == 1 {
                AnalysysAgent.setAutomaticCollection(true)
                self.show(title: str, message: "打开")
            } else {
                AnalysysAgent.setAutomaticCollection(false)
                self.show(title: str, message: "关闭")
            }
            
        } else if str == analysys_all_bury_switch {
            
            all_bury_switch += 1
            if (all_bury_switch % 2) == 1 {
                AnalysysAgent.setAutoTrackClick(true)
                self.show(title: str, message: "打开")
            } else {
                AnalysysAgent.setAutoTrackClick(false)
                self.show(title: str, message: "关闭")
            }
            
        } else if str == analysys_heat_map_switch {
            
            heat_map_switch += 1
            if (heat_map_switch % 2) == 1 {
                AnalysysAgent.setAutomaticHeatmap(true)
                self.show(title: str, message: "打开")
            } else {
                AnalysysAgent.setAutomaticHeatmap(false)
                self.show(title: str, message: "关闭")
            }
            
        } else if str == analysys_get_preset_properties {
            
            let dic: Dictionary = AnalysysAgent.getPresetProperties()
            self.show(title: str, message: "\(dic)")
            
        } else if str == analysys_clear_db {
            
            AnalysysAgent.cleanDBCache()
            self.show(title: str, message: "")
            
        } else if str == analysys_reset {
            
            AnalysysAgent.reset()
            self.show(title: str, message: "")
        }
        
    }
    
    func showActionSheet(str: String) -> Void {
        
        let alertController: UIAlertController = UIAlertController()
        let cancel: UIAlertAction = UIAlertAction(title: "cancle", style: .cancel) { (action) in
            //
        }
        let a1: UIAlertAction = UIAlertAction(title: "NONE", style: .default) { (action) in
            AnalysysAgent.setUploadNetworkType(.NONE)
            self.show(title: str, message: "NONE")
        }
        let a2: UIAlertAction = UIAlertAction(title: "WWAN", style: .default) { (action) in
            AnalysysAgent.setUploadNetworkType(.WWAN)
            self.show(title: str, message: "WWAN")
        }
        let a3: UIAlertAction = UIAlertAction(title: "WIFI", style: .default) { (action) in
            AnalysysAgent.setUploadNetworkType(.WIFI)
            self.show(title: str, message: "WIFI")
        }
        let a4: UIAlertAction = UIAlertAction(title: "ALL", style: .default) { (action) in
            AnalysysAgent.setUploadNetworkType(.ALL)
            self.show(title: str, message: "ALL")
        }
        
        alertController.addAction(cancel)
        alertController.addAction(a1)
        alertController.addAction(a2)
        alertController.addAction(a3)
        alertController.addAction(a4)
        
        self.present(alertController, animated: true) {
            //
        }
        
    }
    
    func showDebugMode(str: String) -> Void {
        let alertController: UIAlertController = UIAlertController()
        let cancel: UIAlertAction = UIAlertAction(title: "cancle", style: .cancel) { (action) in
            //
        }
        let a1: UIAlertAction = UIAlertAction(title: "AnalysysDebugOff", style: .default) { (action) in
            AnalysysAgent.setDebugMode(.off)
            self.show(title: str, message: "AnalysysDebugOff")
        }
        let a2: UIAlertAction = UIAlertAction(title: "AnalysysDebugOnly", style: .default) { (action) in
            AnalysysAgent.setDebugMode(.only)
            self.show(title: str, message: "AnalysysDebugOnly")
        }
        let a3: UIAlertAction = UIAlertAction(title: "AnalysysDebugButTrack", style: .default) { (action) in
            AnalysysAgent.setDebugMode(.butTrack)
            self.show(title: str, message: "AnalysysDebugButTrack")
        }
        
        alertController.addAction(cancel)
        alertController.addAction(a1)
        alertController.addAction(a2)
        alertController.addAction(a3)
        
        self.present(alertController, animated: true) {
            //
        }
    }

    override func getModuleData() -> NSMutableArray? {
        let filePath: String? = Bundle.main.path(forResource: "main_module", ofType: "json")
        let jsonStr: String? = try! NSString.init(contentsOfFile: filePath ?? "", encoding: String.Encoding.utf8.rawValue) as String
        let jsonData: Data = jsonStr?.data(using: .utf8) ?? Data()
        
        let arr: NSArray = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSArray
              
        let ret: NSMutableArray = NSMutableArray()
        
        arr.enumerateObjects { (obj, idx, stop) in
            
            let str: String = (obj as! NSDictionary).allKeys.first as! String
            if str == Other {
                ret.addObjects(from: (obj as! NSDictionary).object(forKey: Other) as! [Any])
                stop.pointee = true
            }
        }
        return ret
    }

}
