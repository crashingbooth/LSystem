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
    var nodeViews = [ViewForNode]()
    var knobs = [Knob]()
    var nodeTypes:Int {
       return listofNodeClasses.count
    }
    let listofNodeClasses: [Node.Type] = [TypeANode.self,TypeBNode.self, TypeCNode.self]
    let listofColors = [UIColor.blueColor(), UIColor.purpleColor(),UIColor.redColor()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assignNodeClasses()
        makeInitialNode()
        makeKnobs()
        arrayOfNode[0].radius
        for _ in 0..<9 {
            regenerate()
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(_:)))
        view.addGestureRecognizer(pan)
    }
    
     func makeInitialNode() {
        let rootLocation = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        rootNode = TypeBNode(segmentLength: 100 , parent: nil, rootLocation: rootLocation)
        if let rootNode = rootNode {
            arrayOfNode.append(rootNode)
        }
        
        
    }
    
    func regenerate() {
        var newArrayOfNodes = [Node]()
        
        for (i,_) in arrayOfNode.enumerate() {
            for newNode in arrayOfNode[i].spawn() {
                newArrayOfNodes.append(newNode)
            }
        }
        arrayOfNode = newArrayOfNodes
        
    }
    
    func assignNodeClasses() {
        for i in 0..<nodeTypes {
            let nodeView = ViewForNode(frame: view.bounds)
            nodeViews.append(nodeView)
            nodeView.backgroundColor = UIColor.clearColor()
            view.addSubview(nodeView)
            nodeView.fillColor = listofColors[i].colorWithAlphaComponent(0.4)
            listofNodeClasses[i].view = nodeView
        }
    }
    
    func makeKnobs() {
        var width = view.bounds.width / CGFloat(2 * nodeTypes - 1 )
        var buffer:CGFloat = 0
        if width > 100 {
            width = 100
            buffer = (view.bounds.width - CGFloat(100 * (2 * nodeTypes - 1))) / 2
        }
        for i in 0..<(2 * nodeTypes - 1) {
            if i % 2 == 0 {
                print (width)
                let π = Float(M_PI)
                let rect = CGRect(x: buffer + CGFloat(i) * width, y: view.bounds.height - (width + 20), width: width, height: width)
                let knob = Knob(frame: rect)
                
                knob.continuous = true
                knob.minimumValue = -2 * π
                knob.pointerLength = 10.0
                knob.maximumValue = 0
                knob.lineWidth = 5.0
                knob.tintColor = listofColors[i/2].colorWithAlphaComponent(0.4)
                knob.addTarget(self, action: #selector(ViewController.knobPositionChanged(_:)), forControlEvents: .ValueChanged)
                
                knobs.append(knob)
                view.addSubview(knob)
            }
            
        }
        view.setNeedsDisplay()
    }
    
    func knobPositionChanged(sender: Knob) {
        listofNodeClasses[knobs.indexOf(sender)!].angle = CGFloat(sender.value)
        for view in nodeViews {
            view.clearPaths()
        }
        
        
        rootNode?.recursiveReposition()
        for view in nodeViews {
            view.setNeedsDisplay()
        }
    
    }
    
    
    func handlePan(sender: UIPanGestureRecognizer) {
        print ("tap")
        let position :CGPoint =  sender.translationInView(view)
        TypeANode.angle = position.x / view.bounds.width * CGFloat(M_PI)
        TypeBNode.angle = position.y / view.bounds.width * CGFloat(M_PI)
        print(TypeANode.angle)
        for view in nodeViews {
            view.clearPaths()
        }
        

        rootNode?.recursiveReposition()
        for view in nodeViews {
            view.setNeedsDisplay()
        }
    }
    



    

}

