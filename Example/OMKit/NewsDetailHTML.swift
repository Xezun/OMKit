//
//  NewsDetailHTML.swift
//  OMKit
//
//  Created by mlibai on 2017/9/7.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailHTML {
    
    unowned let webView: WKWebView
    
    init(webView: WKWebView) {
        self.webView = webView
    }
    
    /// 刷新指定的列表。
    ///
    /// - Parameters:
    ///   - list: 列表
    ///   - all: 是否全部刷新。默认 false 。如果 true 则刷新整个列表，否则根据当前列表状态和数据源状态决定添加新数据或删除多余的数据。
    func reloadList(_ list: NewsDetailList, all: Bool = false) {
        switch list {
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
    
    /// 设置标题。
    ///
    /// - Parameter title: 标题。如果为 nil ，默认空字符串。
    func setTitle(_ title: String?) {
        setValue(title, forProperty: "title")
    }
    
    func setContent(_ content: String?) {
        setValue(content, forProperty: "content")
    }
    
    func setDate(_ date: String?) {
        setValue(date, forProperty: "date")
    }
    
    func setWriterName(_ name: String?) {
        setValue(name, forProperty: "writer.name")
    }
    
    func setWriterAvatar(_ avatar: String?) {
        guard let avatar = avatar else { return }
        setValue(avatar, forProperty: "writer.avatar")
    }
    
    func setLinkHref(_ href: String?) {
        setValue(href, forProperty: "link.href")
    }
    
    func setLinkText(_ text: String?) {
        setValue(text, forProperty: "link.text")
    }
    
    func setNumberOfComments(_ numberOfComments: Int) {
        setValue("\(numberOfComments)", forProperty: "numberOfComments")
    }
    
    func setNumberOfLikes(_ numberOfLikes: Int) {
        setValue("\(numberOfLikes)", forProperty: "actions.numberOfLikes")
    }
    
    func setNumberOfDislikes(_ numberOfDislikes: Int) {
        setValue("\(numberOfDislikes)", forProperty: "actions.numberOfDislikes")
    }
    
    func setUserLikeDislikeState(_ userLikeDislikeState: Int) {
        setValue(String(userLikeDislikeState), forProperty: "actions.userLikeDislikeState")
    }
    
    func setSharePathHidden(_ sharePath: String) {
        let js = "omHTML.share.hide('\(sharePath)');"
        webView.evaluateJavaScript("omHTML.share.hide('\(sharePath)');", completionHandler: { (data, error) in
            #if DEBUG
                if let error = error {
                    print("[JavaScript] An error occured when run script `\(js)`. \n\t\(error).")
                }
            #endif
        })
    }
    
    private func setValue(_ value: String?, forProperty property: String) {
        let encoded = value?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        let js = "omHTML.\(property) = decodeURIComponent('\(encoded)');"
        webView.evaluateJavaScript(js, completionHandler: { (data, error) in
            #if DEBUG
                if let error = error {
                    print("[JavaScript] An error occured when run script `\(js)`. \n\t\(error).")
                }
            #endif
        })
    }
    
}
