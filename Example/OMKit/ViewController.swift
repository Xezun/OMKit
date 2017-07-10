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



class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = MediaPlayerPlaybackControlsView(frame: .init(x: 10, y: 100, width: UIScreen.main.bounds.width - 20, height: 200))
        self.view.addSubview(view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

