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
    let numNodes: Float = 5
    var activeNodes = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
       positionViews()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }
    
    func createViews() {
        for i in 0..<5 {
            nodeExtensionViews.append(NodeExtensionView(frame: view.frame))
        }
        
        for nev in nodeExtensionViews {
            view.addSubview(nev)
        }
        view.addSubview(slider)
        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.addTarget(self, action: #selector(sliderChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func positionViews() {
        let padding: CGFloat = 5
        let sliderSize: CGFloat = 40
        let navOffset = navigationController?.navigationBar.frame.height ?? 0
        
        if view.bounds.width > view.bounds.height {
           // landscape
            let size = (view.bounds.width - padding * 6) / 5
            for i in 0..<5 {
                let rect = CGRect(x: padding * CGFloat(i + 1) + size * CGFloat(i), y: sliderSize + navOffset + padding, width: size, height: size)
                nodeExtensionViews[i].frame = rect
            }
            
            slider.transform = CGAffineTransformIdentity
            let sliderRect = CGRect(x: (size / 2) - padding * 2, y: navOffset + 20, width: (size * 4) + padding * 10, height: sliderSize)
            slider.frame = sliderRect
            
      
            view.setNeedsDisplay()

        } else {
            // portrait
            
            
            let navOffset = navOffset + 5
            let size = (view.bounds.height - padding * 6 - navOffset) / 5
            for i in 0..<5 {
                let rect = CGRect(x: sliderSize, y: navOffset + padding * CGFloat(i + 1) + size  * CGFloat(i), width: size, height: size)
                nodeExtensionViews[i].frame = rect
            }
            slider.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            let sliderRect = CGRect(x: padding, y: navOffset + (size / 2), width: sliderSize, height: (size * 4) + padding * 8)
            slider.frame = sliderRect
           
            
        }
//        slider.value = Float(activeNodes - 1)
        
        for nodeView in nodeExtensionViews {
            nodeView.getSizes()
            nodeView.setUpExtensions()
        }
    }
    
    override func viewWillLayoutSubviews() {
        positionViews()
    }
    
    func sliderChanged(sender: UISlider) {
        
        let roundedValue = round(sender.value)
        activeNodes = Int(roundedValue)
        
        print(activeNodes)
        sender.value = Float(roundedValue)
        
    }



}


