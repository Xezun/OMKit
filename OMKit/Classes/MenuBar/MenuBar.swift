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
    
    /// MenuBar 中 item 的个数。
    ///
    /// - Parameter menuBar: The MenuBar who call this method.
    /// - Returns: The count of the menu bar item.
    func numberOfItems(in menuBar: MenuBar) -> Int
    
    /// 获取 MenuBar 的 item 对应的 view 。
    ///
    /// - Parameters:
    ///   - menuBar: The MenuBar who call this method.
    ///   - index: The index of the item.
    ///   - reusingView: The reusing view, may be nil.
    /// - Returns: The item view for the item.
    func menuBar(_ menuBar: MenuBar, viewForItemAt index: Int, reusingView: MenuBarItemView?) -> MenuBarItemView
    
    /// 获取 item 的宽度。
    ///
    /// - Parameters:
    ///   - menuBar: The MenuBar who call this method.
    ///   - index: The index of the item.
    /// - Returns: The width of the item.
    func menuBar(_ menuBar: MenuBar, widthForItemAt index: Int) -> CGFloat
    
    /// 当用户点击到指定的 item 时，此方法会被调用。
    /// - 设置 selectedIndex 不会触发此方法。
    ///
    /// - Parameters:
    ///   - menuBar: The MenuBar who call this method.
    ///   - index: The index of the item.
    /// - Returns: The width of the item.
    func menuBar(_ menuBar: MenuBar, didSelectItemAt index: Int) -> Void
    
}

open class MenuBar: UIView {
    
    /// 设置代理会自动刷新 MenuBar 。
    open weak var delegate: MenuBarDelegate? {
        didSet {
            reloadData()
        }
    }
    
    /// MenuBar 用于横向滚动的 UIScrollView 。
    public let scrollView: UIScrollView = UIScrollView()
    let indicatorImageView: UIImageView = UIImageView()
    
    override public init(frame: CGRect) {
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
        
        indicatorImageView.contentMode = .scaleAspectFit
        indicatorImageView.backgroundColor = UIColor.black
        scrollView.addSubview(indicatorImageView)
    }
    
    /// 指示器颜色。
    open var indicatorColor: UIColor? {
        get {
            return indicatorImageView.backgroundColor
        }
        set {
            indicatorImageView.backgroundColor = newValue
        }
    }
    
    /// 指示器图片，图片会在指示器中保持宽高比进行缩放。
    open var indicatorImage: UIImage? {
        get {
            return indicatorImageView.image
        }
        set {
            indicatorImageView.image = newValue
        }
    }
    
    
    /// 设置或获取当前选中的 item 的次序。设置该属性不会触发代理事件。
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
            // 设置 index 会更新 contentOffset，手动操作时不触发。
            updateContentOffset()
        }
    }
    
    /// 间距，不影响 item 宽度，会影响总宽度。
    open var itemSpacing: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 指示器高度，默认与 item 同宽。
    open var indicatorHeight: CGFloat = 2 {
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
    
    var itemViews: [MenuBarItemView] = []
    
    weak var selectedItemView: MenuBarItemView? {
        didSet {
            oldValue?.isSelected = false
            selectedItemView?.isSelected = true
            updateIndicator()
        }
    }
    
    // 更新 MenuBar 中的视图。
    open func reloadData() -> Void {
        guard let count = self.delegate?.numberOfItems(in: self), count > 0 else {
            let count = itemViews.count
            for index in (0 ..< count).reversed() {
                itemViews[index].removeFromSuperview()
                itemViews.removeLast()
            }
            indicatorImageView.frame = .zero
            return
        }
        
        let selectedIndex = self.selectedIndex
        
        if count < itemViews.count {
            itemViews.removeSubrange(count ..< itemViews.count)
        }
        
        for index in 0 ..< count {
            let reusingView: MenuBarItemView? = (index < itemViews.count ? itemViews[index] : nil)
            let itemView = delegate!.menuBar(self, viewForItemAt: index, reusingView: reusingView)
            if itemView != reusingView {
                itemView.delegate = self
                scrollView.addSubview(itemView)
                itemViews.append(itemView)
            }
            itemView.isSelected = false
        }
        
        if let selectedIndex = selectedIndex {
            if selectedIndex < itemViews.count {
                selectedItemView = itemViews[selectedIndex]
            }
        }
        
        updateIndicator()
        
        setNeedsLayout()
    }
    
    func updateIndicator() {
        let frame   = selectedItemView?.frame ?? .zero
        let x       = frame.minX - indicatorInsets.left
        let y       = frame.maxY
        let width   = frame.width - indicatorInsets.left - indicatorInsets.right
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
        
        let count  = itemViews.count
        
        guard count > 0 else {
            return
        }
        
        let kBounds = bounds
        
        var contentWidth: CGFloat = -itemSpacing
        let contentHeight: CGFloat = kBounds.height
        
        var widths: [CGFloat] = []
        
        for index in 0 ..< itemViews.count {
            let width = delegate!.menuBar(self, widthForItemAt: index)
            widths.append(width)
            contentWidth += (width + itemSpacing)
        }
        
        if contentWidth < kBounds.width {
            scrollView.frame = CGRect(x: kBounds.width - contentWidth, y: 0, width: contentWidth, height: contentHeight)
        } else {
            scrollView.frame = kBounds
        }
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        var x: CGFloat      = contentWidth
        let y: CGFloat      = 0
        var width: CGFloat  = 0
        let height: CGFloat = kBounds.height - indicatorHeight
        for index in 0 ..< itemViews.count {
            width = widths[index]
            if x != contentWidth {
                x = x - (width + itemSpacing)
            } else {
                x = x - width
            }
            itemViews[index].frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        updateIndicator()
        updateContentOffset()
    }
    
    func updateContentOffset() {
        if let item = selectedItemView {
            let center = item.center
            let width = scrollView.bounds.width
            let x = min(max(0, center.x - width * 0.5), scrollView.contentSize.width - width)
            scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        } else {
            scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.width, y: 0)
        }
    }
    
}

extension MenuBar: MenuBarItemViewDelegate {
    
    func menuBarItemViewWasTapped(_ menuBarItemView: MenuBarItemView) {
        selectedItemView = menuBarItemView
    }
    
}





