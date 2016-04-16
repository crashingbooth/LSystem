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
    var sharedInstance = Settings()
    var activeNodes = [NodeType]()
    var nodeSubstitutions = [NodeType: [NodeType]]()
    
    private init() {}
}