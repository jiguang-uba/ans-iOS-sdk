//
//  PageViewVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let pageview_next_page: String = "前往自动采集测试页面"
let pageview_black_list_pages: String = "自动采集忽略某些页面"
let pageview_action: String = "手动触发页面采集"
let pageview_action_property: String = "手动触发页面采集带属性"

class PageViewVC: FuncDetailsBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let str: String = self.data?.object(at: indexPath.row) as? String ?? ""
        
        if str == pageview_next_page {
            
            let pageFirstVC: PageFirstVC = PageFirstVC()
            self.navigationController?.pushViewController(pageFirstVC, animated: true)
            
        } else if str == pageview_black_list_pages {
            
            AnalysysAgent.setPageViewBlackListByPages(["PageFirstVC", "PageSecondVC"])
            self.show(title: str, message: AnalysysJson.convertToStringWithObject(object: ["PageFirstVC", "PageSecondVC"]))
            
        } else if str == pageview_action {
            
            AnalysysAgent.pageView("采集【活动页】")
            self.show(title: "提示", message: "采集【活动页】")
            
        } else if str == pageview_action_property {
            
            let dic = ["commodityName" : "iPhone", "commodityPrice" : "8000"]
            AnalysysAgent.pageView("采集【活动页】", properties: dic)
            self.show(title: str, message: "采集【商品页】属性为 \(dic)")
            
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
            if str == PageView {
                ret.addObjects(from: (obj as! NSDictionary).object(forKey: PageView) as! [Any])
                stop.pointee = true
            }
        }
        return ret
    }

}
