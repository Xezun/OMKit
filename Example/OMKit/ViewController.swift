//
//  ViewController.swift
//  OMKit
//
//  Created by mlibai on 05/20/2017.
//  Copyright (c) 2017 mlibai. All rights reserved.
//

import UIKit
import WebKit

import OMKit




class ViewController: UIViewController {
    
    deinit {
        messageHandler?.removeFromWebView()
        print("ViewController deinit")
    }
    
    override func loadView() {
        self.view = WKWebView(frame: UIScreen.main.bounds);
    }
    
    var webView: WKWebView {
        return view as! WKWebView
    }
    
    weak var messageHandler: WebViewMessageHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 9.0, *) {
            webView.configuration.applicationNameForUserAgent = "Onemena/1.0.0"
        } else {
            // Fallback on earlier versions
        }
        
        self.messageHandler = NewsDetailMessageHandler(for: webView, viewController: self);
        
        let url = Bundle.main.url(forResource: "HTML", withExtension: "bundle")!
        if #available(iOS 9.0, *) {
            webView.loadFileURL(url.appendingPathComponent("news/detail/index.html"), allowingReadAccessTo: url)
        } else {
            // Fallback on earlier versions
        };
        
        webView.scrollView.bounces = false
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    



}

