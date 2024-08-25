//
//  ScratchViewController.swift
//  StudyPad
//
//  Created by Hanning Ni on 9/2/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//
import Foundation
import UIKit

class ScratchViewController: UIViewController {

    
    @IBOutlet weak var scratchPad: TouchDrawView!
    
    @IBAction func clearClicked(sender: AnyObject) {
        if ( scratchPad != nil ){
            scratchPad.clearAll();
        }
    }
    
    @IBAction func undoClicked(sender: AnyObject) {
        if ( scratchPad != nil ){
            scratchPad.undo();
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
}
