////
////  Node.swift
////  LSystem01
////
////  Created by Jeff Holtzkener on 4/4/16.
////  Copyright © 2016 Jeff Holtzkener. All rights reserved.
////
//
//import UIKit
//
//protocol L_SystemNode {
//    var parent: L_SystemNode? { get set }
//    var children: [L_SystemNode] { get set }
//    var rootLocation: CGPoint? { get set }
//    var orientation: CGFloat { get set }
//    var location: CGPoint { get set }
//    static var nodeColor: UIColor { get } // class
//    static var angle: CGFloat { get } // class
//    static var segmentLength: CGFloat { get } // class
//    
//    
//    func spawn() -> [AbstractNode]
//    func recursiveReposition()
//    
//}
//
//extension L_SystemNode {
//    var radius: CGFloat {
//        return CGFloat(2)
//    }
//    
//    func calcOrientation() -> CGFloat {
//        print(Self.angle)
//        if let parent = parent {
//            return Self.angle + parent.orientation
//        } else {
//            return 0
//        }
//    }
//    
//    func calcLocation() -> CGPoint {
//        
//        if let parent = parent {
//        let location = CGPoint(x: parent.location.x + Self.segmentLength * cos(self.orientation), y:  parent.location.y + Self.segmentLength * sin(self.orientation))
//        return location
//        } else {
//            return rootLocation!
//        }
//    }
//    
//    
//    
//    
//}
//
//class AbstractNode: UIView, L_SystemNode {
//    var myColor: UIColor!
//    var parent: L_SystemNode?
//    var children = [L_SystemNode]()
//    var orientation: CGFloat = 0
//    var location: CGPoint = CGPoint.zero
//    class var nodeColor: UIColor {  // override
//        return UIColor.clearColor()
//    }
//    class var angle: CGFloat {
//        print("abstract node's")
//        return 0
//    }
//   
//    class var segmentLength: CGFloat {
//        return 0
//    }
//
//    var rootLocation: CGPoint?
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    init(frame:  CGRect, parent: L_SystemNode?, rootLocation: CGPoint?) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.clearColor()
//        if let parent = parent {
//            self.parent = parent
//          
//        } else {
//            self.rootLocation = rootLocation
//            orientation = CGFloat( M_PI)
//        }
//    }
//    
//  
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func drawRect(rect: CGRect) {
//        print("typeA drawRect")
//        let rect = CGRect(x: location.x - radius, y: location.y - radius, width: radius * 2, height: radius * 2)
//        
//        let node = UIBezierPath(ovalInRect: rect)
//        myColor.setFill()
//        node.fill()
//        
//        if let parent = parent {
//            let edge = UIBezierPath()
//            edge.moveToPoint(parent.location)
//            edge.addLineToPoint(location)
//            
//            UIColor.blackColor().colorWithAlphaComponent(0.5).setStroke()
//            edge.lineWidth = 2
//            edge.stroke()
//        }
//    }
//    
//    // override
//    func spawn() -> [AbstractNode] {
//        let first = TypeANode(frame: frame, parent: self, rootLocation: nil)
//        self.superview?.addSubview(first)
//        
//        children.append(first)
//        return [first]
//    }
//    
//    
//    func recursiveReposition() {
//        print("old location \(location)")
//        if let rootLocation = rootLocation {
//            location = rootLocation // as before
//        } else {
//            orientation = calcOrientation()
//            location = calcLocation()
//        }
//        
//        for (i, _) in children.enumerate() {
//            children[i].recursiveReposition()
//        }
//        print("new location \(location)")
////        setNeedsDisplay()
//        
//    }
//
//}
//
//
//class _TypeANode: AbstractNode {
//    static var myAngle: CGFloat = CGFloat(M_PI)
//    override static var nodeColor: UIColor {
//        return UIColor.purpleColor()
//    }
//    
//    override static var angle:CGFloat {
//        print("returning myANgle")
//        return myAngle
//    }
//    override static var segmentLength: CGFloat {
//        return 60
//    }
//    
//    override init(frame: CGRect, parent: L_SystemNode?, rootLocation: CGPoint?) {
//        super.init(frame: frame, parent: parent, rootLocation: rootLocation)
//        myColor = UIColor.purpleColor()
//        orientation = calcOrientation()
//        location = calcLocation()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//   
//    
//    override func spawn() -> [AbstractNode] {
//        var first = TypeBNode(frame: frame, parent: self, rootLocation: nil)
//        var second = TypeANode(frame: frame, parent: self,rootLocation: nil)
//        self.superview?.addSubview(first)
//        self.superview?.addSubview(second)
//        
//        children.append(first)
//        children.append(second)
//        return [first, second]
//    }
//
//    
//
//   }
//
//class _TypeBNode: AbstractNode {
//    static var myAngle: CGFloat = CGFloat(M_PI / 2)
//    override static var nodeColor: UIColor {
//        return UIColor.blueColor()
//    }
//    
//    override static var angle:CGFloat {
//        return CGFloat( M_PI / 6)
//    }
//    override static var segmentLength: CGFloat {
//        return myAngle
//    }
//
//    override init(frame: CGRect, parent: L_SystemNode?, rootLocation: CGPoint?) {
//        super.init(frame: frame, parent: parent, rootLocation: rootLocation)
//        myColor = UIColor.blueColor()
//        orientation = calcOrientation()
//        location = calcLocation()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func spawn() -> [AbstractNode] {
//        var first = TypeANode(frame: frame, parent: self, rootLocation: nil)
//        self.superview?.addSubview(first)
//   
//        return [first]
//    }
//    
//
//    
//}
//
//extension CGFloat {
//    var PI: CGFloat {
//        return CGFloat(M_PI)
//    }
//}
//
//
//
//
//
