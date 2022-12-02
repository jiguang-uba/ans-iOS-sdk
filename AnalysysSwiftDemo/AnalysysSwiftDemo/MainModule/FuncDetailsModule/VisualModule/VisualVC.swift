//
//  VisualVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let visual_general_ui: String = "常用控件"
let visual_table_view: String = "列表布局"
let visual_collection_view: String = "网格布局"

class VisualVC: FuncDetailsBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let str: String = self.data?.object(at: indexPath.row) as? String ?? ""
        
        if str == visual_general_ui {
            
            let bindNormalVC: ANSBindNormalVC = ANSBindNormalVC()
            self.navigationController?.pushViewController(bindNormalVC, animated: true)            
            
        } else if (str == visual_table_view) {
            
            let bindTableViewVC: ANSBindTableViewVC = ANSBindTableViewVC()
            self.navigationController?.pushViewController(bindTableViewVC, animated: true)
            
        } else if (str == visual_collection_view) {
            
            let bindCollectionViewVC: ANSBindCollectionViewVC = ANSBindCollectionViewVC()
            self.navigationController?.pushViewController(bindCollectionViewVC, animated: true)
            
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
            if str == Visual {
                ret.addObjects(from: (obj as! NSDictionary).object(forKey: Visual) as! [Any])
                stop.pointee = true
            }
        }
        return ret
    }

}
