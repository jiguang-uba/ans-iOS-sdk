//
//  ANSWKWebViewController.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/23.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit
import WebKit

class WeakScriptMessageDelegate: NSObject {
    weak var scriptDelegate: NSObject?
    
    override init() {
        super.init()
        
    }
    
    convenience init(delegate: NSObject) {
        self.init()
        self.scriptDelegate = delegate
    }
    
    
}

class ANSWKWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    var configuration: WKWebViewConfiguration?
    var webView: WKWebView?
    var scriptMessageDelegate: WeakScriptMessageDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false;
        self.scriptMessageDelegate = WeakScriptMessageDelegate()
        self.scriptMessageDelegate?.scriptDelegate = self
        
        self.configuration = WKWebViewConfiguration()
        AnalysysAgent.setWebViewVisualConfig(self.configuration!, scriptMessageHandler: self)
        
        self.webView = WKWebView(frame: UIScreen.main.bounds, configuration: self.configuration!)
        self.webView?.navigationDelegate = self
        self.webView?.uiDelegate = self
        self.webView?.allowsBackForwardNavigationGestures = true
        self.view.addSubview(self.webView!)
        
        let filePath: URL? = URL(string: "https://uc.analysys.cn/huaxiang/web_visual/index.html?t=\(Date().timeIntervalSince1970)")
        self.webView?.load(URLRequest(url: filePath!))
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        AnalysysAgent.setScriptMessage(message)
    }

    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let result = AnalysysAgent.setHybridModel(webView, request: navigationAction.request)
        
        if result {
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    deinit {
        AnalysysAgent.resetHybridModel()
        AnalysysAgent.resetWebViewVisualConfig(self.configuration)
    }
}
