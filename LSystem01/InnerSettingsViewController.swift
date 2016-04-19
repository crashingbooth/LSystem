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
    var currentExtensions: [NodeType]!
    var availableNodes: [NodeType]!
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
        rootNodeView.nodeExtensions = currentExtensions
        
       
        view.addSubview(rootNodeView)
    }
    
    override func viewDidLayoutSubviews() {
        positionViews()
    }
    
    func positionViews() {
        print("positionViews")
        let navOffset =  (navigationController?.navigationBar.frame.height ?? 0) + 5
        let height = view.bounds.height - navOffset
        let width = view.bounds.width
        
        if view.bounds.width > view.bounds.height {
            // landscape
            rootNodeView.frame = CGRect(x: 0, y: navOffset, width: height, height: height)
            
            
        } else {
            // portrait
            rootNodeView.frame = CGRect(x: 0, y: navOffset, width: width, height: width)
        }
        
        rootNodeView.getSizes()
        rootNodeView.setUpExtensions()
        view.setNeedsDisplay()
    }
    
    

}
