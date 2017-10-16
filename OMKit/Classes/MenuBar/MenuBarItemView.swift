//
//  MenuBarItemView.swift
//  OMKit
//
//  Created by mlibai on 2017/5/16.
//  Copyright © 2017年 mlibai. All rights reserved.
//

import Foundation
import XZKit

internal protocol MenuBarItemViewDelegate: class {
    func menuBarItemViewWasTapped(_ menuBarItemView: MenuBarItemView)
}

open class MenuBarItemView: XZKit.TitledImageView {
    open var isSelected: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tap)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: MenuBarItemViewDelegate?
    
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        delegate?.menuBarItemViewWasTapped(self)
    }
    
}










