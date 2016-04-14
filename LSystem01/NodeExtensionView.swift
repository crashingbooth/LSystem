//
//  NodeExtensionView.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/14/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit

@IBDesignable class NodeExtensionView: UIView {
    var nodeColor: UIColor = Constants.nodeColors[0].colorWithAlphaComponent(0.5)
    var nodeExtensions: [Node.Type] = [TypeANode.self]
    

    override func drawRect(rect: CGRect) {
        let nodeCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 4)
        let barWidth = bounds.width / 16
        let barHeight = bounds.height / 4 * 3
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor)
        CGContextAddArc(context, nodeCenter.x, nodeCenter.y, bounds.width / 15, 0, 2 * CGFloat(M_PI), 1)
        CGContextFillPath(context)
        
        let edgeRect = CGRect(x: nodeCenter.x - barWidth/2, y: nodeCenter.y, width: barWidth, height: bounds.height - barHeight)
        let edgePath = UIBezierPath(roundedRect: edgeRect, byRoundingCorners: .AllCorners, cornerRadii: CGSize(width: barWidth/2, height: barWidth/2))
        nodeColor.setFill()
        edgePath.fill()
        
        
    }
    
    
 

}
