//
//  NewsDetailMessageHandler.swift
//  OMKit
//
//  Created by mlibai on 2017/9/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import OMKit

class NewsDetailMessageHandler: WebViewMessageHandler {

    override func ready(_ completion: @escaping () -> Void) {
        completion();
    }
    
    override func document(_ document: String, numberOfRowsInList list: String, completion: @escaping (Int) -> Void) {
        switch list {
        case "More List":
            completion(4);
            
        case "Hot Comments List":
            completion(2)
            
        case "Comments List":
            completion (10)
            
        default:
            super.document(document, numberOfRowsInList: list, completion: completion)
            break
        }
    }
    
    override func document(_ document: String, list: String, dataForRowAt index: Int, completion: @escaping ([String : Any]) -> Void) {
        switch list {
        case "More List":
            completion([
                "id": index,
                "title": "News detail more news list \(index)",
                "avatar": "http://src.mysada.com/shop/file/png/phpVMZjH9.png",
                "writer": [
                    "name": "Onemena_\(index)",
                    "avatar": "http://src.mysada.com/shop/file/png/phpVMZjH9.png"
                ]
            ]);
            
        case "Hot Comments List": fallthrough
        case "Comments List": fallthrough
        case "Floor List":
            completion([
                "id": index,
                "content": "Content",
                "avatar": "http://src.mysada.com/shop/file/png/phpVMZjH9.png",
                "writer": [
                    "name": "علاء الريحاني",
                    "avatar": "http://src.mysada.com/shop/file/png/phpVMZjH9.png"
                ],
                "isLiked": false,
                "numberOfLikes": arc4random_uniform(1000),
                "date": "قبل..دقيقة  ·",
                "numberOfReplies": index
                ])
            
    
            
        default:
            super.document(document, list: list, dataForRowAt: index, completion: completion)
            break
        }
    }
    
    override func cachedResource(forURL url: String, resoureType: String, downloadIfNotExists download: Bool, completion: @escaping (String) -> Void) {
        completion(url);
    }
    
    override func document(_ document: String, elementWasClicked element: String, data: Any, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            completion(false)
        }
    }
    
    override func document(_ document: String, list: String, didSelectRowAt index: Int, completion: @escaping () -> Void) {
        switch list {
        case "More List":
            break
            
        default:
            super.document(document, list: list, didSelectRowAt: index, completion: completion)
            break
        }
    }
    
    
    
}
