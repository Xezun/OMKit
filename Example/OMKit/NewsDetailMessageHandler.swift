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
    case floor      = "Floor Comments List"
    
}





protocol NewsDetailMessageHandlerDelegate: class {
    
    func ready(_ completion: () -> Void)
    
    func numberOfRowsInList(_ list: NewsDetailList) -> Int
    func list(_ list: NewsDetailList, dataForRowAt index: Int) -> [String: Any]
    
    func list(_ list: NewsDetailList, didSelectRowAt index: Int)
    
    func followButtonWasClicked(_ isSelected: Bool, completion: (Bool) -> Void)
    
    func conentLinkWasClicked()
    
    func likeButtonWasClicked(_ isSelected: Bool, completion: (_ isSelected: Bool) -> Void)
    func dislikeButtonWasClicked(_ isSelected: Bool, completion: (_ isSelected: Bool) -> Void)
    
    func sharePathWasClicked(_ sharePath: String)
    
    func navigationBarInfoButtonWasClicked()
    
    func toolBarShareButtonClicked()
    
    func toolBarCollectButtonClicked(_ isSelected: Bool, completion:(Bool) -> Void)
    
    // 加载评论
    func loadComments()
    
    // 加载叠楼回复
    func loadReplies()
    
    /// 评论点赞按钮被点击时。
    ///
    /// - Parameters:
    ///   - commentsList: 评论列表。
    ///   - index: 被点击的按钮所在列表的行索引。叠楼时，index = -1 表示楼主的评论被点击。
    ///   - isSelected: 按钮的当前状态。
    ///   - completion: 按钮被点击后的状态。
    func commentsList(_ commentsList: NewsDetailList, likeButtonAt index: Int, wasClicked isSelected: Bool, completion: (Bool)->Void)
    
}

class NewsDetailMessageHandler: WebViewMessageHandler {
    
    unowned let delegate: NewsDetailMessageHandlerDelegate
    
    init(delegate: NewsDetailMessageHandlerDelegate, webView: WKWebView, viewController: UIViewController) {
        self.delegate = delegate
        super.init(webView: webView, viewController: viewController)
    }

    override func ready(_ completion: @escaping () -> Void) {
        delegate.ready(completion)
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
    
    override func document(_ document: String, element: String, wasClicked data: Any, completion: @escaping (Bool) -> Void) {
        switch element {
        case "Follow Button":
            delegate.followButtonWasClicked(data as? Bool ?? false, completion: completion)
            
        case "Content Link":
            delegate.conentLinkWasClicked()
            
        case "Action Like":
            guard let isSelected = data as? Bool else { return }
            delegate.likeButtonWasClicked(isSelected, completion: completion)
            
        case "Action Dislike":
            guard let isSelected = data as? Bool else { return }
            delegate.dislikeButtonWasClicked(isSelected, completion: completion)
            
        case "Comments Load More":
            delegate.loadComments()
        
        case "Share Button":
            guard let sharePath = data as? String else { return }
            delegate.sharePathWasClicked(sharePath)
            
        case "Floor Load More":
            delegate.loadReplies()
            
        case "Hots Comments List Like Action":
            guard let dict = data as? [String: Any] else { return }
            guard let index = dict["index"] as? Int else { return }
            guard let isSelected = dict["isSelected"] as? Bool else { return }
            delegate.commentsList(.hots, likeButtonAt: index, wasClicked: isSelected, completion: completion)
            
        case "Comments List Like Action":
            guard let dict = data as? [String: Any] else { return }
            guard let index = dict["index"] as? Int else { return }
            guard let isSelected = dict["isSelected"] as? Bool else { return }
            delegate.commentsList(.comments, likeButtonAt: index, wasClicked: isSelected, completion: completion)
            
        case "Floor List Like Action":
            guard let dict = data as? [String: Any] else { return }
            guard let index = dict["index"] as? Int else { return }
            guard let isSelected = dict["isSelected"] as? Bool else { return }
            delegate.commentsList(.floor, likeButtonAt: index, wasClicked: isSelected, completion: completion)
            
        case "Floor Host Like Action":
            guard let dict = data as? [String: Any] else { return }
            guard let isSelected = dict["isSelected"] as? Bool else { return }
            delegate.commentsList(.floor, likeButtonAt: -1, wasClicked: isSelected, completion: { (isSelected) in
                completion(isSelected)
            })
            
        case "Navigation Bar Info":
            delegate.navigationBarInfoButtonWasClicked()
            
        case "Tool Bar Share":
            delegate.toolBarShareButtonClicked()
            
        case "Tool Bar Collect":
            guard let isSelected = data as? Bool else { return }
            delegate.toolBarCollectButtonClicked(isSelected, completion: completion)
            
        default:
            super.document(document, element: element, wasClicked: data, completion: completion)
        }
    }
    
    
   
    
}







