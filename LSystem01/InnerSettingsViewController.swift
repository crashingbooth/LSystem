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
    var instructionsLabel = UILabel()


    override func viewDidLoad() {
        super.viewDidLoad()
        print("VDL called")
        view.backgroundColor = UIColor.whiteColor()
        
        createViews()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InnerSettingsViewController.cleanUpViews), name: Constants.cleanUpNeeded, object: nil)
        // Do any additional setup after loading the view.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func cleanUpViews() {
        positionViews()
        print("reachable: \(Settings.sharedInstance.findReachableNodes)")
    }
    
    func createViews() {
        rootNodeView = NodeExtensionSelector(frame: view.frame)
        rootNodeView.nodeType = nodeType
        rootNodeView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        
       
        childSelector = ChildSelector(frame: view.frame)
        childSelector.parentType = nodeType
        childSelector.delegate = rootNodeView
        childSelector.getAndMakeChildViews()
        
        instructionsLabel.text = "Drag child nodes to and from parent nodes"
        instructionsLabel.numberOfLines = 2
        instructionsLabel.textAlignment = NSTextAlignment.Center
        instructionsLabel.font = Constants.smallFont
        
        view.addSubview(instructionsLabel)
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
        
        instructionsLabel.frame = CGRect(x: 0, y: view.bounds.height - 20, width: view.bounds.width, height: 20)
        rootNodeView.getSizes()
        rootNodeView.setUpExtensions()
        childSelector.positionViews()

        
        view.setNeedsDisplay()
    }
    
    

}
