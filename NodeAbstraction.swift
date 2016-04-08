//
//  NodeAbstraction.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/5/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit


//typealias NodeInitializer = (segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)

class ViewForNode: UIView {
    var myNode: Node!
    var dotPaths = [UIBezierPath]()
    var linePaths = [UIBezierPath]()
    var fillColor: UIColor!
    
    override func drawRect(rect: CGRect) {
        fillColor.setFill()
        for path in dotPaths {
            path.fill()
        }
        UIColor.blackColor().colorWithAlphaComponent(0.4).setStroke()
        for path in linePaths {
            path.lineWidth = 2
            path.stroke()
        }
    }
    
    func clearPaths() {
        dotPaths = [UIBezierPath]()
        linePaths = [UIBezierPath]()
    }
}

protocol Node {
    var parent: Node? { get set }
    var children: [Node] { get set }
    var rootLocation: CGPoint? { get set }
    var orientation: CGFloat { get set }
    var location: CGPoint { get set }
    var nodeColor: UIColor { get set } // class
    static var angle: CGFloat { get set } // class
    
    static var view: ViewForNode! { get set }
    var dotPath: UIBezierPath? { get set }
    var linePath: UIBezierPath? { get set }
    var segmentLength: CGFloat { get set }
    
    var substitutesTo: [(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)] { get set }
    
    
    
    init()
    
}

extension Node {
    var radius: CGFloat {
        return CGFloat(4)
    }
    var reductionFactor: CGFloat {
        return 0.85
    }
    
    func calcOrientation() -> CGFloat {
//        print(Self.angle)
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
        let rect = CGRect(x: location.x - radius, y: location.y - radius, width: radius * 2, height: radius * 2)
        dotPath = UIBezierPath(ovalInRect: rect)
        Self.view.dotPaths.append(dotPath!)
        
        

        if let parent = parent {
            let edge = UIBezierPath()
            edge.moveToPoint(parent.location)
            edge.addLineToPoint(location)
            linePath = edge
            Self.view.linePaths.append(linePath!)
            
        }
        
        
    }
    
    // redo!!!!
    mutating func recursiveReposition() {
//        print("old location \(location)")
        if let rootLocation = rootLocation {
            location = rootLocation // as before
        } else {
            orientation = calcOrientation()
            location = calcLocation()
        }
        makePaths()
        for (i, _) in children.enumerate() {
            children[i].recursiveReposition()
        }
      
        
    }
    
    mutating func spawn() -> [Node] {
        for node in substitutesTo {
            children.append(node(segmentLength: segmentLength * reductionFactor, parent: self, rootLocation: nil))
        }
        return children
    }
}

class TypeANode: Node {
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var nodeColor: UIColor = UIColor.blueColor()
    var dotPath: UIBezierPath?
    var linePath: UIBezierPath?

   
    static var angle: CGFloat = CGFloat(M_PI / 4) // class
    var segmentLength: CGFloat = 0
    static var view: ViewForNode!
    
    var substitutesTo : [(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)] =
        [TypeCNode.init]
    required init() {}
    
}

class TypeBNode: Node {
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var nodeColor: UIColor = UIColor.purpleColor()
    var dotPath: UIBezierPath?
    var linePath: UIBezierPath?
 
    
    static var angle: CGFloat = CGFloat(M_PI / 4)// class
    var segmentLength: CGFloat = 0// class
    static  var view: ViewForNode!
    
    var substitutesTo : [(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)] =
        [TypeCNode.init, TypeANode.init]
    
    required init() {}

}

class TypeCNode: Node {
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var nodeColor: UIColor = UIColor.purpleColor()
    var dotPath: UIBezierPath?
    var linePath: UIBezierPath?
    
    
    static var angle: CGFloat = CGFloat(M_PI / 4)// class
    var segmentLength: CGFloat = 0// class
    static  var view: ViewForNode!
    
    var substitutesTo : [(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)] =
        [TypeBNode.init]
    
    required init() {}
    
}



// in VC make repository Views and assign them (somehow) for TypeA and typeB, their addPaths func will add them
