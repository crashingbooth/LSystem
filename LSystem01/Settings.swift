//
//  Settings.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/16/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import Foundation

enum NodeType: Int {
    case typeA, typeB, typeC, typeD, typeE
    
    static let allNodeTypes: [NodeType] = [typeA, typeB, typeC, typeD, typeE]
}
class Settings {
    static var sharedInstance = Settings()
    var numOfActiveNodes = 2 // controlled by slider in OuterSettings
    var nodeSubstitutions: [NodeType: Set<NodeType>] = [
        .typeA : [.typeB, .typeA],
        .typeB : [.typeB],
        .typeC : [],
        .typeD : [],
        .typeE : []
    ]
    var startingNode: NodeType = .typeA
    
    
    var findReachableNodes: Set<NodeType> {
        var reachable = Set<NodeType>()
        
        var queue: [NodeType] = [startingNode]
        // all nodes must be reachable within 5 generations
        for _ in 0..<NodeType.allNodeTypes.count {
            if queue.count == 0 {
                break
            }
            var nextQueue = [NodeType]()
            for node in queue {
                if !reachable.contains(node) {
                    reachable.insert(node)
                    for child in nodeSubstitutions[node]! {
                        nextQueue.append(child)
                    }
                }
            }
            queue = nextQueue
        }
        return reachable
    }
    
    func getAncestors(nodeType: NodeType) -> Set<NodeType> {
        var ancestors = Set<NodeType>()
        for type in NodeType.allNodeTypes {
            if let subs = Settings.sharedInstance.nodeSubstitutions[type] {
                if subs.contains(nodeType) {
                    ancestors.insert(type)
                }
            }
        }
        return ancestors
    }
    
    
    
    private init() {}
    
    
    
    static let initDict: [NodeType:(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)] = [
        NodeType.typeA : TypeANode.init,
        NodeType.typeB : TypeBNode.init,
        NodeType.typeC : TypeCNode.init,
        NodeType.typeD : TypeDNode.init,
        NodeType.typeE : TypeENode.init
    ]
    
    static let colorDict: [NodeType:UIColor] = [
        NodeType.typeA: UIColor.blueColor().colorWithAlphaComponent(0.5),
        NodeType.typeB:    UIColor.purpleColor().colorWithAlphaComponent(0.5),
        NodeType.typeC:    UIColor.redColor().colorWithAlphaComponent(0.5),
        NodeType.typeD:    UIColor.brownColor().colorWithAlphaComponent(0.5),
        NodeType.typeE:    UIColor.magentaColor().colorWithAlphaComponent(0.5)
        ]
    
    
        
    
}