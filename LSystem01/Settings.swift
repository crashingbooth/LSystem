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
    
    var maxNumberOfNodes: Int!
    
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
                ], numActive: 2, startSize: 40, angles: [-5.49779,-1.72413])
        case 1:
            setUpInitialConditions([
                .typeA : [.typeB,],
                .typeB : [.typeC],
                .typeC : [.typeD],
                .typeD : [.typeA,.typeB],
                .typeE : []
                ], numActive: 4, startSize: 45, angles: [-4.49107456207275, -2.5296905040741,-5.99172878265381,  -0.758378028869629 ])
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
                ] , numActive: 4, startSize: 16, angles: [-0.482876, -6.03573 ,-4.2188 ,-0.129703])
        default:
            break
        }
    }
    
    private init() {
        var max: Int
        let device = UIDevice.currentDevice().modelName
        print(device)
        switch (device) {
        case "iPhone 4s":
            max = 4000
        case "Simulator":
            max = 4000

        case "iPhone 5":
            max = 5000
        case "iPhone 5s":
            max = 6000
        default:
            max = 5000
        }
        maxNumberOfNodes = max
        print (maxNumberOfNodes)
    

    }
    
    
    
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

// For device detection, older devices will have a lower maxNodeValue
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
