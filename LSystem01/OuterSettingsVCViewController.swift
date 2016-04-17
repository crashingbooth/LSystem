//
//  OuterSettingsVCViewController.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit

class OuterSettingsVCViewController: UIViewController {

    @IBOutlet weak var nodeView0: NodeExtensionView!
    @IBOutlet weak var nodeView1: NodeExtensionView!
    @IBOutlet weak var nodeView2: NodeExtensionView!
    @IBOutlet weak var nodeView3: NodeExtensionView!
    @IBOutlet weak var nodeView4: NodeExtensionView!
    var nodeViews: [NodeExtensionView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        nodeViews = [nodeView0,nodeView1,nodeView2,nodeView3,nodeView4]
        for nodeView in nodeViews {
            nodeView.getSizes()
            nodeView.setUpExtensions()
        }
        
        
        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Unspecified) {
           
        } else {
             print(" not regular horizontak")
        }
        print(self.view.traitCollection.horizontalSizeClass)
        
        view.userInteractionEnabled = true

    }
    
    func tapped(sender: UITapGestureRecognizer) {
        print(" VC toucjed")
        
    }
    
    override func overrideTraitCollectionForChildViewController(childViewController: UIViewController) -> UITraitCollection {
        print("called")
        if view.bounds.width > view.bounds.height {
            return UITraitCollection(verticalSizeClass: .Compact)
        } else {
            return UITraitCollection(verticalSizeClass: .Regular)
        }
    }
    
    

   


}
