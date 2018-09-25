//
//  CustomNavigationBar.swift
//  TT
//
//  Created by Onemena on 2017/4/6.
//  Copyright © 2017年 OneMena. All rights reserved.
//

import UIKit
import XZKit


public class CustomNavigationBarBackView: UIView {
    
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
    
    let backButton: UIButton = Button.init(type: .system)
    let closeButton: UIButton = Button.init(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layoutMargins = UIEdgeInsets.init(top: 0, left: 14, bottom: 0, right: 14)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(backButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        let views: [String: Any] = ["backButton": backButton, "closeButton": closeButton]
        
        let lcs1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[backButton]-(>=8@999)-[closeButton]-|", options: [.directionLeadingToTrailing, .alignAllCenterY], metrics: nil, views: views)
        let lcs2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[backButton]|", options: .alignAllLeading, metrics: nil, views: views)
        addConstraints(lcs1)
        addConstraints(lcs2)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        let size1 = backButton.sizeThatFits(size)
        let size2 = closeButton.sizeThatFits(size)
        let edges = self.layoutMargins
        
        return CGSize.init(
            width: edges.left + size1.width + 8 + size2.width + edges.right,
            height: edges.top + max(size1.height, size2.height) + edges.bottom
        )
    }
    
    override public var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.init(width: 1000, height: 1000))
    }
    
}

extension NavigationBar {
    
    /// 关闭按钮。
    /// - 只有当导航条类型为 CustomNavigationBar 时，才能使用此属性。
    /// - 在引用了 OMKit 时，遵循 NavigationBarCustomizable 协议默认生成的到导航条类型即为 CustomNavigationBar 。
    @objc(om_closeButton) open var closeButton: UIButton? {
        fatalError("必须在导航条类型为 CustomNavigationBar 时才能使用此属性。")
    }
    
}


open class CustomNavigationBar: XZKit.NavigationBar {
    
    /// OMKit 重写了返回按钮，但保持其基本特性与父类一致。
    override open var backButton: UIButton? {
        if let backView = self.backView {
            guard let customBackView = backView as? CustomNavigationBarBackView else { return nil }
            return customBackView.backButton
        }
        let customBackView = loadCustomBackView()
        self.backView = customBackView
        return customBackView.backButton
    }
    
    /// 导航条关闭按钮。
    /// - 关闭按钮与返回按钮同时存在。
    override open var closeButton: UIButton? {
        if let backView = self.backView {
            guard let customBackView = backView as? CustomNavigationBarBackView else { return nil }
            return customBackView.closeButton
        }
        let customBackView = loadCustomBackView()
        return customBackView.closeButton
    }
    
    private func loadCustomBackView() -> CustomNavigationBarBackView {
        let customBackView = CustomNavigationBarBackView.init(frame: .zero)
        customBackView.backButton.addTarget(self, action: #selector(customBackButtonAction(_:)), for: .touchUpInside)
        self.backView = customBackView
        return customBackView
    }
    
    /// 返回按钮事件。
    @objc private func customBackButtonAction(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension NavigationBarCustomizable where Self: UIViewController {
    
    /// 在 OMKit 环境中，实现 NavigationBarCustomizable 协议默认创建类型为 CustomNavigationBar 的导航条。
    public static var navigationBarClass: XZKit.NavigationBar.Type {
        return CustomNavigationBar.self
    }
    
    /// OMKit 自定义导航条。大部分情况下，只需要使用 navigationBar 属性即可。
    public var customNavigationBar: CustomNavigationBar {
        guard let customNavigationBar = self.navigationBar as? CustomNavigationBar else {
            fatalError("当前控制器的导航条类型不为 CustomNavigationBar 请检查！")
        }
        return customNavigationBar
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


