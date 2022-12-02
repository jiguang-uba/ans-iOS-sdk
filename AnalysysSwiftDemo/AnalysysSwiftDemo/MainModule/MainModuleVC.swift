//
//  MainModuleVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/21.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class MainModuleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var main_table: UITableView?
    
    var _main_data: NSMutableArray?
    var main_data: NSMutableArray? {
        get {
            if _main_data == nil {
                _main_data = NSMutableArray()
            }
            return _main_data!
        }
        
        set {
            _main_data = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "易观方舟 Demo"
        
        // Do any additional setup after loading the view.
        self.main_data?.addObjects(from: self.getMainModuleData() as! [Any])
        self.main_table = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        self.main_table?.delegate = self
        self.main_table?.dataSource = self
        self.main_table?.register(UITableViewCell.self, forCellReuseIdentifier: "MainModuleCell")
        self.view.addSubview(self.main_table!)
        
        let rightItem: UIBarButtonItem = UIBarButtonItem(title: "修改配置", style: .plain, target: self, action: #selector(changeConfig))
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainModuleCell", for: indexPath)
        cell.textLabel?.text = self.main_data?.object(at: indexPath.row) as? String ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.main_data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mainModuleCase: String = self.main_data?.object(at: indexPath.row) as? String ?? ""
        if mainModuleCase == SuperProperty {
            
            let superProtertyVC: SuperProtertyVC = SuperProtertyVC()
            superProtertyVC.title = mainModuleCase
            superProtertyVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(superProtertyVC, animated: true)
            
        } else if mainModuleCase == PageView {
            
            let pageViewVC: PageViewVC = PageViewVC()
            pageViewVC.title = mainModuleCase
            pageViewVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(pageViewVC, animated: true)
            
        } else if mainModuleCase == AllBury {
            
            let allBuryVC: AllBuryVC = AllBuryVC()
            allBuryVC.title = mainModuleCase
            allBuryVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(allBuryVC, animated: true)
            
        } else if mainModuleCase == HeatMap {
            
            let heatMapVC: HeatMapVC = HeatMapVC()
            heatMapVC.title = mainModuleCase
            heatMapVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(heatMapVC, animated: true)
            
        } else if mainModuleCase == Visual {
            
            let visualVC: VisualVC = VisualVC()
            visualVC.title = mainModuleCase
            visualVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(visualVC, animated: true)
            
        } else if mainModuleCase == Tracking {
            
            let trackingVC: TrackingVC = TrackingVC()
            trackingVC.title = mainModuleCase
            trackingVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(trackingVC, animated: true)
            
        } else if mainModuleCase == UserIDWithProperty {
            
            let userIDWithPropertyVC: UserIDWithPropertyVC = UserIDWithPropertyVC()
            userIDWithPropertyVC.title = mainModuleCase
            userIDWithPropertyVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(userIDWithPropertyVC, animated: true)
            
        } else if mainModuleCase == Hybrid {
            
            let hybridVC: HybridVC = HybridVC()
            hybridVC.title = mainModuleCase
            hybridVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hybridVC, animated: true)
            
        } else if mainModuleCase == Other {
            
            let otherVC: OtherVC = OtherVC()
            otherVC.title = mainModuleCase
            otherVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(otherVC, animated: true)
            
        }
        
    }
    
    @objc func changeConfig() -> Void {
        let config: ANSConfigVC = ANSConfigVC()
        config.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(config, animated: true)
        
    }
    
    func getMainModuleData() -> NSArray {
        let filePath: String? = Bundle.main.path(forResource: "main_module", ofType: "json")
        let jsonStr: String? = try! NSString.init(contentsOfFile: filePath ?? "", encoding: String.Encoding.utf8.rawValue) as String
        let jsonData: Data = jsonStr?.data(using: .utf8) ?? Data()
        
        let arr: NSArray = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSArray
        
        let ret: NSMutableArray = NSMutableArray()
        
        arr.enumerateObjects { (obj, idx, stop) in
            ret.add((obj as! NSDictionary).allKeys.first as Any)
        }
        return ret
    }

}
