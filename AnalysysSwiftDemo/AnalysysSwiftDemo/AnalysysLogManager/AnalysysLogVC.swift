//
//  AnalysysLogVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/28.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class AnalysysLogVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var ans_table: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let leftItem: UIBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(goToBack))
        self.navigationItem.leftBarButtonItem = leftItem
        
        let table: UITableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "AnalysysLogCell", bundle: Bundle.main), forCellReuseIdentifier: "AnalysysLogCell")
        self.view.addSubview(table)
        self.ans_table = table
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnalysysLogData.sharedSingleton.logData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnalysysLogCell = (tableView.dequeueReusableCell(withIdentifier: "AnalysysLogCell", for: indexPath) as? AnalysysLogCell)!
        let dic = AnalysysLogData.sharedSingleton.logData?.object(at: indexPath.row)
        
        cell.xwhat_lab.text = (dic as! Dictionary<String, Any>)["xwhat"] as? String ?? ""
        
        let time: Double = (dic as! Dictionary<String, Any>)["xwhen"] as? Double ?? 0
        cell.xwhen_lab.text = AnalysysLogData.getCurrentDate(date: Date(timeIntervalSince1970: time/1000))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dic = AnalysysLogData.sharedSingleton.logData?.object(at: indexPath.row)
        let detail: AnalysysLogDetailVC = AnalysysLogDetailVC()
        detail.logDic = dic as? Dictionary<String, Any>
        self.navigationController?.pushViewController(detail, animated: true)
    }
    

    @objc func goToBack() -> Void {
        self.dismiss(animated: true) {
            AnalysysLogManager.sharedInstance.button?.isEnabled = true
        }
    }

}
