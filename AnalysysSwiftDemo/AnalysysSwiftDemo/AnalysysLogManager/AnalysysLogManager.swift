//
//  AnalysysLogManager.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/28.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class AnalysysLogManager: NSObject {
    
    weak var button: UIButton?
    
    static let sharedInstance: AnalysysLogManager = {
        let instance = AnalysysLogManager()
        // setup code
        return instance
    }()
    
    func createSuspendButton() -> Void {
        
        let btn: UIButton = UIButton(type: .custom)
        btn.setTitle("日志", for: UIControl.State.normal)
        btn.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        btn.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        btn.backgroundColor = UIColor.colorWithHexString(hexadecimal: "#20a0ff")
        btn.addTarget(self, action: #selector(showLogVC), for: UIControl.Event.touchUpInside)
        btn.layer.cornerRadius = 30.0
        
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(p:)))
        btn.addGestureRecognizer(pan)
        
        UIApplication.shared.keyWindow?.addSubview(btn)
        self.button = btn
        
    }
    
    
    @objc func showLogVC() -> Void {
        
        let analysysLogVC: AnalysysLogVC = AnalysysLogVC()
        let nav: UINavigationController = UINavigationController(rootViewController: analysysLogVC)
        self.ans_findVisibleViewController()?.present(nav, animated: true) {
            self.button?.isEnabled = false
        }
        
    }
    
    @objc func pan(p: UIPanGestureRecognizer) -> Void {
        
        let transform: CGAffineTransform = self.button!.transform
        let transP: CGPoint = p.translation(in: self.button)
        self.button?.transform = transform.translatedBy(x: transP.x, y: transP.y)
        p.setTranslation(CGPoint(x: 0, y: 0), in: self.button)
    }
    
    func onEventDataReceived(_ eventData: Any!) {
        if eventData != nil {
            AnalysysLogData.sharedSingleton.logData?.insert(eventData as Any, at: 0)
        }
    }
    
    func ans_rootViewController() -> UIViewController {
        
        let win: UIWindow = (UIApplication.shared.delegate?.window)!!
        return win.rootViewController!
    }
    
    func ans_findVisibleViewController() -> UIViewController? {
        
        var currentViewController: UIViewController = self.ans_rootViewController()
        let runLoopFind: Bool = true
        while runLoopFind {
            if (currentViewController.presentedViewController != nil) {
                currentViewController = currentViewController.presentedViewController!
            } else {
                if currentViewController.isKind(of: UINavigationController.self) {
                    currentViewController = (currentViewController as! UINavigationController).visibleViewController!
                } else if currentViewController.isKind(of: UITabBarController.self) {
                    currentViewController = (currentViewController as! UITabBarController).selectedViewController!
                } else {
                    break
                }
            }
        }
        return currentViewController
    }
}
