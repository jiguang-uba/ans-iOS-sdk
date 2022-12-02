//
//  AppDelegate.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/17.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit
import CoreData
import Bugly

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let instance = UMAnalyticsConfig.sharedInstance()
        instance?.appKey = "5f448865113468235fdc5943"
        instance?.bCrashReportEnabled = true
        MobClick.setLogEnabled(true)
        MobClick.start(withConfigure: instance)
        
//        Bugly.start(withAppId: "4b082d4d5e")
        
        AnalysysAgent.monitorAppDelegate(self, launchOptions: launchOptions)
        self.initialAnalysysSDK(launchOptions: launchOptions)
        
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = ANSTabVC()
        window?.makeKeyAndVisible()
        
        AnalysysLogManager.sharedInstance.createSuspendButton()
        
        
        return true
    }
    
    func initialAnalysysSDK(launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Void {
        
        let config: AnalysysAgentConfig = AnalysysAgentConfig.shareInstance()
        config.appKey = AnalysysDataCache.get_appkey()
        config.channel = AnalysysDataCache.get_channel()
        config.autoTrackCrash = true
        AnalysysAgent.setObserverListener(AnalysysLogManager.sharedInstance)
        
        AnalysysAgent.start(with: config)
        AnalysysAgent.setDebugMode(.butTrack)
        AnalysysAgent.setUploadURL(AnalysysDataCache.get_upload_url())
        AnalysysAgent.setVisitorDebugURL(AnalysysDataCache.get_debug_url())
        AnalysysAgent.setVisitorConfigURL(AnalysysDataCache.get_config_url())
        
    }
    
    func p_initialAnalysysSDK(launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Void {
        
        let config: AnalysysAgentConfig = AnalysysAgentConfig.shareInstance()
        config.appKey = "heatmaptest0916"
        config.channel = "App Store"
        AnalysysAgent.setObserverListener(AnalysysLogManager.sharedInstance)
        
        let securityPolicy: ANSSecurityPolicy = ANSSecurityPolicy(pinningMode: .certificate)
        securityPolicy.allowInvalidCertificates = false
        securityPolicy.validatesDomainName = true
        config.securityPolicy = securityPolicy
        
        AnalysysAgent.start(with: config)
        AnalysysAgent.setDebugMode(.butTrack)
        AnalysysAgent.setUploadURL("https://arksdktest.analysys.cn:4069")
        AnalysysAgent.setVisitorDebugURL("https://arksdktest.analysys.cn:4069")
        AnalysysAgent.setVisitorConfigURL("https://arksdktest.analysys.cn:4069")
        
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        print("%s",#function)
        print("url:\(url.absoluteString)")
        print("host:\(url.host ?? "")")
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        print("%s",#function)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("%s",#function)
        return true
    }
    
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let type = shortcutItem.type
        if type == "HomePage" {
            //
        } else {
            
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        print("%s",#function)
        return true
    }
    
}

