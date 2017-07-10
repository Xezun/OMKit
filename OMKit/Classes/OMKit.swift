//
//  OMKit.swift
//  Pods
//
//  Created by mlibai on 2017/6/28.
//
//

import Foundation




extension Bundle {
    
    private class OMKitBundleClass {}
    public static let OMKit: Bundle = Bundle(for: OMKitBundleClass.self)
    
}

extension UIImage {
    
    /// 读取 XZKit 中的资源图片。
    public convenience init?(OMKit name: String, compatibleWith traitCollection: UITraitCollection? = nil) {
        #if COCOAPODS
            let resourceBundle = Bundle(url: Bundle.OMKit.url(forResource: "OMKit", withExtension: "bundle")!)!
            self.init(named: name, in: resourceBundle, compatibleWith: traitCollection)
        #else
            self.init(named: name, in: Bundle.XZKit, compatibleWith: traitCollection)
        #endif
    }
    
}
