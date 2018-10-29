//
//  NavigationBar.swift
//  TT
//
//  Created by Onemena on 2017/4/6.
//  Copyright © 2017年 OneMena. All rights reserved.
//

import UIKit
import XZKit

extension NavigationGestureDrivable {
    
    public func viewControllerForPushGestureNavigation(_ navigationController: UINavigationController) -> UIViewController? {
        return nil
    }
    
    public func navigationController(_ navigationController: UINavigationController, edgesInsetsForGestureNavigation operation: UINavigationController.Operation) -> UIEdgeInsets? {
        return nil
    }
    
}

extension NavigationBarCustomizable where Self: UIViewController {
    
    public var navigationBar: NavigationBar {
        if let navigationBar = objc_getAssociatedObject(self, &AssociationKey.navigationBar) as? NavigationBar {
            return navigationBar
        }
        let navigationBar = NavigationBar.init(for: self)
        objc_setAssociatedObject(self, &AssociationKey.navigationBar, navigationBar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return navigationBar
    }
    
    public var navigationBarIfLoaded: (UIView & NavigationBaring)? {
        return objc_getAssociatedObject(self, &AssociationKey.navigationBar) as? NavigationBar
    }
    
}

private struct AssociationKey {
    static var navigationBar = 0
}


@objc(OMNavigationBar)
open class NavigationBar: XZKit.NavigationBar {
    
    weak var viewController: UIViewController?
    
