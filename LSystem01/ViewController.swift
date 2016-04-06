//
//  ViewController.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/4/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var arrayOfNode = [Node]()

    var maxAngle = CGFloat(M_PI)
    var minAng = CGFloat(0)
    var rootNode: Node?
    var typeAView: ViewForNode!
    var typeBView: ViewForNode!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
        typeAView = ViewForNode(frame: view.bounds)
        typeBView = ViewForNode(frame: view.bounds)
        view.addSubview(typeAView)
        view.addSubview(typeBView)
        typeAView.fillColor = UIColor.blueColor()
        typeAView.backgroundColor = UIColor.clearColor()
        typeBView.backgroundColor = UIColor.clearColor()
        typeBView.fillColor = UIColor.purpleColor()
        TypeANode.view = typeAView
        TypeBNode.view = typeBView
      
        makeInitialNode()
        arrayOfNode[0].radius
        for i in 0..<7 {
            regenerate()
            
        }
//        let rotation = UIRotationGestureRecognizer(target: self, action: Selector("handleRot:"))
//        view.addGestureRecognizer(rotation)
//        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
//       
//        view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        
        view.addGestureRecognizer(pan)
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeInitialNode() {
        let rootLocation = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        rootNode = TypeANode(parent: nil, rootLocation: rootLocation)
        if let rootNode = rootNode {

        arrayOfNode.append(rootNode)
        }
        
        
    }
    
    func regenerate() {
        // erase old paths F
        var newArrayOfNodes = [Node]()
        for terminalNode in arrayOfNode {
            for newNode in terminalNode.spawn() {
                newArrayOfNodes.append(newNode)
               
            }
        }
        arrayOfNode = newArrayOfNodes
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        print ("tap")
        let position :CGPoint =  sender.locationInView(view)
        TypeANode.angle = position.x / view.bounds.width * CGFloat(M_PI)
        print(TypeANode.angle)
        rootNode?.recursiveReposition()
        typeAView.setNeedsDisplay()
        typeBView.setNeedsDisplay()
        view.setNeedsDisplay()
    }
    
    
    func handlePan(sender: UIPanGestureRecognizer) {
        print ("tap")
        let position :CGPoint =  sender.translationInView(view)
        TypeANode.angle = position.x / view.bounds.width * CGFloat(M_PI)
        print(TypeANode.angle)
        rootNode?.recursiveReposition()
        typeAView.setNeedsDisplay()
        typeBView.setNeedsDisplay()
        view.setNeedsDisplay()
    }
    

    func handleRot(sender: UIRotationGestureRecognizer) {
        print ("tap")
        let position :CGPoint =  sender.locationInView(view)
        TypeANode.angle = sender.rotation
        print(TypeANode.angle)
        rootNode?.recursiveReposition()
        typeAView.setNeedsDisplay()
        typeBView.setNeedsDisplay()
        view.setNeedsDisplay()
    }

    

}

