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
    var nodeTypes:Int {
       return listofNodeClasses.count
    }
    let listofNodeClasses: [Node.Type] = [TypeANode.self,TypeBNode.self, TypeCNode.self]
    let listofColors = [UIColor.blueColor(), UIColor.purpleColor(),UIColor.redColor()]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        makeViews()
        
        
        makeInitialNode()
        arrayOfNode[0].radius
        for _ in 0..<11 {
            regenerate()
            
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(_:)))
        
        view.addGestureRecognizer(pan)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeInitialNode() {
        let rootLocation = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        rootNode = TypeBNode(segmentLength: 100 , parent: nil, rootLocation: rootLocation)
        if let rootNode = rootNode {

        arrayOfNode.append(rootNode)
        }
        
        
    }
    
    func makeViews() {
        for i in 0..<nodeTypes {
            let nodeView = ViewForNode(frame: view.bounds)
            nodeViews.append(nodeView)
            nodeView.backgroundColor = UIColor.clearColor()
            view.addSubview(nodeView)
            nodeView.fillColor = listofColors[i].colorWithAlphaComponent(0.4)
            listofNodeClasses[i].view = nodeView
        }
    }
    
    func regenerate() {
        // erase old paths F
        var newArrayOfNodes = [Node]()
        
        for (i,_) in arrayOfNode.enumerate() {
            for newNode in arrayOfNode[i].spawn() {
                newArrayOfNodes.append(newNode)
            }
        }

        arrayOfNode = newArrayOfNodes
        
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
//        view.setNeedsDisplay()
    }
    



    

}

