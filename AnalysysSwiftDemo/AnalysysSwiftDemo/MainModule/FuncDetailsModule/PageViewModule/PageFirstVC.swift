//
//  PageFirstVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class PageFirstVC: UIViewController, ANSAutoPageTracker {

    @IBOutlet weak var page_property_tv: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSStringFromClass(self.classForCoder)
        // Do any additional setup after loading the view.
        
        self.page_property_tv.text = "registerPageProperties = \(AnalysysJson.convertToStringWithObject(object: self.registerPageProperties()!))"
    }


    @IBAction func to_page_first(_ sender: Any) {
        
        self.navigationController?.pushViewController(PageSecondVC(), animated: true)
        
    }
    
    func registerPageProperties() -> [AnyHashable : Any]! {
        return ["custom_page_name": "first_page"];
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
