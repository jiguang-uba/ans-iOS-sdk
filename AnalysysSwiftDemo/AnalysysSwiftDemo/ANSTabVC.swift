//
//  ANSTabVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/21.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class ANSTabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let nav1: UINavigationController = UINavigationController(rootViewController: FastExperienceVC())
        nav1.title = "快速体验"
        self.addChild(nav1)
        
        let nav2: UINavigationController = UINavigationController(rootViewController: MainModuleVC())
        nav2.title = "功能详情"
        self.addChild(nav2)
        
    }

}
