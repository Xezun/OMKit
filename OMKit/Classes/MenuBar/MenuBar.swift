//
//  MenuBar.swift
//  MenuView
//
//  Created by mlibai on 2017/5/10.
//  Copyright © 2017年 mlibai. All rights reserved.
//

import UIKit
import SDWebImage




public protocol MenuBarDelegate: class {

    func menuBar(_ menuBar: MenuBar, didSelectItemAt index: Int) -> Void
    
}

open class MenuBar: UIView {
    
    convenience public init(items: [MenuBarItem]?) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 49.0))
        self.items = items;
        layoutItemViewsIfNeeded()
    }
    
    open weak var delegate: MenuBarDelegate?
    
    let scrollView: UIScrollView = UIScrollView()
    let indicatorImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitialize()
    }
    
    private func didInitialize() {
        scrollView.clipsToBounds = false
        scrollView.frame = bounds
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        scrollView.addSubview(indicatorImageView)
    }
    
    
    open var indicatorColor: UIColor? {
        get {
            return indicatorImageView.backgroundColor
        }
        set {
            indicatorImageView.backgroundColor = newValue
        }
    }
    
    open var indicatorImage: UIImage? {
        get {
            return indicatorImageView.image
        }
        set {
            indicatorImageView.image = newValue
        }
    }
    
    open var items: [MenuBarItem]? {
        didSet {
            layoutItemViewsIfNeeded()
        }
    }
    
    open var selectedIndex: Int? {
        get {
            guard let selectedItemView = self.selectedItemView else { return nil }
            guard let index = itemViews.index(of: selectedItemView) else {
                return nil
            }
            return index
        }
        set {
            guard let index = newValue else {
                selectedItemView = nil
                return
            }
            selectedItemView = itemViews[index]
        }
    }
    
    /// 宽度，nil 表示自适应
    open var itemWidth: CGFloat? {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 间距，不影响 item 宽度，会影响总宽度。
    open var itemSpacing: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 指示器高度，默认与 item 同宽。
    open var indicatorHeight: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 指示器边距，仅左右，上下不起作用。
    open var indicatorInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    // Style
    open var titleColor: UIColor? {
        didSet {
            for itemView in itemViews {
                if !itemView.isEqual(selectedItemView) {
                    itemView.textLabel.textColor   = titleColor
                }
            }
        }
    }
    open var selectedTitleColor: UIColor? {
        didSet {
            selectedItemView?.textLabel.textColor = selectedTitleColor ?? titleColor
        }
    }
    
    open var titleFont: UIFont? {
        didSet {
            for itemView in itemViews {
                if !itemView.isEqual(selectedItemView) {
                    itemView.textLabel.font = titleFont
                }
            }
        }
    }
    open var selectedTitleFont: UIFont? {
        didSet {
            selectedItemView?.textLabel.font = selectedTitleFont ?? titleFont
        }
    }
    
    open var imageAlpha: CGFloat? {
        didSet {
            for itemView in itemViews {
                if !itemView.isEqual(selectedItemView) {
                    itemView.imageView.alpha = imageAlpha ?? 1.0
                }
            }
        }
    }
    
    open var selectedImageAlpha: CGFloat? {
        didSet {
            selectedItemView?.imageView.alpha = selectedImageAlpha ?? imageAlpha ?? 1.0
        }
    }
    
    
    
    
    var itemViews: [MenuBarItemView] = []
    var selectedItemView: MenuBarItemView? {
        didSet {
            guard oldValue != selectedItemView else {
                return
            }
            
            if let old = oldValue {
                old.textLabel.textColor = titleColor
                old.textLabel.font = titleFont
                old.imageView.alpha = imageAlpha ?? 1.0
            }
            
            if let new = selectedItemView {
                new.textLabel.textColor = selectedTitleColor ?? titleColor
                new.textLabel.font = selectedTitleFont ?? titleFont
                new.imageView.alpha = selectedImageAlpha ?? imageAlpha ?? 1.0
                
                let center = new.center
                let width = scrollView.bounds.width
                let x = min(max(0, center.x - width * 0.5), scrollView.contentSize.width - width)
                scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
                
                layoutIndicatorImageView()
            }
            
        }
    }
    
    func layoutItemViewsIfNeeded() -> Void {
        if items?.count != itemViews.count {
            let count = items?.count ?? 0
            
            if count < itemViews.count {
                itemViews.removeSubrange(count ..< itemViews.count)
            } else if count > itemViews.count {
                for index in itemViews.count ..< count {
                    let itemView = MenuBarItemView(frame: .zero)
                    itemView.text                  = items?[index].title
                    itemView.image                  = items?[index].image
                    if let imageURL = items?[index].imageURL {
                        SDWebImageManager.shared().loadImage(with: imageURL, options: .retryFailed, progress: nil, completed: { (image, data, error, cacheType, success, imageURL) in
                            if image != nil {
                                itemView.image = image
                            }
                        })
                    }
                    itemView.textLabel.textColor   = titleColor
                    itemView.textLabel.font        = titleFont
                    itemView.addTarget(self, action: #selector(itemViewAction(_:)), for: .touchUpInside)
                    scrollView.addSubview(itemView)
                    itemViews.append(itemView)
                }
            }
        }
        
        for index in 0 ..< itemViews.count {
            let itemView = itemViews[index]
            items?[index].delegate = self
            itemView.text  = items?[index].title
            itemView.image  = items?[index].image
            if let imageURL = items?[index].imageURL {
                SDWebImageManager.shared().loadImage(with: imageURL, options: .retryFailed, progress: nil, completed: { (image, data, error, cacheType, success, imageURL) in
                    if image != nil {
                        itemView.image = image
                    }
                })
            }
            if itemView != selectedItemView {
                itemView.textLabel.textColor = titleColor
                itemView.textLabel.font      = titleFont
                itemView.imageView.alpha      = imageAlpha ?? 1.0
            } else {
                itemView.textLabel.textColor = selectedTitleColor ?? titleColor
                itemView.textLabel.font      = selectedTitleFont ?? titleFont
                itemView.imageView.alpha      = selectedImageAlpha ?? imageAlpha ?? 1.0
            }
        }
        
        layoutIndicatorImageView()
        
        setNeedsLayout()
    }
    
    func layoutIndicatorImageView() {
        let frame = selectedItemView?.frame ?? .zero
        let x = frame.minX - indicatorInsets.left
        let y = frame.maxY
        let width = frame.width - indicatorInsets.left - indicatorInsets.right
        UIView.animate(withDuration: 0.25, animations: {
            self.indicatorImageView.frame = CGRect(x: x, y: y, width: width, height: self.indicatorHeight)
        })
    }
    
    @objc func itemViewAction(_ itemView: MenuBarItemView) {
        selectedItemView = itemView
        
        if let index = itemViews.index(of: itemView) {
            delegate?.menuBar(self, didSelectItemAt: index)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let BOUNDS = bounds
        
        var contentWidth: CGFloat = 0.0
        let contentHeight: CGFloat = BOUNDS.height
        
        
        var widths: [CGFloat] = []
    
        for item in itemViews {
            let width = itemWidth ?? { () -> CGFloat in
                item.layoutIfNeeded()
                return max(item.textLabel.frame.width, item.imageView.frame.width)
                }()
            widths.append(width)
            if contentWidth > 0 {
                contentWidth += (width + itemSpacing)
            } else {
                contentWidth = width
            }
        }
        
        if contentWidth < BOUNDS.width {
            scrollView.frame = CGRect(x: BOUNDS.width - contentWidth, y: 0, width: contentWidth, height: contentHeight)
        } else {
            scrollView.frame = BOUNDS
        }
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        var x: CGFloat      = contentWidth
        let y: CGFloat      = 0
        var width: CGFloat  = 0
        let height: CGFloat = BOUNDS.height - indicatorHeight
        for index in 0 ..< itemViews.count {
            width = widths[index]
            if x != contentWidth {
                x = x - (width + itemSpacing)
            } else {
                x = x - width
            }
            itemViews[index].frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        layoutIndicatorImageView()
        
        // fix the contentOffset
        if let item = selectedItemView {
            let center = item.center
            let width = scrollView.bounds.width
            let x = min(max(0, center.x - width * 0.5), scrollView.contentSize.width - width)
            scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        } else {
            scrollView.contentOffset = CGPoint(x: contentWidth - scrollView.bounds.width, y: 0)
        }
    }
    


}

extension MenuBar: MenuBarItemDelegate {
    
    func menuBarItemDidChangeContent(_ menuBarItem: MenuBarItem) {
        guard let index = items?.index(of: menuBarItem) else { return }
        
        let itemView = itemViews[index]
        if itemView == selectedItemView {
            itemView.text                  = items?[index].title
            itemView.image                  = items?[index].image
            itemView.textLabel.textColor = selectedTitleColor
            itemView.textLabel.font      = selectedTitleFont
            itemView.imageView.alpha      = selectedImageAlpha ?? imageAlpha ?? 1.0
        } else {
            itemView.text                  = items?[index].title
            itemView.image                  = items?[index].image
            itemView.textLabel.textColor = titleColor
            itemView.textLabel.font      = titleFont
            itemView.imageView.alpha      = imageAlpha ?? 1.0
        }
        
        
    }
}





