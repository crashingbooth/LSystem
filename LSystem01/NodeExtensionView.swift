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
  
    var nodeColor: UIColor = Constants.nodeColors[0].colorWithAlphaComponent(0.5)
    var nodeExtensions: [Node.Type] = [TypeANode.self, TypeBNode.self, TypeCNode.self, TypeCNode.self, TypeCNode.self]
    let anglesDict: [Int:[CGFloat]] = [
        1:[-PI / 2],
        2:[-PI / 3, -2 * PI / 3],
        3:[-PI / 4, -PI / 2, -3 * PI / 4],
        4:[-PI / 5, -2 * PI / 5, -3 * PI / 5, -4 * PI / 5],
        5:[-PI / 6, -2 * PI / 6, -3 * PI / 6, -4 * PI / 6, -5 * PI / 6]
    ]
    
    

    override func drawRect(rect: CGRect) {
        let barWidth = bounds.width / 16
        let barHeight = (bounds.height / 8) * 3
        let topNodeCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 8)
        let midNodeCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let addNodeCenter = CGPoint(x: bounds.width / 2 + barHeight, y: bounds.height / 2 )
        let nodeRadius =  bounds.width / 15
        
        
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
        
        for exten in 0..<nodeExtensions.count {
            // make paths, rotate, fill
            let circleLayer = CAShapeLayer()
            circleLayer.frame = bounds
            circleLayer.path = UIBezierPath(arcCenter: addNodeCenter, radius: nodeRadius, startAngle: 0, endAngle: 2 * PI, clockwise: true).CGPath
            let edgeLayer = CAShapeLayer()
            edgeLayer.frame = bounds
            let edgeRect = CGRect(x: midNodeCenter.x, y: (bounds.height / 2) - (barWidth / 2), width: barHeight, height:  barWidth)
//            edgeLayer.path = UIBezierPath(roundedRect: edgeRect, byRoundingCorners: .AllCorners , cornerRadii: CGSize(width: barWidth / 2, height: barWidth / 2)).CGPath
//            edgeLayer.fillColor = Constants.nodeColors[1].CGColor
            
            let edgePath = UIBezierPath(roundedRect: edgeRect, cornerRadius: barWidth / 2)
            edgeLayer.path = edgePath.CGPath
            edgeLayer.fillColor = Constants.nodeColors[exten].colorWithAlphaComponent(0.5).CGColor
         
            
            
            circleLayer.fillColor = UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor
            self.layer.addSublayer(circleLayer)
            self.layer.addSublayer(edgeLayer)
            if let angles = anglesDict[nodeExtensions.count] {
                let myAngle = angles[exten]
                circleLayer.transform = CATransform3DMakeRotation(myAngle * -1, 0.0, 0.0, 1.0)
                edgeLayer.transform = CATransform3DMakeRotation(myAngle * -1, 0.0, 0.0, 1.0)
            }
        }
        
        
    }
    
    
 

}
