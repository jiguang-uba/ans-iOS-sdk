//
//  AnalysysJson.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/21.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class AnalysysJson: NSObject {
    static func convertToStringWithObject(object: Any) -> String {
        var jsonStr: String?
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            jsonStr = String(data: jsonData, encoding: .utf8) ?? ""
            
        } catch let error {
            print(error)
        }
        return jsonStr ?? ""
    }
}
