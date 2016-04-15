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
  
    var nodeColor: UIColor = Constants.nodeColors[0].colorWithAlphaComponent(0.5)
    var nodeExtensions: [Node.Type] = [TypeANode.self, TypeBNode.self, TypeCNode.self, TypeCNode.self, TypeCNode.self]
    var childNodeViews = [ChildNodeView]()
    let anglesDict: [Int:[CGFloat]] = [
        1:[-PI / 2],
        2:[-PI / 3, -2 * PI / 3],
        3:[-PI / 4, -PI / 2, -3 * PI / 4],
        4:[-PI / 5, -2 * PI / 5, -3 * PI / 5, -4 * PI / 5],
        5:[-PI / 6, -2 * PI / 6, -3 * PI / 6, -4 * PI / 6, -5 * PI / 6]
    ]
    
    func getSizes() {
        barWidth = bounds.width / 16
        barHeight = (bounds.height / 8) * 3
        topNodeCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 8)
        midNodeCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        addNodeCenter = CGPoint(x: bounds.width / 2 + barHeight, y: bounds.height / 2 )
        nodeRadius =  bounds.width / 15
    }
    
    func setUpExtensions() {
        for (i, ext) in nodeExtensions.enumerate() {
            let child = ChildNodeView(frame: bounds, barHeight: barHeight, barWidth: barWidth, nodeRadius: nodeRadius, color: Constants.nodeColors[i].colorWithAlphaComponent(0.5))
            addSubview(child)
            childNodeViews.append(child)
            if let angles = anglesDict[nodeExtensions.count] {
                let myAngle = angles[i]
                child.transform = CGAffineTransformMakeRotation(myAngle * -1)
            }
        }
    }
    
    
    
    
    override func drawRect(rect: CGRect) {
       
        
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor)
        CGContextAddArc(context, topNodeCenter.x, topNodeCenter.y, nodeRadius, 0, 2 * CGFloat(M_PI), 1)
        CGContextFillPath(context)
        CGContextAddArc(context, midNodeCenter.x, midNodeCenter.y, nodeRadius, 0, 2 * CGFloat(M_PI), 1)
        CGContextFillPath(context)
        
        let edgeRect = CGRect(x: topNodeCenter.x - barWidth/2, y: topNodeCenter.y, width: barWidth, height:  barHeight)
        let edgePath = UIBezierPath(roundedRect: edgeRect, byRoundingCorners: .AllCorners, cornerRadii: CGSize(width: barWidth/2, height: barWidth/2))
        nodeColor.setFill()
        edgePath.fill()
        
        
    }

}

class ChildNodeView: UIView {
    var color: UIColor = UIColor.cyanColor()
    var barHeight: CGFloat = 0
    var barWidth: CGFloat = 0
    var nodeRadius: CGFloat = 0
    var isConnected = true
    var nodePath = UIBezierPath()
    
   
    init(frame: CGRect, barHeight: CGFloat, barWidth: CGFloat, nodeRadius: CGFloat, color: UIColor) {
        let rect = CGRect(x: 0, y: (frame.height / 2) - nodeRadius, width: frame.width, height: nodeRadius * 2 )
        
        super.init(frame: rect)
        self.barHeight = barHeight
        self.barWidth = barWidth
        self.nodeRadius = nodeRadius
        self.color = color
        backgroundColor = UIColor.clearColor()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // end node
        constructPath()
        UIColor.blackColor().colorWithAlphaComponent(0.2).setFill()
        nodePath.fill()
        
        
        // top node
        if !isConnected {
            let topNode = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: nodeRadius, startAngle: 0, endAngle: 2 * PI, clockwise: true)
            topNode.fill()
        }
        
        // edge
        let edgeRect = CGRect(x: bounds.width / 2, y: (bounds.height / 2) - (barWidth / 2), width: barHeight, height: barWidth)
        let edgePath = UIBezierPath(roundedRect: edgeRect, cornerRadius: barWidth / 2)
        color.setFill()
        edgePath.fill()
    }
    
    func constructPath() {
        let nodeCenter = CGPoint(x: (bounds.width / 2) + barHeight, y: bounds.height / 2)
        nodePath = UIBezierPath(arcCenter: nodeCenter, radius: nodeRadius, startAngle: 0, endAngle: 2 * PI, clockwise: true)
    }
    
    
}