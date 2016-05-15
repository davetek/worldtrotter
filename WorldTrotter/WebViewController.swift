//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by David Lawrence on 5/14/16.
//  Copyright © 2016 focusedConcepts. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    var URLPath = "http://www.bignerdranch.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WebViewController loaded its view")
        
        view.addSubview(webView)
        loadURL()
        
    }
    
    func loadURL() {
        let requestURL = NSURL(string:URLPath)
        print(requestURL)
        let request = NSURLRequest(URL: requestURL!)
        print(request)
        if webView != nil {
            webView.loadRequest(request)
        } else {
            print("webView is nil")
        }
    }
}
