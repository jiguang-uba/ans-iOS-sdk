//
//  AllBurySecondVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class AllBurySecondVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func to_all_bury_third(_ sender: Any) {
        
        let allBuryThirdVC: AllBuryThirdVC = AllBuryThirdVC()
        self.navigationController?.pushViewController(allBuryThirdVC, animated: true)
        
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
