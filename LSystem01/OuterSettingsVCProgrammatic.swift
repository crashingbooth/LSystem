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
    var activeSlider = UISlider()
    var starterSlider = UISlider()
    let numNodes: Float = 5
    var nodeTypeInFocus: NodeType?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        positionViews()
        validateAllNodes()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        for view in nodeExtensionViews {
            view.setNeedsDisplay() // need to redisplay when returning from inner settings
        }
    }
    
    func createViews() {
        for i in 0..<5 {
            let newView = NodeExtensionView(frame: view.frame)
            view.addSubview(newView)
            newView.nodeType = NodeType(rawValue: i)!
            print("in createViews: \(newView.nodeType)")
            nodeExtensionViews.append(newView)
            
           
            let tap = UITapGestureRecognizer(target: self, action: #selector(viewWasTouched(_:)))
            newView.addGestureRecognizer(tap)
        }
        
        
        view.addSubview(activeSlider)
        activeSlider.minimumValue = 1
        activeSlider.maximumValue = 5
        activeSlider.value = Float(Settings.sharedInstance.numOfActiveNodes)
        activeSlider.addTarget(self, action: #selector(activeSliderChanged(_:)), forControlEvents: .ValueChanged)
        
        view.addSubview(starterSlider)
        starterSlider.minimumValue = 0
        starterSlider.maximumValue = 4
        starterSlider.value = Float(Settings.sharedInstance.startingNode.rawValue)
        starterSlider.addTarget(self, action: #selector(starterSliderChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func positionViews() {
        let padding: CGFloat = 5
        let sliderSize: CGFloat = 40
        let navOffset = navigationController?.navigationBar.frame.height ?? 0
        
        activeSlider.transform = CGAffineTransformIdentity
        let thumbWidth:CGFloat = 30
        starterSlider.minimumTrackTintColor = UIColor.lightGrayColor()
        starterSlider.maximumTrackTintColor = UIColor.lightGrayColor()
        if view.bounds.width > view.bounds.height {
           // landscape
            let size = (view.bounds.width - padding * 6) / 5
            for i in 0..<5 {
                let rect = CGRect(x: padding * CGFloat(i + 1) + size * CGFloat(i), y: sliderSize + navOffset + padding, width: size, height: size)
                nodeExtensionViews[i].frame = rect
            }
            
            activeSlider.transform = CGAffineTransformIdentity
            let activeSliderRect = CGRect(x: (size / 2) - padding * 2, y: navOffset + 20, width: (size * 4) + padding * 10, height: sliderSize)
            activeSlider.frame = activeSliderRect
            
            
            
           
            let starterSliderLength = (padding + size) * CGFloat(Settings.sharedInstance.numOfActiveNodes - 1) + thumbWidth
            starterSlider.transform = CGAffineTransformIdentity
            let starterSliderRect = CGRect(x: (size / 2) + padding - (thumbWidth / 2), y: navOffset + 40 + size, width: starterSliderLength, height: sliderSize)
            starterSlider.frame = starterSliderRect
            
      
            view.setNeedsDisplay()

        } else {
            // portrait
            
            
            let navOffset = navOffset + 5
            let size = (view.bounds.height - padding * 6 - navOffset) / 5
            for i in 0..<5 {
                let rect = CGRect(x: sliderSize, y: navOffset + padding * CGFloat(i + 1) + size  * CGFloat(i), width: size, height: size)
                nodeExtensionViews[i].frame = rect
            }
            activeSlider.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            let activeSliderRect = CGRect(x: padding, y: navOffset + (size / 2), width: sliderSize, height: (size * 4) + padding * 8)
            activeSlider.frame = activeSliderRect
            
            
            let starterSliderLength = (padding + size) * CGFloat(Settings.sharedInstance.numOfActiveNodes - 1) + thumbWidth
            starterSlider.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            let starterSliderRect = CGRect(x: padding + size + 20, y: navOffset + (size / 2), width: sliderSize, height: starterSliderLength)
            
            starterSlider.frame = starterSliderRect
           
            
        }
        
        for nodeView in nodeExtensionViews {
            nodeView.getSizes()
            nodeView.setUpExtensions()
        }
    }
    
    override func viewWillLayoutSubviews() {
        positionViews()
    }
    
    func activeSliderChanged(sender: UISlider) {
        
        let roundedValue = round(sender.value)
        Settings.sharedInstance.numOfActiveNodes = Int(roundedValue)
        

        sender.value = Float(roundedValue)
        validateAllNodes()
        
    }
    
    func starterSliderChanged(sender: UISlider) {
        
        let roundedValue = round(sender.value)
        Settings.sharedInstance.startingNode = NodeType(rawValue: Int(roundedValue))!
        
        
        sender.value = Float(roundedValue)
        validateAllNodes()
        
    }
    
    func viewWasTouched(sender: UITapGestureRecognizer) {
        
        let source = sender.view as? NodeExtensionView
        if let source = source {
            nodeTypeInFocus = source.nodeType
            print("in focus \(nodeTypeInFocus)")
            if nodeTypeInFocus?.rawValue < Settings.sharedInstance.numOfActiveNodes {
                performSegueWithIdentifier("toInnerSettings", sender: self)
            } else {
                nodeTypeInFocus = nil 
            }
        } else {
            nodeTypeInFocus = nil
            // prepareForSegue will also check nodeTypeInFocus
        }
    
        
    }
    
    func validateAllNodes() {
        for (i,nev) in nodeExtensionViews.enumerate() {
            
            nodeExtensionViews[i].validate()
            starterSlider.maximumValue = Float(Settings.sharedInstance.numOfActiveNodes - 1)
            nev.setNeedsDisplay()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            switch(id) {
            case "toInnerSettings":
                if let nodeTypeInFocus = nodeTypeInFocus {
                    let isvc = segue.destinationViewController as! InnerSettingsViewController
                    isvc.nodeType = nodeTypeInFocus
                    print(isvc.nodeType)
                    
       
//                    isvc.createViews()
                    
                }
            default:
                break
            }
        }
    }



}


