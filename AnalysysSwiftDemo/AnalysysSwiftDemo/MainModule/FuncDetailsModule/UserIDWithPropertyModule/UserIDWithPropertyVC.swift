//
//  UserIDWithPropertyVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let set_user_id: String = "设置匿名ID"
let set_alias_id: String = "匿名ID与用户关联"
let get_distinct_id: String = "获取匿名ID"
let set_multi_user_propertis: String = "设置多个用户属性"
let set_single_user_propertis: String = "设置单个用户属性"
let set_multi_once_propertis: String = "设置多个固有属性"
let set_single_once_propertis: String = "设置单个固有属性"
let set_multi_increment_propertis: String = "设置多个相对变化值"
let set_single_increment_propertis: String = "设置单个相对变化值"
let append_multi_user_propertis: String = "追加多个用户属性"
let append_single_user_propertis: String = "追加单个用户属性"
let delete_single_user_propertis: String = "删除单个用户属性"
let delete_all_user_propertis: String = "删除所有用户属性"

class UserIDWithPropertyVC: FuncDetailsBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let str: String = self.data?.object(at: indexPath.row) as? String ?? ""
        
        if str == set_user_id {
            
            let distinct_id: String = "WeChatID_1"
            AnalysysAgent.identify(distinct_id)
            self.show(title: str, message: "当前标识:\(distinct_id)")
            
        } else if str == set_alias_id {
            
            AnalysysAgent.alias("18688886666")
            self.show(title: str, message: "当前身份标识：18688886666")
            
        } else if str == get_distinct_id {
            
            let distinctId: String = AnalysysAgent.getDistinctId()
            self.show(title: str, message: "匿名ID:\(distinctId)")
            
        } else if str == set_multi_user_propertis {
            
            let dic = ["nickName":"小叮当","Hobby":["Singing", "Dancing"]] as [String : Any]
            AnalysysAgent.profileSet(dic)
            self.show(title: str, message: "\(dic)")
            
        } else if str == set_single_user_propertis {
            
            AnalysysAgent.profileSet("Job", propertyValue: "Engineer")
            self.show(title: str, message: "Job: Engineer")
            
        } else if str == set_multi_once_propertis {
            
            let dic: Dictionary = ["activationTime": "1521594686781", "loginTime": "1521594792345"]
            AnalysysAgent.profileSetOnce(dic)
            self.show(title: str, message: "\(dic)")
            
        } else if str == set_single_once_propertis {
            
            AnalysysAgent.profileSetOnce("Birthday", propertyValue: "1995-01-01")
            self.show(title: str, message: "Birthday: 1995-01-01")
            
        } else if str == set_multi_increment_propertis {
            
            let dic: Dictionary = ["LoginCount": 1,"Point": 10]
            AnalysysAgent.profileIncrement(dic as [String : NSNumber])
            self.show(title: str, message: "\(dic)")
            
        } else if str == set_single_increment_propertis {
            
            AnalysysAgent.profileIncrement("UseCount", propertyValue: 10)
            self.show(title: str, message: "UseCount: 10")
            
        } else if str == append_multi_user_propertis {
            
            let dic: Dictionary = ["Books": ["西游记", "三国演义"],"Drinks": "orange juice"] as [String : Any]
            AnalysysAgent.profileAppend(dic)
            self.show(title: str, message: "\(dic)")
            
        } else if str == append_single_user_propertis {
            
            AnalysysAgent.profileAppend("clothes", propertyValue: ["pants", "T-shirt"])
            self.show(title: str, message: "clothes: pants,T-shirt")
            
        } else if str == delete_single_user_propertis {
            
            AnalysysAgent.profileUnset("clothes")
            self.show(title: str, message: "clothes")
            
        } else if str == delete_all_user_propertis {
            
            AnalysysAgent.profileDelete()
            self.show(title: str, message: "")
            
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
            if str == UserIDWithProperty {
                ret.addObjects(from: (obj as! NSDictionary).object(forKey: UserIDWithProperty) as! [Any])
                stop.pointee = true
            }
        }
        return ret
    }

}
