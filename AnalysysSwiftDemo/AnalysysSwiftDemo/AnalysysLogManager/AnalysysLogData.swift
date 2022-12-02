//
//  AnalysysLogData.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/28.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class AnalysysLogData: NSObject {
    
    private var _logData: NSMutableArray?
    var logData: NSMutableArray? {
        get {
            if _logData == nil {
                _logData = NSMutableArray()
            }
            return _logData!
        }
        set {
            _logData = newValue
        }
    }
    
    static let sharedSingleton: AnalysysLogData = {
        var instance = AnalysysLogData()
        
        return instance
    }()
    
    
    class func getCurrentDate(date: Date) -> String {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYY-MM-dd HH:mm:ss SS")
        let dateString: String = dateFormatter.string(from: date)
        return dateString
    }
}
