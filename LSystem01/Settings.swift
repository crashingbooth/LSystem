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
    
    // basic rule system
    var nodeSubstitutions: [NodeType: Set<NodeType>] = [
        .typeA : [.typeB, .typeA],
        .typeB : [.typeB],
        .typeC : [],
        .typeD : [],
        .typeE : []
    ]
    var startingNode: NodeType = .typeA
    
    // relative to max(width/height) of screen
    var initialLengthRatio: CGFloat = 30
    
    
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
    
    func setUpInitialConditions(subDict: [NodeType:Set<NodeType>], numActive: Int, startSize: CGFloat, angles: [CGFloat] ) {
        nodeSubstitutions = subDict
        numOfActiveNodes = numActive
        initialLengthRatio = startSize
        
        if numActive >= 1 {
            TypeANode.angle = angles[0]
        }
        
        if numActive >= 2 {
            TypeBNode.angle = angles[1]
        }
        
        if numActive >= 3 {
            TypeCNode.angle = angles[2]
        }
        
        if numActive >= 4 {
            TypeDNode.angle = angles[3]
        }
        
        if numActive == 5 {
            TypeENode.angle = angles[4]
        }
        
    }
    
    func setWithNumberedPreset(preset: Int) {
        switch(preset) {
        case 0:
            setUpInitialConditions([
                .typeA : [.typeB, .typeA],
                .typeB : [.typeB],
                .typeC : [],
                .typeD : [],
                .typeE : []
                ], numActive: 2, startSize: 39, angles: [-5.49779,-1.72413])
        case 1:
            setUpInitialConditions([
                .typeA : [.typeB,],
                .typeB : [.typeC],
                .typeC : [.typeD],
                .typeD : [.typeA,.typeB],
                .typeE : []
                ], numActive: 4, startSize: 30, angles: [-4.49107456207275, -2.5296905040741,-5.99172878265381,  -0.758378028869629 ])
        case 2:
            setUpInitialConditions([
                .typeA : [.typeA,.typeB,.typeC,.typeD],
                .typeB : [.typeB],
                .typeC : [.typeD],
                .typeD : [.typeB],
                .typeE : []
                ], numActive: 4, startSize: 30, angles: [-4.97299146652222,-0.588002681732178,-1.94606733322144,-0.759088516235352])
        case 3:
            setUpInitialConditions([
                .typeA : [.typeA,.typeB,.typeC,],
                .typeB : [.typeB],
                .typeC : [.typeB,.typeC],
                .typeD : [],
                .typeE : []
                ], numActive: 3, startSize: 30, angles: [-0.614663124084473, -3.91086339950562 ,-5.81278133392334])
        case 4:
            setUpInitialConditions([
                .typeA : [.typeA,.typeB],
                .typeB : [.typeB,.typeD],
                .typeC : [.typeA],
                .typeD : [.typeC],
                .typeE : []
                ] , numActive: 4, startSize: 30, angles: [-0.482876, -6.03573 ,-4.2188 ,-0.129703])
        default:
            break
        }
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
