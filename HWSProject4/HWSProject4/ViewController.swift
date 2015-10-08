//
//  ViewController.swift
//  HWSProject4
//
//  Created by Muya on 01/10/2015.
//  Copyright © 2015 muya. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var allowedWebsites = ["apple.com", "hackingwithswift.com", "muya.co.ke"]
    
    var spacerButton:UIBarButtonItem!
    var refreshButton:UIBarButtonItem!
    var stopButton:UIBarButtonItem!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL(string: "https://" + allowedWebsites[2])!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.allowsBackForwardNavigationGestures = true
        
        // observe estimated progress
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
        
        // add Open Link Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .Plain, target: self, action: "openTapped")
        
        // some more buttons
        // progress view
        progressView = UIProgressView(progressViewStyle: .Default)
        progressView.sizeToFit()
        progressView.hidden = true
        let progressButton = UIBarButtonItem(customView: progressView)
        
        spacerButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshTapped")
        stopButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "stopTapped")
        
        toolbarItems = [progressButton, spacerButton, refreshButton, stopButton]
        navigationController?.toolbarHidden = false
    }
    
    // stops loading a page
    func stopTapped() {
        webView.stopLoading()
    }
    
    // refreshes a page
    func refreshTapped() {
        webView.reload()
    }
    
    // displays list of available websites to the user
    func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .ActionSheet)
        for site in allowedWebsites {
            ac.addAction(UIAlertAction(title: site, style: .Default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func openPage(action: UIAlertAction!) {
        let url = NSURL(string: "https://" + action.title!)
        webView.loadRequest(NSURLRequest(URL: url!))
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        refreshButton.enabled = false
        stopButton.enabled = true
        title = "Loading..."
        progressView.hidden = false
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        refreshButton.enabled = true
        stopButton.enabled = false
        title = webView.title
        progressView.hidden = true
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.URL
        
        if let host = url!.host {
            for site in allowedWebsites {
                if host.rangeOfString(site) != nil {
                    decisionHandler(.Allow)
                    return
                }
            }
        }
        decisionHandler(.Cancel)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

