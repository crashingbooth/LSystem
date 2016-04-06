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
    var dotPaths = [UIBezierPath]()
    var linePaths = [UIBezierPath]()
    var fillColor: UIColor!
    
    override func drawRect(rect: CGRect) {
        fillColor.setFill()
        for path in dotPaths {
            path.fill()
        }
        for path in linePaths {
            path.stroke()
        }
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
    static var segmentLength: CGFloat { get set } // class
    static var view: ViewForNode! { get set }
    var dotPath: UIBezierPath? { get set }
    var linePath: UIBezierPath? { get set }
    
    
    func spawn() -> [Node]
    init()
    
}

extension Node {
    var radius: CGFloat {
        return CGFloat(2)
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
            let location = CGPoint(x: parent.location.x + Self.segmentLength * cos(self.orientation), y:  parent.location.y + Self.segmentLength * sin(self.orientation))
            return location
        } else {
            return rootLocation!
        }
    }
    
    init(parent: Node?, rootLocation: CGPoint?) {
        self.init()
    
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
        let newDotPath = UIBezierPath(ovalInRect: rect)
        
        if let dotPath = dotPath {
            if let index = Self.view.dotPaths.indexOf(dotPath) {
                Self.view.dotPaths[index] = newDotPath
            } else {
                Self.view.dotPaths.append(newDotPath)
            }
        } else {
            Self.view.dotPaths.append(newDotPath)
        }
        dotPath = newDotPath
        
        

        if let parent = parent {
            let edge = UIBezierPath()
            edge.moveToPoint(parent.location)
            edge.addLineToPoint(location)
            if let linePath = linePath {
                
                if let index = Self.view.linePaths.indexOf(linePath) {
                    Self.view.linePaths[index] = edge
                    
                } else {
                    Self.view.linePaths.append(edge)
                }
            } else {
                Self.view.linePaths.append(edge)
            }
            linePath = edge
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
    
//        print("new location \(location)")
      
        
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
   
    static var angle: CGFloat = 0 // class
    static var segmentLength: CGFloat = 35 // class
    static var view: ViewForNode!
    required init() {}
    
    func spawn() -> [Node] {
        let first = TypeBNode(parent: self, rootLocation: nil)
        let second = TypeANode(parent: self,rootLocation: nil)

        
        children.append(first)
        children.append(second)
        return [first, second]
    }
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
    
    static var angle: CGFloat = 0 // class
    static var segmentLength: CGFloat = 30 // class
    static  var view: ViewForNode!
    required init() {}
    
    func spawn() -> [Node] {
        let first = TypeBNode(parent: self, rootLocation: nil)
        let second = TypeANode(parent: self,rootLocation: nil)
   
        
        children.append(first)
        children.append(second)
        return [first, second]
    }
}

// in VC make repository Views and assign them (somehow) for TypeA and typeB, their addPaths func will add them
