//
//  BookmarkViewController.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/29/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import UIKit

class BookmarkViewController:  UIViewController {
    
     
   
    @IBOutlet weak var menuButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
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
    
    // pragma mark state preservation / restoration
    
    override func encodeRestorableStateWithCoder(coder :NSCoder)
    {
        
        super.encodeRestorableStateWithCoder(coder);
    }
    
    override func decodeRestorableStateWithCoder(coder :NSCoder)
    {
        
        super.decodeRestorableStateWithCoder(coder);
    }
    
    override func applicationFinishedRestoringState()
    {
        customSetup();
    }
    
    
    func customSetup()
    {
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside);
            
            //    menuButton.tar = self.revealViewController()
            //  menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    
}
