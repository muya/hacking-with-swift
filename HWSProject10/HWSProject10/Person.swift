//
//  Person.swift
//  HWSProject10
//
//  Created by Muya on 15/01/2016.
//  Copyright © 2016 muya. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        image = aDecoder.decodeObjectForKey("image") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(image, forKey: "image")
    }
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
