//
//  PageSecondVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class PageSecondVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSStringFromClass(self.classForCoder)
        // Do any additional setup after loading the view.
    }

    @IBAction func to_page_third(_ sender: Any) {
        
        self.navigationController?.pushViewController(PageThirdVC(), animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
