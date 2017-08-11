//
//  ViewController.swift
//  OMKit
//
//  Created by mlibai on 05/20/2017.
//  Copyright (c) 2017 mlibai. All rights reserved.
//

import UIKit
import XZKit
import OMKit



class ViewController: UIViewController, MenuBarDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bounds = view.bounds
        
        let menuBar = MenuBar(frame: CGRect.init(x: 0, y: 100, width: bounds.width, height: 44))
        menuBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        view.addSubview(menuBar)
        
        
        menuBar.delegate = self
        
        menuBar.selectedIndex = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in menuBar: MenuBar) -> Int {
        return 15
    }
    
    func menuBar(_ menuBar: MenuBar, widthForItemAt index: Int) -> CGFloat {
        return 70
    }
    
    func menuBar(_ menuBar: MenuBar, didSelectItemAt index: Int) {
        
    }
    
    func menuBar(_ menuBar: MenuBar, viewForItemAt index: Int, reusingView: MenuBarItemView?) -> MenuBarItemView {
        var view: MenuBarItemView! = reusingView
        
        if view == nil {
            view = MenuBarItemView(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
            view.backgroundColor = UIColor(rgb: arc4random())
        }
        
        view.titleLabel.text = "\(index)"
        
        return view
    }

}

