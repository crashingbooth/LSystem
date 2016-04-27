//
//  NodeExtensionView.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/14/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit

let PI = CGFloat(M_PI)
@IBDesignable class NodeExtensionView: UIView {
    var barWidth: CGFloat = 0
    var barHeight: CGFloat = 0
    var topNodeCenter = CGPoint.zero
    var midNodeCenter = CGPoint.zero
    var addNodeCenter = CGPoint.zero
    var nodeRadius: CGFloat = 0
    var isActive: Bool {
        return Settings.sharedInstance.numOfActiveNodes > nodeType.rawValue
    }
    var nodeType: NodeType = .typeA
    var isReachable: Bool {
        return Settings.sharedInstance.findReachableNodes.contains(nodeType)
    }
    
    var childNodeViews = [ChildNodeView]()
    let label = UILabel()
    
    let anglesDict: [Int:[CGFloat]] = [
        1: [0],
        2: [-PI / 6, PI / 6],
        3: [-PI / 4, 0, PI / 4],
        4: [3 * -PI / 10, -PI / 10, PI / 10, 3 * PI / 10 ],
        5: [-PI / 3, -PI / 6, 0, PI / 6, PI / 3 ]
    ]
    
    func getSizes() {
        if isActive {
             backgroundColor = UIColor.cyanColor().colorWithAlphaComponent(0.2)
        } else {
            backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        }
        barWidth = bounds.width / 18
        barHeight = (bounds.height / 16) * 5
        topNodeCenter = CGPoint(x: bounds.width / 2, y: (bounds.height / 16) * 3)
        midNodeCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        addNodeCenter = CGPoint(x: bounds.width / 2 + barHeight, y: bounds.height / 2 )
        nodeRadius =  bounds.width / 15
        
        setUpLabel()

    }
    
    func setUpLabel() {
        
        label.removeFromSuperview()
        addSubview(label)
        
        let rect = CGRect(x: 0, y: bounds.height * 5 / 6, width: bounds.width, height: bounds.height / 6)
        label.frame = rect
        label.text = isReachable ?  "" :  "Node is Unreachable"
        label.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        label.font = Constants.font
        label.textAlignment = NSTextAlignment.Center
        label.adjustsFontSizeToFitWidth = true
        
    }
    
    
    func setUpExtensions() {
        for childNode in childNodeViews {
            childNode.removeFromSuperview()
        }
        childNodeViews = [ChildNodeView]()
        if let nodeExtensions = Settings.sharedInstance.nodeSubstitutions[nodeType] {
            for (i, ext) in nodeExtensions.enumerate() {
                let child = ChildNodeView(frame: bounds, barHeight: barHeight, barWidth: barWidth, nodeRadius: nodeRadius, nodeType: ext, parentNodeType: nodeType, isMovable: true)
                addSubview(child)
                childNodeViews.append(child)
                if let angles = anglesDict[nodeExtensions.count] {
                    let myAngle = angles[i]
                    child.transform = CGAffineTransformMakeRotation(myAngle)
                }

                userInteractionEnabled = true
            }
        }
    }
    
    
    
    
    override func drawRect(rect: CGRect) {
        print("nev drawRect for \(nodeType)")
        

        let topNodePath = UIBezierPath(arcCenter: topNodeCenter, radius: nodeRadius, startAngle: 0, endAngle: 2 * PI, clockwise: true)
        let midNodePath = UIBezierPath(arcCenter: midNodeCenter, radius: nodeRadius, startAngle: 0, endAngle: 2 * PI, clockwise: true)
        UIColor.blackColor().colorWithAlphaComponent(0.2).setFill()
        topNodePath.fill()
        midNodePath.fill()
        

        
        let edgeRect = CGRect(x: topNodeCenter.x - barWidth/2, y: topNodeCenter.y, width: barWidth, height:  barHeight)
        let edgePath = UIBezierPath(roundedRect: edgeRect, byRoundingCorners: .AllCorners, cornerRadii: CGSize(width: barWidth/2, height: barWidth/2))
        
        if isActive {
            Settings.colorDict[nodeType]!.setFill()
        } else {

            UIColor.blackColor().colorWithAlphaComponent(0.4).setFill()
        }
        edgePath.fill()
        
        
    }
    
    func validate() {
        
        if var nodeExtensions = Settings.sharedInstance.nodeSubstitutions[nodeType] {
            if !isActive {
                    backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
                nodeExtensions = Set<NodeType>()
            } else {
                let newNodes = nodeExtensions.filter({$0.rawValue < Settings.sharedInstance.numOfActiveNodes})
                nodeExtensions = Set(newNodes)
            }
             Settings.sharedInstance.nodeSubstitutions[nodeType] = nodeExtensions
            setUpExtensions()
        }
        
        
    }
    
    

}


