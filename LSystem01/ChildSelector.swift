//
//  ChildSelector.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/20/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit

class ChildSelector: UIView {
    var parentType: NodeType = .typeA
    var potentialChildren = [ChildNodeView]()
    var barHeight: CGFloat!
    var barWidth: CGFloat!
    var nodeRadius: CGFloat!
    var viewHeight: CGFloat!
    weak var delegate: ChildSelectorDelegate?
    
    var layout: [[ChildNodeView]] {
        switch(potentialChildren.count) {
        case 1:
            return [[potentialChildren[0]],[]]
        case 2:
            return [[potentialChildren[0]],[potentialChildren[1]]]
        case 3:
            return [[potentialChildren[0]],[potentialChildren[1],potentialChildren[2]]]
        case 4:
            return [[potentialChildren[0], potentialChildren[1]],[potentialChildren[2],potentialChildren[3]]]
        case 5:
            return [[potentialChildren[0], potentialChildren[1]],[potentialChildren[2],potentialChildren[3],potentialChildren[4]]]
        default:
            return [[],[]]
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func positionViews() {
        let topLevel = layout[0]
        let bottomLevel = layout[1]
        let halfWay = bounds.height / 2
        nodeRadius = delegate?.getNodeRadius()
        barHeight = delegate?.getBarHeight()
        barWidth = delegate?.getBarWidth()
        
        
        
        
//        if bounds.width > bounds.height {
//            // landscape
        print("top")
            placeChildViews(topLevel, yOffset: 0)
         print("bottom")
            placeChildViews(bottomLevel, yOffset: halfWay)
//            
//        } else {
//            // portrait
//            
//        }
    }
    func getAndMakeChildViews() {
        potentialChildren = [ChildNodeView]()
        let childNodeTypes = delegate?.getAvailableNodesData()
        for childType in childNodeTypes! {
            let child = ChildNodeView()
            child.nodeType = childType
            child.backgroundColor = UIColor.clearColor()
            
            addSubview(child)
            potentialChildren.append(child)
            
        }
    }
    
    
    
    
    
    
    func placeChildViews(views: [ChildNodeView], yOffset: CGFloat) {
        print("ViewFrame:")
        print(frame)
        
        if views.count > 0 {
            // width?? view is rotated
            let yPadding:CGFloat = 20
            let viewWidth = nodeRadius * 2

            let xPadding = (bounds.width - (viewWidth * CGFloat(views.count))) / CGFloat(views.count + 1)
            for (i,view) in views.enumerate() {
                view.barWidth = barWidth
                view.barHeight = barHeight
                view.nodeRadius = nodeRadius
                view.transform = CGAffineTransformMakeRotation(PI/2)
                let rect = CGRect(x: xPadding * CGFloat(i + 1), y:  yPadding + yOffset, width: viewWidth, height: viewWidth * 7.5)
                 view.frame = rect
//             
//                view.transform = CGAffineTransformMakeRotation(PI/2)
                view.center = CGPoint(x: xPadding * CGFloat(i + 1) + xPadding * CGFloat(i) , y: yPadding + yOffset)
               
                print(view.frame)
            }
            
        }
    }
    
    /* 
     Todo:
     make layout frames for 1 - 5 nodes for portait and landscape
     
     make child views touchable and dragable (both in the parent and here)
     
     connect changes to settings 
 */

}

protocol ChildSelectorDelegate: class {
    func getNodeRadius() -> CGFloat
    func getViewLength() -> CGFloat
    func getBarHeight() -> CGFloat
    func getBarWidth() -> CGFloat
    func getAvailableNodesData() -> [NodeType]
}
