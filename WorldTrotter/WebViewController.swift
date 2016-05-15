//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by David Lawrence on 5/15/16.
//  Copyright © 2016 focusedConcepts. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var webView: UIWebView!
    
    override func loadView() {
        //create a web view
        webView = UIWebView()
        
        //set it as the primary view of this view controller
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("WebViewController loaded its view")
        
        let requestURL = NSURL(string:"http://www.bignerdranch.com")
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
