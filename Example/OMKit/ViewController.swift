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
    lazy var newsDetailHTML: NewsDetailHTML = self.createOmHTML()
        
    func createOmHTML() -> NewsDetailHTML {
        return NewsDetailHTML(webView: webView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 9.0, *) {
            webView.configuration.applicationNameForUserAgent = "Onemena/1.0.0"
        } else {
            
        }
        
        self.messageHandler = NewsDetailMessageHandler(delegate: self, webView: webView, viewController: self)
        
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

extension ViewController: NewsDetailMessageHandlerDelegate {
    
    func ready(_ completion: () -> Void) {
        completion()
        
        newsDetailHTML.setTitle("Title")
        newsDetailHTML.setDate("2011-12-11")
        newsDetailHTML.setWriterName("Super Man")
        newsDetailHTML.setWriterAvatar("")
        newsDetailHTML.setContent("Content")
        newsDetailHTML.setNumberOfLikes(100)
        newsDetailHTML.setNumberOfDislikes(10)
        newsDetailHTML.setUserLikeDislikeState(-1)
        newsDetailHTML.setNumberOfComments(99)
        newsDetailHTML.setSharePathHidden("facebook")
    }
    
    func numberOfRowsInList(_ list: NewsDetailList) -> Int {
        return 4
    }
    
    func list(_ list: NewsDetailList, dataForRowAt index: Int) -> [String : Any] {
        return [:]
    }
    
    func list(_ list: NewsDetailList, didSelectRowAt index: Int) {
        
    }
    
    func followButtonWasClicked(_ isSelected: Bool, completion: (Bool) -> Void) {
        completion(!isSelected);
    }
    
    func conentLinkWasClicked() {
        
    }
    
    func likeButtonWasClicked(_ isSelected: Bool, completion: (Bool) -> Void) {
        completion(!isSelected)
    }
    
    func dislikeButtonWasClicked(_ isSelected: Bool, completion: (Bool) -> Void) {
        completion(!isSelected)
    }
    
    func sharePathWasClicked(_ sharePath: String) {
        
    }
    
    func navigationBarInfoButtonWasClicked() {
        
    }
    
    func toolBarShareButtonClicked() {
        
    }
    
    func toolBarCollectButtonClicked(_ isSelected: Bool, completion: (Bool) -> Void) {
        completion(!isSelected)
    }
    
    func loadComments() {
        newsDetailHTML.reloadList(.comments)
    }
    
    func loadReplies() {
        newsDetailHTML.reloadList(.floor)
    }
    
    func commentsList(_ commentsList: NewsDetailList, likeButtonAt index: Int, wasClicked isSelected: Bool, completion: (Bool) -> Void) {
        completion(!isSelected)
    }
    
}

