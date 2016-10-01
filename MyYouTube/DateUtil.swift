//
//  DateHelper.swift
//  TheWombatViewer
//
//  Created by 松本和也 on 10/1/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import Foundation
class DateUtil {
    static let sharedInstance = DateUtil()
    let tsDateFormatter = NSDateFormatter()
    let dateFormatter = NSDateFormatter()

    init() {
        tsDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        print("call date util init")
    }
    func timeStampToDateString(timeStamp: String) -> String{
        let date = tsDateFormatter.dateFromString(timeStamp)
        return dateFormatter.stringFromDate(date!)
    }
}