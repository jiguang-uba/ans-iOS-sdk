//
//  AnalysysDataCache.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/23.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let analysys_sdk_appkey = "analysys_sdk_appkey"
let analysys_sdk_channel = "analysys_sdk_channel"
let analysys_sdk_upload_url = "analysys_sdk_upload_url"
let analysys_sdk_debug_url = "analysys_sdk_debug_url"
let analysys_sdk_config_url = "analysys_sdk_config_url"

class AnalysysDataCache: NSObject {

    static func set_appkey(appkey: String) {
        UserDefaults.standard.set(appkey, forKey: analysys_sdk_appkey)
        UserDefaults.standard.synchronize()
    }
    
    static func get_appkey() -> String {
        return UserDefaults.standard.object(forKey: analysys_sdk_appkey) as? String ?? "heatmaptest0916"
    }
    
    static func set_channel(channel: String) {
        UserDefaults.standard.set(channel, forKey: analysys_sdk_channel)
        UserDefaults.standard.synchronize()
    }
    
    static func get_channel() -> String {
        return UserDefaults.standard.object(forKey: analysys_sdk_channel) as? String ?? "App Store"
    }
    
    static func set_upload_url(upload_url: String) {
        UserDefaults.standard.set(upload_url, forKey: analysys_sdk_upload_url)
        UserDefaults.standard.synchronize()
    }
    
    static func get_upload_url() -> String {
        return UserDefaults.standard.object(forKey: analysys_sdk_upload_url) as? String ?? "http://192.168.220.105:8089"
    }
    
    static func set_debug_url(debug_url: String) {
        UserDefaults.standard.set(debug_url, forKey: analysys_sdk_debug_url)
        UserDefaults.standard.synchronize()
    }
    
    static func get_debug_url() -> String {
        return UserDefaults.standard.object(forKey: analysys_sdk_debug_url) as? String ?? "ws://192.168.220.105:9091"
    }
    
    static func set_config_url(config_url: String) {
        UserDefaults.standard.set(config_url, forKey: analysys_sdk_config_url)
    }
    
    static func get_config_url() -> String {
        return UserDefaults.standard.object(forKey: analysys_sdk_config_url) as? String ?? "http://192.168.220.105:8089"
    }
}
