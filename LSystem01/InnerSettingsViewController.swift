//
//  InnerSettingsViewController.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/17/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit

class InnerSettingsViewController: UIViewController {
    var rootNodeView : NodeExtensionSelector!
    var childSelector: ChildSelector!
    var nodeType: NodeType!


    override func viewDidLoad() {
        super.viewDidLoad()
        print("VDL called")
        view.backgroundColor = UIColor.whiteColor()
        createViews()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InnerSettingsViewController.cleanUpViews), name: Constants.cleanUpNeeded, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func cleanUpViews() {
        positionViews()
//        childSelector.refresh()
    }
    
    func createViews() {
        rootNodeView = NodeExtensionSelector(frame: view.frame)
        rootNodeView.nodeType = nodeType
        rootNodeView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        
       
        childSelector = ChildSelector(frame: view.frame)
        childSelector.delegate = rootNodeView
        childSelector.getAndMakeChildViews()
        
        view.addSubview(childSelector)
        view.addSubview(rootNodeView)
    }
    
    override func viewDidLayoutSubviews() {
        positionViews()
    }
    
    func positionViews() {
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
            rootNodeView.frame = CGRect(x: 0, y: navOffset + padding, width: height, height: height)
            childSelector.frame = CGRect(x: view.bounds.width / 2, y: navOffset, width: view.bounds.width / 2, height: view.bounds.height - navOffset)
            
            
        } else {
            // portrait
            if width > height / 2 {
                padding = (width - height / 2) / 2
                width = height / 2
            }
            
            rootNodeView.frame = CGRect(x: padding, y: navOffset, width: width, height: width)
            childSelector.frame = CGRect(x: 0, y: navOffset + width, width: view.bounds.width, height: view.bounds.height - navOffset - width)
        }
        
       
    
        
        rootNodeView.getSizes()
        rootNodeView.setUpExtensions()
        childSelector.backgroundColor = UIColor.magentaColor().colorWithAlphaComponent(0.05)
        childSelector.positionViews()

        
        view.setNeedsDisplay()
    }
    
    

}
