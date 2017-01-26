//
//  Alert.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/18/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import Foundation

class Alert: NSObject, NSCoding{
    
    var time: Date
    var alertName: String
    var alertOn: Bool
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("Alerts")
    
    
    struct PropertyKey {
        static let alertName = "alertName"
        static let time = "time"
        static let alertOn = "alertOn"
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let alertName = aDecoder.decodeObject(forKey: "alertName") as! String
        let time = aDecoder.decodeObject(forKey: "time") as! Date
        let isAlertOn = aDecoder.decodeBool(forKey: "alertOn")
        
        self.init(alertName: alertName, time: time, alertOn: isAlertOn)
    }

    init(alertName: String, time: Date, alertOn: Bool){
        self.alertName = alertName
        self.time = time
        self.alertOn = alertOn
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(alertName, forKey: PropertyKey.alertName)
        aCoder.encode(time, forKey: PropertyKey.time)
        aCoder.encode(alertOn, forKey: PropertyKey.alertOn)
    }
}










