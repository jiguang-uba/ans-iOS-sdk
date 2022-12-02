//
//  AnalysysHUD.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/21.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit
import MBProgressHUD

class AnalysysHUD: NSObject {
    static func show(title: String, message: String) -> Void {
        let hud: MBProgressHUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.mode = .text
        hud.label.text = title
        hud.detailsLabel.text = message
        hud.show(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            hud.hide(animated: true)
        }
    }
}
