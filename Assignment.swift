//
//  Assignment.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/13/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import Foundation

class Assignment: NSObject, NSCoding{

    var name: String
    var className: String
    var dueDate: Date
    var important: Int
    
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("Assignments")
    
    struct PropertyKey {
        static let name = "name"
        static let className = "className"
        static let dueDate = "dueDate"
        static let important = "important"
    }
    
    init(name: String, className: String, dueDate: Date, important: Int) {
        self.name = name
        self.className = className
        self.dueDate = dueDate
        self.important = important
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String ?? ""
        let className = aDecoder.decodeObject(forKey: PropertyKey.className) as? String ?? ""
        let dueDate = aDecoder.decodeObject(forKey: PropertyKey.dueDate) as? Date ?? Date()
        let important = aDecoder.decodeInteger(forKey: PropertyKey.important)
        self.init(name: name, className: className, dueDate: dueDate, important: important)
        
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(className, forKey: PropertyKey.className)
        aCoder.encode(dueDate, forKey: PropertyKey.dueDate)
        aCoder.encode(important, forKey: PropertyKey.important)
    }
}
