//
//  NodeAbstraction.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/5/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit


class ViewForNode: UIView {
    var myNode: Node!
    var lineLocations = [(CGPoint, CGPoint)]()
    var root: CGPoint?
    
    var fillColor: UIColor!
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, fillColor.CGColor)
        
        for line in lineLocations {
            CGContextMoveToPoint(context, line.0.x, line.0.y)
            CGContextAddLineToPoint(context, line.1.x, line.1.y)
            CGContextStrokePath(context)
        }
        if let root = root {
            let path = UIBezierPath(arcCenter: root, radius: 3, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: true)
            fillColor.setFill()
            path.fill()
        }
        
    }
    
    func clearPaths() {
        lineLocations = [(CGPoint, CGPoint)]()
    }
}

protocol Node {
    static var nodeType: NodeType { get }
    static var angle: CGFloat { get set }
    static var view: ViewForNode! { get set }
    
    var parent: Node? { get set }
    var children: [Node] { get set }
    var rootLocation: CGPoint? { get set }
    var orientation: CGFloat { get set }
    var location: CGPoint { get set }
    var segmentLength: CGFloat { get set }
    
    init()
    
}

extension Node {
    var reductionFactor: CGFloat {
        return Constants.reductionFactor
    }
    
    func calcOrientation() -> CGFloat {
        if let parent = parent {
            return Self.angle + parent.orientation
        } else {
            return 0
        }
    }
    
    func calcLocation() -> CGPoint {
        
        if let parent = parent {
            let location = CGPoint(x: parent.location.x + self.segmentLength * cos(self.orientation), y:  parent.location.y + self.segmentLength * sin(self.orientation))
            return location
        } else {
            return rootLocation!
        }
    }
    
    init(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) {
        self.init()
        self.segmentLength = segmentLength
        if let parent = parent {
            self.parent = parent
            orientation = calcOrientation()
            location = calcLocation()
            
        } else {
            self.rootLocation = rootLocation
            location = rootLocation!
            orientation = CGFloat( M_PI)
        }
        makePaths()
        
    }
    
    mutating func makePaths() {
        if let parent = parent {
            if Self.view.frame.contains(parent.location) || Self.view.frame.contains(location) {
                Self.view.lineLocations.append((parent.location, location))
            }
        } else {
            Self.view.root = self.rootLocation
        }
    }
    

    mutating func recursiveReposition() {
        if let rootLocation = rootLocation {
            location = rootLocation
        } else {
            orientation = calcOrientation()
            location = calcLocation()
        }
        
        makePaths()
        
        for (i, _) in children.enumerate() {
            children[i].recursiveReposition()
        }
    }
    mutating func recursiveChangeLength() {
        for (i, _) in children.enumerate() {
            children[i].segmentLength = segmentLength * reductionFactor
            if let rootLocation = rootLocation {
                location = rootLocation
                
            } else {
                orientation = calcOrientation()
                location = calcLocation()
            }
            
            makePaths()
            children[i].recursiveChangeLength()
        }
        
    }
    
    mutating func spawn() -> [Node] {
    // called by regenerate function in VC
        for node in Settings.sharedInstance.nodeSubstitutions[Self.nodeType]! {
            if let nodeInit = Settings.initDict[node] {
            children.append(nodeInit(segmentLength: segmentLength * reductionFactor, parent: self, rootLocation: nil))
            }
        }
        return children
    }
    
    
    
    
}

class TypeANode: Node {
    static let nodeType: NodeType = .typeA
    static var angle: CGFloat = CGFloat(7*(M_PI)/8)
    static var view: ViewForNode! // set in VC
    
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var segmentLength: CGFloat = 0


    required init() {}
    
}

class TypeBNode: Node {
    static let nodeType: NodeType = .typeB
    static var angle: CGFloat = CGFloat(7*(M_PI)/8)
    static var view: ViewForNode! // set in VC
    
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var segmentLength: CGFloat = 0
    
    
    required init() {}

}

class TypeCNode: Node {
    static let nodeType: NodeType = .typeC
    static var angle: CGFloat = CGFloat(7*(M_PI)/8)
    static var view: ViewForNode! // set in VC
    
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var segmentLength: CGFloat = 0
    
    
    required init() {}
    
}

class TypeDNode: Node {
    static let nodeType: NodeType = .typeD
    static var angle: CGFloat = CGFloat(7*(M_PI)/8)
    static var view: ViewForNode! // set in VC
    
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var segmentLength: CGFloat = 0
    
    
    required init() {}
    
}

class TypeENode: Node {
   static let nodeType: NodeType = .typeE
    static var angle: CGFloat = CGFloat(7*(M_PI)/8)
    static var view: ViewForNode! // set in VC
    
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var segmentLength: CGFloat = 0


    required init() {}
    
}




