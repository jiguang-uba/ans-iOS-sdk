//
//  Alert.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import Foundation
extension UIViewController {
    
    func show(title: String, message: String) -> Void {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionDefault: UIAlertAction = UIAlertAction(title: "确定", style: .default) { (action) in
            
        }
        alert.addAction(actionDefault)
        self.present(alert, animated: true) {
            //
        }
    }
}
