//
//  DetailViewController.swift
//  HWSProject1
//
//  Created by Muya on 24/09/2015.
//  Copyright © 2015 muya. All rights reserved.
//

import Social
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!

    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let imageView = self.detailImageView {
                imageView.image = UIImage(named: detail)
            }
            
            self.title = detail
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        // add share button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareTapped")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    func shareTapped() {
        // present action sheet with FB, Twitter & More
        // if user taps on More, present the default activity view
        let actionSheet = UIAlertController(title: "", message: "Spread this Storm!", preferredStyle: .ActionSheet)
        
        let tweetAction = getTweetAction()
        let moreAction = getMoreAction()
        let fbAction = getFacebookAction()
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(fbAction)
        actionSheet.addAction(moreAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func getFacebookAction() -> UIAlertAction {
        return UIAlertAction(title: "Share on Facebook", style: .Default, handler: {
            (action) -> Void in
            
            // check if Facebook service is available
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let fbComposerVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                fbComposerVC.addImage(self.detailImageView.image!)
                self.presentViewController(fbComposerVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged in to your Twitter account")
            }
        })
    }
    
    func getMoreAction() -> UIAlertAction {
        return UIAlertAction(title: "More", style: .Default, handler: {
            (action) -> Void in
            
            let vc = UIActivityViewController(activityItems: [self.detailImageView.image!], applicationActivities: [])
            vc.excludedActivityTypes = [UIActivityTypePostToFacebook, UIActivityTypePostToTwitter]
            self.presentViewController(vc, animated: true, completion: nil)
        })

    }
    
    func getTweetAction() -> UIAlertAction {
        return UIAlertAction(title: "Share on Twitter", style: .Default, handler: {
            (action) -> Void in
            
            // check if Twitter service is available
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let twitterComposerVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterComposerVC.addImage(self.detailImageView.image!)
                self.presentViewController(twitterComposerVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged in to your Twitter account")
            }
        })
    }
    
    func showAlertMessage(message: String, var alertTitle: String?=nil, var alertStyle: UIAlertActionStyle?=nil, alertActionHandler: ((UIAlertAction) -> Void)?=nil) {
        let alertController = UIAlertController(title: "Storm Share", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // check for default values
        // title
        if alertTitle == nil {
            alertTitle = "Okay"
        }
        
        // alert style
        if alertStyle == nil {
            alertStyle = UIAlertActionStyle.Default
        }
        
        alertController.addAction(UIAlertAction(title: alertTitle!, style: alertStyle!, handler: alertActionHandler))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

