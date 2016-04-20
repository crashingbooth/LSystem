//
//  InnerSettingsViewController.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/17/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit

class InnerSettingsViewController: UIViewController {
    var rootNodeView : NodeExtensionView!
    var nodeType: NodeType!


    override func viewDidLoad() {
        super.viewDidLoad()
        print("VDL called")
        view.backgroundColor = UIColor.whiteColor()
        createViews()
        // Do any additional setup after loading the view.
    }
    
    func createViews() {
        print(" createViews called")
 
        
        rootNodeView = NodeExtensionView(frame: view.frame)
        rootNodeView.nodeType = nodeType
        rootNodeView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)

        view.addSubview(rootNodeView)
    }
    
    override func viewDidLayoutSubviews() {
        positionViews()
    }
    
    func positionViews() {
        print("positionViews")
        let navOffset =  (navigationController?.navigationBar.frame.height ?? 0) + 5
        var height = view.bounds.height - navOffset
        var width = view.bounds.width
        var padding: CGFloat = 0
        
        if view.bounds.width > view.bounds.height {
            // landscape 
            if height > width / 2 {
                padding = (height - width / 2) / 2
                height = width / 2
            }
            rootNodeView.frame = CGRect(x: padding, y: navOffset + padding, width: height, height: height)
            
            
        } else {
            // portrait
            if width > height / 2 {
                padding = (width - height / 2) / 2
                width = height / 2
            }
            
            rootNodeView.frame = CGRect(x: padding, y: navOffset + padding, width: width, height: width)
        }
        
        rootNodeView.getSizes()
        rootNodeView.setUpExtensions()
        view.setNeedsDisplay()
    }
    
    

}