class NodeExtensionSelector: NodeExtensionView, ChildSelectorDelegate{
    var potentialChildren = [ChildNodeView]()

    var potentialNodesTypes: [NodeType] {
        let activeNodes = Set(NodeType.allNodeTypes[0..<Settings.sharedInstance.numOfActiveNodes])
        let currentNodes = Settings.sharedInstance.nodeSubstitutions[nodeType]!
        let pot = activeNodes.subtract(currentNodes)
        return Array(pot)
    }

    
    //MARK:  - Delegate Methods
    func getNodeRadius() -> CGFloat {
        return nodeRadius
    }
    
    func getViewLength() -> CGFloat {
        return nodeRadius * 15
    }
    
    func getBarHeight() -> CGFloat {
        return barHeight
    }
    
    func getBarWidth() -> CGFloat {
        return barWidth
    }
    
    func getAvailableNodesData() -> [NodeType] {

        return potentialNodesTypes
    }
    
    
   
}



class ChildNodeView: UIView {
    var color: UIColor = UIColor.cyanColor()
    var nodeType: NodeType = .typeA
    var parentNodeType: NodeType = .typeA
    var barHeight: CGFloat = 0
    var barWidth: CGFloat = 0
    var nodeRadius: CGFloat = 0
    var isConnected = true  // i.e. is attached to a NodeExtensionSelector
    var isSelected = false
    var isMovable = false
    var priorPoint = CGPointZero
    var nodePath = UIBezierPath()
    var edgePath = UIBezierPath()
  
    
   
    init(frame: CGRect, barHeight: CGFloat, barWidth: CGFloat, nodeRadius: CGFloat, nodeType: NodeType, parentNodeType: NodeType, isMovable: Bool) {
         let rect = CGRect(x: (frame.width / 2) - nodeRadius, y: 0, width:  nodeRadius * 2, height: frame.height )
        
        super.init(frame: rect)
        self.barHeight = barHeight
        self.barWidth = barWidth
        self.nodeRadius = nodeRadius
        self.nodeType = nodeType
        self.priorPoint = center
        self.parentNodeType = parentNodeType
        self.isMovable = isMovable
        backgroundColor = UIColor.clearColor()
        
       
        if isMovable {
            let touch = UILongPressGestureRecognizer(target: self, action: #selector(tapped(_:)))
            touch.minimumPressDuration = 0.1
            addGestureRecognizer(touch)
            userInteractionEnabled = true
        }
        
    }
    
    func tapped(sender: UILongPressGestureRecognizer) {
        let point = sender.locationInView(superview?.superview)
        switch (sender.state) {
        case .Began:
        if edgePath.containsPoint(sender.locationInView(self)) || nodePath.containsPoint(sender.locationInView(self)) {
                print("touch inside")
            isSelected = true
            
        }
            
        case .Changed:
            if isSelected {
                var cent = center
             
                cent.x += point.x - priorPoint.x
                cent.y += point.y - priorPoint.y
                center = cent
                
            }
        case .Ended:
            isSelected = false
            if let parentFrame = superview?.frame {
        
                if parentFrame.contains(point) {
                    print("still in same view")
                    
                } else {
                    print("Changed for node \(nodeType) in parent \(parentNodeType)")
                   print(Settings.sharedInstance.nodeSubstitutions[parentNodeType]!)
                    if isConnected {
                        Settings.sharedInstance.nodeSubstitutions[parentNodeType]!.remove(nodeType)
                        
                    } else {
                        Settings.sharedInstance.nodeSubstitutions[parentNodeType]!.insert(nodeType)
                    }
                }
                print(Settings.sharedInstance.nodeSubstitutions[parentNodeType]!)
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.cleanUpNeeded, object: nil)
            }
            print("ended")
        default:
            break
        }
        priorPoint = point
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        fatalError("should always be called with custom init")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // end node
        constructPath()
        UIColor.blackColor().colorWithAlphaComponent(0.2).setFill()
        nodePath.fill()
        

        
        // edge
        
        let edgeRect = CGRect(x: (bounds.width / 2) - (barWidth / 2), y: bounds.height / 2, width: barWidth, height: barHeight)
        edgePath = UIBezierPath(roundedRect: edgeRect, cornerRadius: barWidth / 2)
        Settings.colorDict[nodeType]!.setFill()
        edgePath.fill()
    }
    
    func constructPath() {
        let nodeCenter = CGPoint(x: (bounds.width / 2), y: (bounds.height / 2) + barHeight)
        nodePath = UIBezierPath(arcCenter: nodeCenter, radius: nodeRadius, startAngle: 0, endAngle: 2 * PI, clockwise: true)
    }
    
    func resetPosition(frame: CGRect) {
        self.frame = frame
        priorPoint = center
    }
    
    
}

