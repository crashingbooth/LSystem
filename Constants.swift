//
//  Constants.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/14/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    static let nodeColors: [UIColor] = [
        UIColor.blueColor(),
        UIColor.purpleColor(),
        UIColor.redColor(),
        UIColor.brownColor(),
        UIColor.magentaColor()
    ]
    
    static let allNodeClasses: [Node.Type] =
        [TypeANode.self,
         TypeBNode.self,
         TypeCNode.self,
         TypeDNode.self,
         TypeENode.self]
}