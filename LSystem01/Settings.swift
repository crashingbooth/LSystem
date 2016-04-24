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
    var highestActiveNode = 2 // controlled by slider in OuterSettings
    var nodeSubstitutions: [NodeType: Set<NodeType>] = [
        .typeA : [.typeB, .typeA],
        .typeB : [.typeB],
        .typeC : [],
        .typeD : [],
        .typeE : []
    ]
    
    
    
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