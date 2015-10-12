//
//  MasterViewController.swift
//  HWSProject5
//
//  Created by Muya on 09/10/2015.
//  Copyright © 2015 muya. All rights reserved.
//

import UIKit
import GameKit

class MasterViewController: UITableViewController {

    var objects = [String]()
    var allWords = [String]()
    
    enum WordValidatorError: ErrorType {
        case WordNotPossible
        case WordNotOriginal
        case WordNotReal
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "newSourceWord")
        
        // load words from file
        if let startWordsPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath, usedEncoding: nil) {
                allWords = startWords.componentsSeparatedByString("\n")
            }
        } else {
            allWords = ["silkworm"]
        }
        startGame()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

    // MARK: - Game functionality
    func startGame() {
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(allWords) as! [String]
        title = allWords[0]
        objects.removeAll(keepCapacity: true)
        tableView.reloadData()
    }
    
    // change the source word
    func newSourceWord() {
        startGame()
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { [unowned self, ac] (action: UIAlertAction!) in
            let answer = ac.textFields![0]
            self.submitAnswer(answer.text!)
        }
        
        ac.addAction(submitAction)
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func submitAnswer(answer: String) {
        let lowerAnswer = answer.lowercaseString
        
        var errorTitle = "Error Title"
        var errorMsg = "Error Message"
        var isValid = false
        
        do {
            isValid = try validateWord(lowerAnswer)
        } catch WordValidatorError.WordNotPossible {
            errorTitle = "Word not possible"
            errorMsg = "You can't spell that word from '\(title!.lowercaseString)'"
        } catch WordValidatorError.WordNotOriginal {
            errorTitle = "Word used already"
            errorMsg = "How about something you haven't written already? 😉"
        } catch WordValidatorError.WordNotReal {
            errorTitle = "Word not real"
            errorMsg = "You can't just make 'em up, you know!"
        } catch {
            errorTitle = "Oops!"
            errorMsg = "Something really bad happened! 👻 It's not your fault, you can try again."
        }
        
        // word is valid
        if isValid {
            objects.insert(answer, atIndex: 0)
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            return
        } else {
            let ac = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func validateWord(word: String) throws -> Bool {
        if (!wordIsPossible(word)) {
            throw WordValidatorError.WordNotPossible
        }
        
        if (!wordIsOriginal(word)) {
            throw WordValidatorError.WordNotOriginal
        }
        
        if (!wordIsReal(word)) {
            throw WordValidatorError.WordNotReal
        }
        
        return true
    }
    
    // check if it is possible to create given word from original word
    func wordIsPossible(word: String) -> Bool {
        var tempWord = title!.lowercaseString
        
        for letter in word.characters {
            if let pos = tempWord.rangeOfString(String(letter)) {
                tempWord.removeAtIndex(pos.startIndex)
            } else {
                return false
            }
        }
        return !(word == title!.lowercaseString)
    }
    
    // check if word already exists
    func wordIsOriginal(word: String) -> Bool {
        return !objects.contains(word)
    }
    
    // check if word given is a real word
    func wordIsReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.characters.count)
        let misspelledRange = checker.rangeOfMisspelledWordInString(word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return (misspelledRange.location == NSNotFound)
    }
}

