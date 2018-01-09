//
//  CustomNavigationBar.swift
//  TT
//
//  Created by Onemena on 2017/4/6.
//  Copyright © 2017年 OneMena. All rights reserved.
//

import UIKit
import XZKit


class CustomNavigationBarBackView: UIView {
    
    let backButton: UIButton = UIButton.init(type: .system)
    let closeButton: UIButton = UIButton.init(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(backButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        let views: [String: Any] = ["backButton": backButton, "closeButton": closeButton]
        
        let lcs1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[backButton]-(>=8)-[closeButton]-|", options: [.directionLeadingToTrailing, .alignAllCenterY], metrics: nil, views: views)
        let lcs2 = NSLayoutConstraint.init(item: backButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        addConstraints(lcs1)
        addConstraint(lcs2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size1 = backButton.sizeThatFits(size)
        let size2 = closeButton.sizeThatFits(size)
        
        return CGSize.init(width: size1.width + size2.width + 24, height: max(size1.height, size2.height))
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.init(width: 1000, height: 1000))
    }
    
}


open class CustomNavigationBar: XZKit.NavigationBar {
    
    private let _backView: CustomNavigationBarBackView = CustomNavigationBarBackView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    
    public required init(frame: CGRect) {
        super.init(frame: frame)
        super.backView = _backView;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// backView 不再可以重新赋值
    open override var backView: UIView? {
        get {
            return super.backView
        }
        set {
            fatalError("CustomNavigationBar's backView can not be reset.")
        }
    }
    
    override open var backButton: UIButton? {
        return _backView.backButton
    }
    
    open var closeButton: UIButton {
        return _backView.closeButton
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension NavigationBarCustomizable where Self: UIViewController {
    
    public static var navigationBarClass: XZKit.NavigationBar.Type {
        return CustomNavigationBar.self
    }
    
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
