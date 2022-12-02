//
//  SuperProtertyVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let register_super_properties: String = "注册多个通用属性"
let get_super_property: String = "获取单个通用属性"
let register_single_super_properties: String = "注册单个通用属性"
let un_register_super_property: String = "删除单个通用属性"
let clear_super_properties: String = "删除所有通用属性"
let get_all_super_properties: String = "获取所有通用属"


class SuperProtertyVC: FuncDetailsBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let str: String = self.data?.object(at: indexPath.row) as? String ?? ""
        if str == register_super_properties {
            let dic = ["property1" : "one", "property2" : "two"]
            AnalysysAgent.registerSuperProperties(dic)
            self.show(title: str, message: AnalysysJson.convertToStringWithObject(object: dic))
        } else if str == get_super_property {
            let property: String = AnalysysAgent.getSuperProperty("property1") as? String ?? ""
            self.show(title: str, message: property)
        } else if str == register_single_super_properties {
            AnalysysAgent.registerSuperProperty("age", value: 18)
            self.show(title: str, message: "age - 18")
        } else if str == un_register_super_property {
            AnalysysAgent.unRegisterSuperProperty("property2")
            self.show(title: str, message: "property2")
        } else if str == clear_super_properties {
            AnalysysAgent.clearSuperProperties()
            self.show(title: str, message: "")
        } else if str == get_all_super_properties {
            let dic: Dictionary = AnalysysAgent.getSuperProperties()
            self.show(title: str, message: AnalysysJson.convertToStringWithObject(object: dic))
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
            if str == SuperProperty {
                ret.addObjects(from: (obj as! NSDictionary).object(forKey: SuperProperty) as! [Any])
                stop.pointee = true
            }
        }
        return ret
    }

}
