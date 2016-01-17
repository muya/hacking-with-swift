//
//  ViewController.swift
//  HWSTestNSUserDefaults
//
//  Created by Muya on 17/01/2016.
//  Copyright © 2016 muya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        defaults.setInteger(25, forKey: "Age")
        defaults.setBool(true, forKey: "UseTouchID")
        defaults.setDouble(M_PI, forKey: "Pi")
        defaults.setObject("Fred Muya", forKey: "Name")
        defaults.setObject(NSDate(), forKey: "LastRun")
        
        // complex types
        let greeting = ["Hello", "world"]
        let userDetails = ["Name": "Fred", "Country": "KE"]
        
        defaults.setObject(greeting, forKey: "SavedArray")
        defaults.setObject(userDetails, forKey: "SavedDict")
        
        let array = defaults.objectForKey("SavedArray") as? [String] ?? [String]()
        
        let dreAlbums = ["Compton", "Chronic"]
        defaults.setObject(dreAlbums, forKey: "dre")
        
        let extract = defaults.objectForKey("dre") as? [String] ?? [String]()
        print(extract)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

