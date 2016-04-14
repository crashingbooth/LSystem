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
    var dotRects = [CGRect]()
    var dotLocations = [CGPoint]()
    var lineLocations = [(CGPoint, CGPoint)]()
    
    var fillColor: UIColor!
    

    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, fillColor.CGColor)

//        for dot in dotLocations {
//            CGContextAddArc(context, dot.x, dot.y, 3, 0, 2 * CGFloat(M_PI), 1)
//             CGContextFillPath(context)
//        }
        
//        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().colorWithAlphaComponent(0.4).CGColor)
        
        for line in lineLocations {
            CGContextMoveToPoint(context, line.0.x, line.0.y)
            CGContextAddLineToPoint(context, line.1.x, line.1.y)
            CGContextSetLineWidth(context, 2.0)
            CGContextStrokePath(context)
        }
        
    }
    
    func clearPaths() {
//        dotLocations = [CGPoint]()
        lineLocations = [(CGPoint, CGPoint)]()
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
    static var count: Int { get set }
    var nodeCounter: NodeCounter { get set}
    
    
    static var view: ViewForNode! { get set }
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
        Self.count += 1
        nodeCounter.count += 1
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
//        let rect = CGRect(x: location.x - radius, y: location.y - radius, width: radius * 2, height: radius * 2)
//        Self.view.dotRects.append(rect)
//        Self.view.dotLocations.append(location)
        

        if let parent = parent {
            Self.view.lineLocations.append((parent.location, location))
            
        }
        
        
    }
    

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
    static var count = 0
    var nodeCounter = NodeCounter.sharedInstance

   
    static var angle: CGFloat = CGFloat(7*(M_PI)/8) // class
    var segmentLength: CGFloat = 0
    static var view: ViewForNode!
    
    var substitutesTo : [(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)] =
        [TypeCNode.init, TypeBNode.init, TypeDNode.init]
    required init() {}
    
}

class TypeBNode: Node {
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var nodeColor: UIColor = UIColor.purpleColor()
     static var count = 0
    var nodeCounter = NodeCounter.sharedInstance
 
    
    static var angle: CGFloat = CGFloat(7*(M_PI)/8) // class
    var segmentLength: CGFloat = 0// class
    static  var view: ViewForNode!
    
    var substitutesTo : [(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)] =
        [TypeDNode.init]
    
    required init() {}

}

class TypeCNode: Node {
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var nodeColor: UIColor = UIColor.purpleColor()
    static var count = 0
    var nodeCounter = NodeCounter.sharedInstance
    
    
    static var angle: CGFloat = CGFloat(7*(M_PI)/8) // class
    var segmentLength: CGFloat = 0// class
    static  var view: ViewForNode!
    
    var substitutesTo : [(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)] =
        [TypeBNode.init]
    
    required init() {}
    
}

class TypeDNode: Node {
    var parent: Node?
    var children = [Node]()
    var rootLocation: CGPoint?
    var orientation: CGFloat = 0
    var location: CGPoint = CGPoint.zero
    var nodeColor: UIColor = UIColor.purpleColor()
    static var count = 0
    var nodeCounter = NodeCounter.sharedInstance
    
    
    static var angle: CGFloat = CGFloat(7*(M_PI)/8) // class
    var segmentLength: CGFloat = 0// class
    static  var view: ViewForNode!
    
    var substitutesTo : [(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)] =
        [TypeANode.init]
    
    required init() {}
    
}

class NodeCounter {
    static let sharedInstance = NodeCounter()
    var count = 0
    var limit = 6000
    private init() {}
}



// in VC make repository Views and assign them (somehow) for TypeA and typeB, their addPaths func will add them
