//
//  AnalysysLogDetailVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/28.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class AnalysysLogDetailVC: UIViewController {
    
    var logDic: Dictionary<String, Any>?
    @IBOutlet weak var logTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        let str: String = AnalysysJson.convertToStringWithObject(object: self.logDic as Any)
        if str.count > 0 {
            self.logTV.text = str
        }
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
