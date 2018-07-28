//
//  RTDateFormatter.swift
//  RiskTracker
//
//  Created by ChenAlan on 2018/7/29.
//  Copyright © 2018年 ChenAlan. All rights reserved.
//

import Foundation

struct RTDateFormatter {
    
    let dateFormatter: DateFormatter
    
    init(dateFormat: String = "yyyy-MM-dd HH:mm") {
        
        self.dateFormatter = DateFormatter()
        
        self.dateFormatter.dateFormat = dateFormat
    }
    
    func dateWithUnitTime(time: Double) -> String {
        
        let date = Date(timeIntervalSince1970: time)
        
        return dateFormatter.string(from: date)
    }
}
