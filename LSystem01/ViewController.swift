//
//  ViewController.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/4/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var arrayOfNode = [Node]()

    var maxAngle = CGFloat(M_PI)
    var minAng = CGFloat(0)
    var rootNode: Node?
    var nodeViews = [ViewForNode]()
    var knobs = [Knob]()
    var nodeTypes:Int {
       return listofNodeClasses.count
    }
    
    var nodeCount = 0
    var listofNodeClasses: [Node.Type] {
        return  Array(Constants.allNodeClasses[0..<Settings.sharedInstance.highestActiveNode])
    }

    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
       super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        setUp()
    }
    
    func setUp() {
        createAndAssignNodeViews()
        makeInitialNode()
        makeKnobs()
        nodeCount = 0
        for gen in 0..<40{
            print("generation \(gen)")
            if nodeCount < 6000 && arrayOfNode[0].segmentLength > 0.5 {
                regenerate()
            }
        }
        
        view.gestureRecognizers?.removeAll()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinched(_:)))
        view.addGestureRecognizer(pinch)
        
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panned(_:)))
        view.addGestureRecognizer(pan)
//
        // TODO - find better way
        settingsButton.removeFromSuperview()
        nodeViews.last?.addSubview(settingsButton)

        
    }
    
    func pinched(gesture: UIPinchGestureRecognizer) {
        let scale: CGFloat = gesture.scale;
        rootNode?.segmentLength *= scale
        for view in nodeViews {
            view.clearPaths()
        }
        rootNode?.recursiveChangeLength()
        for view in nodeViews {
            view.setNeedsDisplay()
        }
 
        gesture.scale = 1
    }
    
    func panned(gesture: UIPanGestureRecognizer) {
        let trans = gesture.translationInView(view)
        for view in nodeViews {
            view.clearPaths()
        }
        rootNode?.rootLocation!.x += trans.x
        rootNode?.rootLocation!.y += trans.y
        rootNode?.recursiveReposition()
        for view in nodeViews {
            view.setNeedsDisplay()
        }
        gesture.setTranslation(CGPoint.zero, inView: view)
    }
    
     func makeInitialNode() {
        arrayOfNode = [Node]()
        let rootLocation = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        let rootInit = Settings.initDict[Settings.sharedInstance.startingNode]!
        rootNode = rootInit(segmentLength: 100 , parent: nil, rootLocation: rootLocation)
        if let rootNode = rootNode {
            arrayOfNode.append(rootNode)
        }

        
        
    }

    
    func regenerate() {
        var newArrayOfNodes = [Node]()
        for (i,_) in arrayOfNode.enumerate() {
            let spawn = arrayOfNode[i].spawn()
            for newNode in spawn {
                newArrayOfNodes.append(newNode)
                nodeCount += 1
            }
            if nodeCount > 6000 {
                break
            }
        }
        arrayOfNode = newArrayOfNodes
        print("end: arrayOfNode size: \(arrayOfNode.count)")
        
    }
    
    func createAndAssignNodeViews() {
        if nodeViews.count > 0 {
            for nodeView in nodeViews {
                nodeView.removeFromSuperview()
            }
        }
        nodeViews = [ViewForNode]()
        for i in 0..<nodeTypes {
            let nodeView = ViewForNode(frame: view.bounds)
            nodeViews.append(nodeView)
            nodeView.backgroundColor = UIColor.clearColor()
            view.addSubview(nodeView)
            nodeView.fillColor = Constants.nodeColors[i].colorWithAlphaComponent(0.4)
            listofNodeClasses[i].view = nodeView
        }
    }
    
    func makeKnobs() {
        let maxKnob = CGFloat(130) > view.bounds.width / 5 ? view.bounds.width / 5 :  CGFloat(130)
        var width = view.bounds.width / CGFloat(2 * nodeTypes - 1 )
        var buffer:CGFloat = 0
        if width > maxKnob {
            width = maxKnob
            buffer = (view.bounds.width - maxKnob * CGFloat((2 * nodeTypes - 1))) / 2
        }
        if knobs.count > 0 {
            for knob in knobs {
                knob.removeFromSuperview()
            }
            knobs = [Knob]()
        }
        for i in 0..<(2 * nodeTypes - 1) {
            if i % 2 == 0 {
                print (width)
                let π = Float(M_PI)
                let rect = CGRect(x: buffer + CGFloat(i) * width, y: view.bounds.height - (width + 20), width: width, height: width)
                let knob = Knob(frame: rect)
                
                knob.continuous = true
                knob.minimumValue = -2 * π
                knob.pointerLength = 10.0
                knob.maximumValue = 0
                knob.lineWidth = 5.0
                knob.tintColor = Constants.nodeColors[i/2].colorWithAlphaComponent(0.4)
                knob.addTarget(self, action: #selector(ViewController.knobPositionChanged(_:)), forControlEvents: .ValueChanged)
                
                knobs.append(knob)
                view.addSubview(knob)
            }
            
        }
        view.setNeedsDisplay()
    }
    
    func knobPositionChanged(sender: Knob) {
        listofNodeClasses[knobs.indexOf(sender)!].angle = CGFloat(sender.value)
        for view in nodeViews {
            view.clearPaths()
        }
        
        
        rootNode?.recursiveReposition()
        for view in nodeViews {
            view.setNeedsDisplay()
        }
    
    }
    
    
    @IBAction func settingsButton(sender: AnyObject) {
        print("pressed")
        performSegueWithIdentifier("toSettings", sender: self)
    }
    
    override func overrideTraitCollectionForChildViewController(childViewController: UIViewController) -> UITraitCollection? {
        print("called")
        if view.bounds.width > view.bounds.height {
            return UITraitCollection(verticalSizeClass: .Compact)
        } else {
            return UITraitCollection(verticalSizeClass: .Regular)
        }
    }
    



    

}

