//
//  HybridVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let hybrid_uiwebview: String = "UIWebView";
let hybrid_wkwebview: String = "WKWebView";

class HybridVC: FuncDetailsBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let str: String = self.data?.object(at: indexPath.row) as? String ?? ""
        
        if str == hybrid_uiwebview {
            
            let ui_web: ANSWebViewController = ANSWebViewController()
            ui_web.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(ui_web, animated: true)
            
        } else if str == hybrid_wkwebview {
            
            let wk_web: ANSWKWebViewController = ANSWKWebViewController()
            wk_web.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(wk_web, animated: true)
            
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
            if str == Hybrid {
                ret.addObjects(from: (obj as! NSDictionary).object(forKey: Hybrid) as! [Any])
                stop.pointee = true
            }
        }
        return ret
    }

}
