//
//  MenuBarItemView.swift
//  OMKit
//
//  Created by mlibai on 2017/5/16.
//  Copyright © 2017年 mlibai. All rights reserved.
//

import Foundation


open class MenuBarItemView: UIControl {
    
    open let textLabel: UILabel     = UILabel()
    open let imageView: UIImageView  = UIImageView()
    
    open var contentInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var textInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var imageInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    
    open override var contentMode: UIViewContentMode {
        didSet {
            imageView.contentMode = contentMode
            textLabel.contentMode = contentMode
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        didInitialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitialize()
    }
    
    private func didInitialize() {
        addSubview(textLabel)
        addSubview(imageView)
    }
    
    override open var intrinsicContentSize: CGSize {
        let labelSize = textLabel.intrinsicContentSize
        let imageSize = imageView.intrinsicContentSize
        return CGSize(width: max(labelSize.width, imageSize.width), height: labelSize.height + imageSize.height)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.sizeToFit()
        textLabel.sizeToFit()
        
        let kBounds = self.bounds
        
        let hasImage = (imageView.image != nil)
        let hasText = (textLabel.text != nil && textLabel.text!.characters.count > 0)
        
        if hasImage && !hasText {
            let frame = imageView.frame
            let width = min(frame.width, kBounds.width)
            let height = min(frame.height, kBounds.height)
            imageView.frame = CGRect(
                x: (kBounds.width - width) * 0.5,
                y: (kBounds.height - height) * 0.5,
                width: width,
                height: height
            )
        } else if !hasImage && hasText {
            let frame = textLabel.frame
            let width = min(frame.width, kBounds.width)
            let height = min(frame.height, kBounds.height)
            textLabel.frame = CGRect(
                x: (kBounds.width - width) * 0.5,
                y: (kBounds.height - height) * 0.5,
                width: width,
                height: height
            )
        } else if !hasImage && !hasText {
            imageView.frame = .zero
            textLabel.frame = .zero
        } else {
            var imageFrame = imageView.frame
            var textFrame = textLabel.frame
            
            imageFrame.size.width = min(imageFrame.width, kBounds.width)
            textFrame.size.width = min(textFrame.width, kBounds.width)
            
            let totalHeight = (imageFrame.height + textFrame.height)
            let contentHeight = kBounds.height - 8.0
            
            imageFrame.size.height = min(imageFrame.height, contentHeight * imageFrame.height / totalHeight)
            textFrame.size.height = min(textFrame.height, contentHeight * textFrame.height / totalHeight)
            
            imageFrame.origin.x = (kBounds.width - imageFrame.width) * 0.5
            imageFrame.origin.y = (kBounds.height - imageFrame.height - textFrame.height - 8.0) * 0.5
            imageView.frame = imageFrame
            
            
            textFrame.origin.x = (kBounds.width - textFrame.width) * 0.5
            textFrame.origin.y = imageFrame.maxY + 8.0
            textLabel.frame = textFrame
        }
    }
    
    open var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
            setNeedsLayout()
        }
    }
    
    open var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            setNeedsLayout()
        }
    }
    
    open var titleColor: UIColor? {
        get { return textLabel.textColor }
        set { textLabel.textColor = newValue }
    }
    
    open var titleFont: UIFont? {
        get { return textLabel.font }
        set { textLabel.font = newValue }
    }
}










