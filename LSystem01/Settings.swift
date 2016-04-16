//
//  Settings.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/16/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import Foundation

enum NodeType {
    case typeA, typeB, typeC, typeD, typeE
}
class Settings {
    static var sharedInstance = Settings()
    var activeNodes = [NodeType]()
    var nodeSubstitutions: [NodeType: [NodeType]] = [
        .typeA : [.typeB],
        .typeB :   [.typeA, .typeB],
        .typeC : [ .typeA]
    ]
    
    
    
    private init() {}
    
    
    static let initDict: [NodeType:(segmentLength: CGFloat, parent: Node?, rootLocation: CGPoint?) -> (Node)] = [
        NodeType.typeA : TypeANode.init,
        NodeType.typeB : TypeBNode.init,
        NodeType.typeC : TypeCNode.init,
        NodeType.typeD : TypeDNode.init,
        NodeType.typeE : TypeENode.init
    ]
        
    
}