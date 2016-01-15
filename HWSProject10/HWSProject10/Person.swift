//
//  Person.swift
//  HWSProject10
//
//  Created by Muya on 15/01/2016.
//  Copyright © 2016 muya. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
