//
//  ANSWebViewController.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/23.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class ANSWebViewController: UIViewController, UIWebViewDelegate {

    var webView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = UIWebView(frame: UIScreen.main.bounds)
        self.view.addSubview(self.webView!)
        
        self.navigationController?.navigationBar.isTranslucent = false
        let filePath: URL? = URL(string: "http://uc.analysys.cn/huaxiang/hybrid-4.3.0.10")
        self.webView?.loadRequest(URLRequest(url: filePath!))
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        if AnalysysAgent.setHybridModel(webView, request: request) {
            return false
        }
        
        return true
    }
    
    deinit {
        AnalysysAgent.resetHybridModel()
    }

}
