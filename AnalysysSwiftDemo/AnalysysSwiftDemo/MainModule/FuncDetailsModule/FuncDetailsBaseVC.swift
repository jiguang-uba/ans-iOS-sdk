//
//  FuncDetailsBaseVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

let SuperProperty: String = "通用属性"
let PageView: String = "页面采集"
let AllBury: String = "全埋点"
let HeatMap: String = "热图"
let Visual: String = "可视化"
let Tracking: String = "统计事件"
let UserIDWithProperty: String = "用户ID 用户属性"
let Hybrid: String = "Hybrid"
let Other: String = "其他"

class FuncDetailsBaseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var _data: NSMutableArray?
    var data: NSMutableArray? {
        get {
            if _data == nil {
                _data = NSMutableArray()
            }
            return _data!
        }
        
        set {
            _data = newValue
        }
    }
    
    var table: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.data = self.getModuleData()
        self.table =  UITableView(frame: UIScreen.main.bounds, style: .grouped)
        self.table?.delegate = self
        self.table?.dataSource = self
        self.table?.register(UITableViewCell.self, forCellReuseIdentifier: "FuncDetailsCell")
        self.view.addSubview(self.table!)
        
    }
    
    func getModuleData() -> NSMutableArray? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FuncDetailsCell", for: indexPath)
        cell.textLabel?.text = self.data?.object(at: indexPath.row) as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }

}
