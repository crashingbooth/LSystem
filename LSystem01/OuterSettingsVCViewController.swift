//
//  OuterSettingsVCViewController.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 4/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import UIKit

class OuterSettingsVCViewController: UIViewController {

    @IBOutlet weak var nodeExtensionTest: NodeExtensionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.userInteractionEnabled = false
        nodeExtensionTest.getSizes()
        nodeExtensionTest.setUpExtensions()
       
        
        view.userInteractionEnabled = true
        
//        for ext in nodeExtensionTest.childNodeViews {
//            let touch = UITapGestureRecognizer(target: ChildNodeView.self, action: #selector(ext.tapped(_:)))
//            nodeExtensionTest.addGestureRecognizer(touch)
//        }
       

        // Do any additional setup after loading the view.
    }
    
    func tapped(sender: UITapGestureRecognizer) {
        print(" VC toucjed")
        
    }

   


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
