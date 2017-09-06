//
//  NewsDetailMessageHandler.swift
//  OMKit
//
//  Created by mlibai on 2017/9/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
import OMKit

enum NewsDetailList: String {
    
    case more       = "More List"
    case hots       = "Hot Comments List"
    case comments   = "Comments List"
    case floor      = "Floor List"
    
    func reloadData(_ webView: WKWebView, all: Bool = false)  {
        switch self {
        case .more:
            webView.evaluateJavaScript("omHTML.more.list.reloadData(\(all));", completionHandler: nil);
            break
        case .hots:
            webView.evaluateJavaScript("omHTML.hots.list.reloadData(\(all));", completionHandler: nil);
            break
        case .comments:
            webView.evaluateJavaScript("omHTML.comments.list.reloadData(\(all));", completionHandler: nil);
            break
        case .floor:
            webView.evaluateJavaScript("omHTML.floor.list.reloadData(\(all));", completionHandler: nil);
            break
        }
    }
    
}

protocol NewsDetailMessageHandlerDelegate: class {
    
    func numberOfRowsInList(_ list: NewsDetailList) -> Int
    func list(_ list: NewsDetailList, dataForRowAt index: Int) -> [String: Any]
    
    func list(_ list: NewsDetailList, didSelectRowAt index: Int)
    
}

class NewsDetailMessageHandler: WebViewMessageHandler {
    
    unowned let delegate: NewsDetailMessageHandlerDelegate
    
    init(delegate: NewsDetailMessageHandlerDelegate, webView: WKWebView, viewController: UIViewController) {
        self.delegate = delegate
        super.init(webView: webView, viewController: viewController)
    }

    override func ready(_ completion: @escaping () -> Void) {
        completion();
    }
    
    override func document(_ document: String, numberOfRowsInList list: String, completion: @escaping (Int) -> Void) {
        if let list = NewsDetailList.init(rawValue: list) {
            completion(delegate.numberOfRowsInList(list));
        } else {
            super.document(document, numberOfRowsInList: list, completion: completion)
        }
    }
    
    override func document(_ document: String, list: String, dataForRowAt index: Int, completion: @escaping ([String : Any]) -> Void) {
        if let list = NewsDetailList.init(rawValue: list) {
            completion(delegate.list(list, dataForRowAt: index))
        } else {
            super.document(document, list: list, dataForRowAt: index, completion: completion)
        }
    }
    
    override func document(_ document: String, list: String, didSelectRowAt index: Int, completion: @escaping () -> Void) {
        if let list = NewsDetailList.init(rawValue: list) {
            delegate.list(list, didSelectRowAt: index)
            completion()
        } else {
            super.document(document, list: list, didSelectRowAt: index, completion: completion)
        }
    }
    
    override func document(_ document: String, elementWasClicked element: String, data: Any, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            completion(false)
        }
    }
    
    
    
    
    
}
