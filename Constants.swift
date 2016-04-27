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
    static let reductionFactor: CGFloat = 0.85
    
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
    
    static let cleanUpNeeded = "CleanUpNeeded"
    
    static let font = UIFont(name: "Futura-Medium" , size: 15)
}
