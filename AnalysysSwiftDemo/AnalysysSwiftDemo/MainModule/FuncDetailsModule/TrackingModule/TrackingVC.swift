//
//  TrackingVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let tracking_event: String = "统计事件"
let tracking_event_with_properties: String = "统计事件带属性"

class TrackingVC: FuncDetailsBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let str: String = self.data?.object(at: indexPath.row) as? String ?? ""
        
        if str == tracking_event {
            
            AnalysysAgent.track("tracking_event")
            self.show(title: str, message: "事件:tracking_event")
            
        } else if str == tracking_event_with_properties {
            
            AnalysysAgent.track("tracking_event_with_properties", properties: ["name" : "analysys", "age" : 18])
            self.show(title: str, message: "事件:tracking_event_with_properties | 属性:\(["name" : "analysys", "age" : 18])")
            
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
            if str == Tracking {
                ret.addObjects(from: (obj as! NSDictionary).object(forKey: Tracking) as! [Any])
                stop.pointee = true
            }
        }
        return ret
    }

}