    public init(for viewController: UIViewController) {
        self.viewController = viewController
        super.init(frame: UIScreen.main.bounds)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 标题文字。
    /// - Note: 显示标题文字的视图为 TitledImageView ，如果使用了其它自定义标题视图，则此属性将不起作用。
    open var title: String? {
        get {
            return (titleView as? TitledImageView)?.title
        }
        set {
            if let titleView = self.titleView {
                guard let textImageView = titleView as? TitledImageView else { return }
                textImageView.title = newValue
                textImageView.sizeToFit()
                self.setNeedsLayout()
            } else {
                let textImageView = TitledImageView.init(frame: .zero)
                textImageView.title = newValue
                textImageView.sizeToFit()
                self.titleView = textImageView
            }
        }
    }
    
    /// 标题图片。
    /// - 如果同时设置了标题文字和标题图片，文字和图片为上下显示的。
    /// - 显示标题图片的视图为 TitledImageView ，如果使用了其它自定义标题视图，则此属性将不起作用。
    open var titleImage: UIImage? {
        get {
            return (titleView as? TitledImageView)?.image
        }
        set {
            if let titleView = self.titleView {
                guard let textImageView = titleView as? TitledImageView else { return }
                textImageView.image = newValue
                textImageView.sizeToFit()
                self.setNeedsLayout()
            } else {
                let textImageView = TitledImageView.init(frame: .zero)
                textImageView.image = newValue
                self.titleView = textImageView
            }
        }
    }
    
    /// 标题文本颜色。
    open var titleTextColor: UIColor? {
        get {
            return (titleView as? TitledImageView)?.titleLabelIfLoaded?.textColor
        }
        set {
            if let titleView = self.titleView {
                guard let textImageView = titleView as? TitledImageView else { return }
                textImageView.titleLabel.textColor = newValue
            } else {
                let textImageView = TitledImageView.init(frame: .zero)
                textImageView.titleLabel.textColor = newValue
                self.titleView = textImageView
            }
        }
    }
    
    /// 标题文本字体。
    open var titleTextFont: UIFont? {
        get {
            return (titleView as? TitledImageView)?.titleLabelIfLoaded?.font
        }
        set {
            if let titleView = self.titleView {
                guard let textImageView = titleView as? TitledImageView else { return }
                textImageView.titleLabel.font = newValue
                textImageView.sizeToFit()
                setNeedsLayout()
            } else {
                let textImageView = TitledImageView.init(frame: .zero)
                textImageView.titleLabel.font = newValue
                self.titleView = textImageView
            }
        }
    }
    
    @objc private func XZKit_backButtonAction(_ button: UIButton) {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    /// 信息按钮，懒加载。右起第一个按钮。
    open var infoButton: UIButton? {
        if let infoView = self.infoView {
            if let itemView = infoView as? NavigationBarItemView {
                return itemView.trailingButton
            }
            return nil
        }
        let infoView = NavigationBarItemView.init(frame: .zero)
        self.infoView = infoView
        return infoView.trailingButton
    }
    
    /// 帮助按钮。右起第二个按钮。
    open var helpButton: UIButton? {
        if let infoView = self.infoView {
            if let itemView = infoView as? NavigationBarItemView {
                return itemView.leadingButton
            }
            return nil
        }
        let infoView = NavigationBarItemView.init(frame: .zero)
        self.infoView = infoView
        return infoView.leadingButton
    }
    
    /// 返回按钮。左起第一个按钮。
    open var backButton: UIButton? {
        if let backView = self.backView {
            guard let customBackView = backView as? NavigationBarItemView else { return nil }
            return customBackView.leadingButton
        }
        let customBackView = NavigationBarItemView.init(frame: .zero)
        customBackView.leadingButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        self.backView = customBackView
        return customBackView.leadingButton
    }
    
    /// 关闭按钮。左起第二个按钮。
    open var closeButton: UIButton? {
        if let backView = self.backView {
            guard let customBackView = backView as? NavigationBarItemView else { return nil }
            return customBackView.trailingButton
        }
        let customBackView = NavigationBarItemView.init(frame: .zero)
        customBackView.leadingButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        self.backView = customBackView
        return customBackView.trailingButton
    }
    
    /// 返回按钮事件。
    @objc open func backButtonAction(_ button: UIButton?) {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
}

extension UIViewController {
    
    /// 控制器将自己从 UINavigationController 栈中弹出。
    ///
    /// - Parameter animated: 当该值为布尔值时，表示是否动画。其它值表示一定执行动画。
    /// - Returns: 弹出的控制器
    @objc open func navigationControllerPopViewController(animated: Any?) -> UIViewController? {
        if let animated = animated as? Bool {
            return navigationController?.popViewController(animated: animated)
        }
        return navigationController?.popViewController(animated: true)
    }
    
    @objc open func navigationControllerPopToRootViewController(animated: Any?) -> [UIViewController]? {
        if let animated = animated as? Bool {
            return navigationController?.popToRootViewController(animated: animated)
        }
        return navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc open func dismiss(animated: Any?) {
        dismiss(animated: (animated as? Bool) ?? true, completion: nil)
    }
    
}


public class NavigationBarItemView: UIView {
    
    private class Button: UIButton {
        override func setTitle(_ title: String?, for state: UIControlState) {
            super.setTitle(title, for: state)
            superview?.setNeedsLayout()
        }
        
        override func setImage(_ image: UIImage?, for state: UIControlState) {
            super.setImage(image, for: state)
            superview?.setNeedsLayout()
        }
    }
    
    let leadingButton: UIButton = Button.init(type: .system)
    let trailingButton: UIButton = Button.init(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leadingButton.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(leadingButton)
        trailingButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trailingButton)
        
        let views: [String: Any] = ["leadingButton": leadingButton, "trailingButton": trailingButton]
        
        let lcs1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[leadingButton]-(>=8@999)-[trailingButton]-14-|", options: [.directionLeadingToTrailing, .alignAllCenterY], metrics: nil, views: views)
        let lcs2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[leadingButton]|", options: .alignAllLeading, metrics: nil, views: views)
        addConstraints(lcs1)
        addConstraints(lcs2)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        let size1 = leadingButton.sizeThatFits(size)
        let size2 = trailingButton.sizeThatFits(size)
        let edges = self.layoutMargins
        
        return CGSize.init(
            width: 14 + size1.width + 8 + size2.width + 14,
            height: edges.top + max(size1.height, size2.height) + edges.bottom
        )
    }
    
    override public var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.init(width: 1000, height: 1000))
    }
    
}


