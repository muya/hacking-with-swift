//
//  ViewController.swift
//  HWSProject8
//
//  Created by Muya on 17/10/2015.
//  Copyright © 2015 muya. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score: Int = 0 {
        didSet {
            // update score every time it changes
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    @IBAction func submitTapped(sender: AnyObject) {
        var ac:UIAlertController!
        var continueAction: UIAlertAction!
        var acTitle: String!
        var acMessage: String!
        // check if answer is correct
        if let answerPosition = solutions.indexOf(currentAnswer!.text!) {
            
            acTitle = "Correct!"
            acMessage = "Rock on!"
            // split up answersLabel
            var splitAnswers = answersLabel!.text!.componentsSeparatedByString("\n")
            splitAnswers[answerPosition] = currentAnswer!.text!
            answersLabel!.text! = splitAnswers.joinWithSeparator("\n")
            
            // update score
            score++
            
            // re-activate buttons
            cancelTapped(sender)
            
            
        } else {
            acTitle = "Nope!"
            acMessage = "You just CAN'T make up words"
        }
        // check if they should advance a level
        if score % 7 == 0 {
            acTitle = "Well done!"
            acMessage = "Are you ready for the next level?"
            continueAction = UIAlertAction(title: "Let's go!", style: UIAlertActionStyle.Default, handler: levelUp)
        } else {
            continueAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil)
        }
        ac = UIAlertController(title: acTitle, message: acMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        ac.addAction(continueAction)
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func levelUp(action: UIAlertAction) {
        // level up
        level++
        
        // clear solutions
        solutions.removeAll(keepCapacity: true)
        
        // load new level
        loadLevel()
        
        for btn in letterButtons {
            btn.hidden = false
        }
        
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        currentAnswer.text = ""
        
        // display previously hidden buttons
        for btn in activatedButtons {
            btn.hidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    // called to initialize the level
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        // extract solutions from txt files
        if let levelFilePath = NSBundle.mainBundle().pathForResource("level\(level)", ofType: "txt") {
            if let levelContents = try? String(contentsOfFile: levelFilePath, usedEncoding: nil) {
                var lines = levelContents.componentsSeparatedByString("\n")
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(lines) as! [String]
                
                for (index, line) in lines.enumerate() {
                    let parts = line.componentsSeparatedByString(":")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.stringByReplacingOccurrencesOfString("|", withString: "")
                    solutionString += "\(solutionWord.characters.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.componentsSeparatedByString("|")
                    letterBits += bits
                }
            }
        }
        
        // configure buttons & labels
        cluesLabel.text = clueString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        answersLabel.text = solutionString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterBits) as! [String]
        letterButtons = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterButtons) as! [UIButton]
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterBits.count {
                letterButtons[i].setTitle(letterBits[i], forState: .Normal)
            }
        }
    }
    
    func letterTapped(btn: UIButton) {
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        activatedButtons.append(btn)
        btn.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // link up the buttons
        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: "letterTapped:", forControlEvents: .TouchUpInside)
        }
        
        loadLevel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

