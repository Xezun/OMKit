//
//  FirstViewController.swift
//  OMKit_Example
//
//  Created by mlibai on 2017/12/21.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import XZKit
import OMKit



class FirstViewController: UIViewController, NavigationBarCustomizable {

    @IBOutlet weak var testView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testView.backgroundColor       = UIColor.clear
        self.testView.layer.shadowPath      = UIBezierPath(roundedRect: self.testView.bounds.insetBy(dx: -3, dy: 0), cornerRadius: 0).cgPath
        self.testView.layer.shadowOffset    = CGSize.zero
        self.testView.layer.shadowOpacity   = 0.3
        self.testView.layer.shadowRadius    = 3.0
        self.testView.layer.borderWidth     = 1.0;
        self.testView.layer.borderColor     = UIColor.red.cgColor
        
        self.customNavigationBar.barTintColor = UIColor.white
        self.customNavigationBar.backButton?.backgroundColor = UIColor.red
        self.customNavigationBar.closeButton?.backgroundColor = UIColor.blue

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
