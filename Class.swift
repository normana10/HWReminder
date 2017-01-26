//
//  Assignment.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/13/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class Class: NSObject, NSCoding{

    var name: String
    var image: UIImage
    var shortName: String
    var notes: String
    
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("Classes")
    
    struct PropertyKey {
        static let name = "name"
        static let image = "image"
        static let shortName = "shortName"
        static let notes = "notes"
    }
    
    init(name: String, image: UIImage, shortName: String, notes: String) {
        self.name = name
        self.image = image
        self.shortName = shortName
        self.notes = notes
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String ?? ""
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage ?? UIImage(named: "Class DNE")!
        let shortName = aDecoder.decodeObject(forKey: PropertyKey.shortName) as? String ?? ""
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String ?? ""
        self.init(name: name, image: image, shortName: shortName, notes: notes)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(shortName, forKey: PropertyKey.shortName)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
}
