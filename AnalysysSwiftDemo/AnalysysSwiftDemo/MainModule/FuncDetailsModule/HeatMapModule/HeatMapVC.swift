//
//  HeatMapVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let heat_map_next_page = "前往测试页面";
let heat_map_black_list_pages = "忽略部分页面上所有的点击事件";

class HeatMapVC: FuncDetailsBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let str: String = self.data?.object(at: indexPath.row) as? String ?? ""
        if str == heat_map_next_page {
            
            let heatMapFirstVC: HeatMapFirstVC = HeatMapFirstVC()
            self.navigationController?.pushViewController(heatMapFirstVC, animated: true)
            
        } else if str == heat_map_black_list_pages {
            
            AnalysysAgent.setHeatMapBlackListByPages(["HeatMapFirstVC"])
            self.show(title: str, message: "\(["HeatMapFirstVC"])")
            
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
            if str == HeatMap {
                ret.addObjects(from: (obj as! NSDictionary).object(forKey: HeatMap) as! [Any])
                stop.pointee = true
            }
        }
        return ret
    }

}
