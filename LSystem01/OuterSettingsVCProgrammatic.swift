//
//  OuterSettingsVCProgrammatic.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/17/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit

class OuterSettingsVCProgrammatic: UIViewController {
    var nodeExtensionViews = [NodeExtensionView]()
    var slider = UISlider()
    let numNodes = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
       positionViews()

        // Do any additional setup after loading the view.
    }
    
    func createViews() {
        for i in 0..<5 {
            nodeExtensionViews.append(NodeExtensionView(frame: view.frame))
        }
        
        for nev in nodeExtensionViews {
            view.addSubview(nev)
        }
    }
    
    func positionViews() {
        let padding: CGFloat = 5
        let sliderSize: CGFloat = 40
        if view.bounds.width > view.bounds.height {
           // landscape
            let sliderRect = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
            let size = (view.bounds.width - padding * 6) / 5
            for i in 0..<5 {
                let rect = CGRect(x: padding * CGFloat(i + 1) + size * CGFloat(i), y: sliderSize, width: size, height: size)
                nodeExtensionViews[i].frame = rect
            }
        } else {
            // portrait
            
            let size = (view.bounds.height - padding * 6) / 5
            for i in 0..<5 {
                let rect = CGRect(x: sliderSize, y: padding * CGFloat(i + 1) + size  * CGFloat(i), width: size, height: size)
                nodeExtensionViews[i].frame = rect
            }
            
        }
        
        
        for nodeView in nodeExtensionViews {
            nodeView.getSizes()
            nodeView.setUpExtensions()
        }
    }
    
    override func viewWillLayoutSubviews() {
        positionViews()
    }



}


