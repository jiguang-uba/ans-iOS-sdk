//
//  AllBuryVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let all_bury_next_page: String = "前往测试页面"
let all_bury_black_list_pages: String = "忽略部分页面上所有的点击事件"
let all_bury_black_list_views: String = "忽略某些类名控件点击事件"

class AllBuryVC: FuncDetailsBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let str: String = self.data?.object(at: indexPath.row) as? String ?? ""
        
        if str == all_bury_next_page {
            
            let allBuryFirstVC: AllBuryFirstVC = AllBuryFirstVC()
            self.navigationController?.pushViewController(allBuryFirstVC, animated: true)
            
        } else if str == all_bury_black_list_pages {
            
            AnalysysAgent.setAutoClickBlackListByPages(["AllBuryFirstVC", "AllBurySecondVC"])
            self.show(title: str, message: "\(["AllBuryFirstVC", "AllBurySecondVC"])")
            
        } else if str == all_bury_black_list_views {
            
            AnalysysAgent.setAutoClickBlackListByViewTypes(["AnalysysButton", "AnalysysSwitch"])
            self.show(title: str, message: "\(["AnalysysButton", "AnalysysSwitch"])")
            
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
            if str == AllBury {
                ret.addObjects(from: (obj as! NSDictionary).object(forKey: AllBury) as! [Any])
                stop.pointee = true
            }
        }
        return ret
    }

}
