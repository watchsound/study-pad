//
//  HomeViewController.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/29/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import UIKit
 

class HomeViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    @IBOutlet weak var timeStudied: UILabel!
    
    @IBOutlet weak var conceptInvolved: UILabel!
    
    @IBOutlet weak var aboutLabel: UILabel!
    
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
        
        var randomValue = arc4random_uniform(8)
        switch( randomValue ){
            case 0 :
                backgroundImage.image = UIImage(named: "bg_grass.jpg")
                break;
            case 1 :
                 backgroundImage.image = UIImage(named: "bg_boxes.jpg")
                 break;
        case 2 :
            backgroundImage.image = UIImage(named: "bg_1.jpg")
            break;
        case 3 :
            backgroundImage.image = UIImage(named: "bg_2.jpg")
            break;
        case 4 :
            backgroundImage.image = UIImage(named: "bg_3.jpg")
            break;
        case 5 :
            backgroundImage.image = UIImage(named: "bg_4.jpg")
            break;
        case 6 :
            backgroundImage.image = UIImage(named: "bg_5.jpg")
            break;
        case 7 :
            backgroundImage.image = UIImage(named: "bg_6.jpg")
            break;
        case 8 :
            backgroundImage.image = UIImage(named: "bg_7.jpg")
            break;
            default :
                 backgroundImage.image = UIImage(named: "bg_boxes.jpg")
                 break;
        }
        var timeused :Double = R9Properties.shared.getTotalStudyTime()
        
        if ( timeused < 60 ){
            timeused = round( timeused)
            timeStudied.text = "\(timeused) seconds"
        }
        else {
            timeused = round( timeused / 60 )
            timeStudied.text = "\(timeused) minutes"
        }
        
        
        
        conceptInvolved.text = R9Properties.shared.getSummary()
        
        aboutLabel.verticalUpAlignmentWithText(aboutLabel.text, maxHeight: 9999)
        conceptInvolved.verticalUpAlignmentWithText(conceptInvolved.text, maxHeight: 9999)
        
        
    }
    

}
