//
//  ViewController.swift
//  HWSProject2
//
//  Created by Muya on 30/09/2015.
//  Copyright © 2015 muya. All rights reserved.
//

import GameplayKit
import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    // MARK: Class Variables
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var buttons = [UIButton]()
    
    // MARK: Actions
    @IBAction func buttonTapped(sender: UIButton) {
        if sender.tag == correctAnswer {
            score++
            self.title = "Correct!"
        }
        else {
            score--
            self.title = "Wrong"
        }
        
        if score < 0 {
            score = 0
        }
        
        let ac = UIAlertController(title: self.title, message: "Your score is \(score)", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: askQuestion))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttons += [button1, button2, button3]
        
        // add countries
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        // prettify buttons
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(countries) as! [String]
        
        var i: Int
        for i = 0; i < buttons.count; ++i {
            buttons[i].setImage(UIImage(named: countries[i]), forState: .Normal)
        }
        correctAnswer = GKRandomSource.sharedRandom().nextIntWithUpperBound(buttons.count)
        self.title = countries[correctAnswer].uppercaseString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

