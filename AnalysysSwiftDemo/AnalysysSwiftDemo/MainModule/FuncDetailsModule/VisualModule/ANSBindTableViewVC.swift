//
//  ANSBindTableViewVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class ANSBindTableViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var bindTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let table: UITableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        table.allowsMultipleSelection = true
        table.register(UINib.init(nibName: "ANSBindTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ANSBindTableViewCell")
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        self.bindTableView = table
        
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ANSBindTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ANSBindTableViewCell", for: indexPath) as! ANSBindTableViewCell
        cell.ans_titleLab.text = "section:\(indexPath.section)-row:\(indexPath.row)"
        cell.ans_clickBtn .setTitle("zan-\(indexPath.row)", for: .normal)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //
    }
}
