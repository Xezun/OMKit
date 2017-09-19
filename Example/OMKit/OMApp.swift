//
//  OMApp.swift
//  OMKit
//
//  Created by mlibai on 2017/9/18.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class OMApp: NSObject {
    
    class NavigationBar {
        
        var isHidden: Bool = false
        var title: String?
        var titleColor: UIColor?
        var backgroundColor: UIColor?
        
    }
    
    class User {
        
        var id: String
        var name: String
        var type: String
        var coin: Int
        
        init(id: String, name: String, type: String, coin: Int) {
            self.id = id
            self.name = name
            self.type = type
            self.coin = coin
        }
    }
    
    enum Theme: String {
        case day
        case night
    }
    
    unowned let webView: WKWebView
    
    init(webView: WKWebView, navigationBar: NavigationBar, currentUser: User, currentTheme: Theme) {
        self.webView = webView
        self.currentTheme = currentTheme
        super.init()
    }
    
    var currentTheme: Theme {
        didSet {
            webView.evaluateJavaScript("window.omApp.setCurrentTheme('\(currentTheme.rawValue)');", completionHandler: nil)
        }
    }
    
    /// 调度执行指定标识符的回调函数。
    ///
    /// - Parameters:
    ///   - callbackID: 回调函数的标识符
    ///   - arguments: 回调函数的参数
    func dispatch(_ callbackID: String, arguments: Any ...) {
        #if DEBUG
            let completion = { (_ result: Any?, _ error: Error?) in
                print("[OMApp] dispatch `\(callbackID)` with {result: \(result), error: \(error)}.")
            }
        #else
            let completion: ((Any?, Error?) -> Void)? = nil
        #endif
        // 按照约定，参数只能是基本数据类型（数字、字符串、布尔以及它们组成的字典和数组。
        let parameters = arguments.map({ (argument) -> String in
            if (argument is Dictionary<AnyHashable, Any>) || (argument is Array<Any>) {
                // 数组和字典，转换成字 JSON
                if let data = try? JSONSerialization.data(withJSONObject: argument, options: .prettyPrinted) {
                    if let string = String.init(data: data, encoding: .utf8) {
                        return string
                    }
                }
                return "null";
            } else if let aString = argument as? String {
                // 字符串，尽心 URL 编码
                if let encoded = aString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
                    return "decodeURIComponent('\(encoded)')"
                }
                return "null"
            }
            return String.init(describing: argument)
        }).joined(separator: ", ")
        webView.evaluateJavaScript("window.omApp.dispatch('\(callbackID)', \(parameters))", completionHandler: completion)
    }
    
    
    
    

}
