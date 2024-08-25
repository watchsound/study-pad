//
//  HomeViewController.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/28/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import UIKit
import Foundation
 

class ReportViewController:   FFCalendarViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.arrayWithEvents = arrayWithEvents2();
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
       
        
       // var data : NSMutableArray =  NSMutableArray();
      //  var calendarVc : FFCalendarViewController = FFCalendarViewController()
    //    super.arrayWithEvents = arrayWithEvents2();
        
        
    }
    
   
    
    override func buttonBackAction(sender : AnyObject) {
        self.revealViewController().revealToggle(sender);
    }
    
    func arrayWithEvents2() -> NSMutableArray {
        var events : [StudyEvent] = R9DBConnectionManager.shared.populateLearningEventsFromDatabase()
        var result :NSMutableArray =   []
        var event : StudyEvent = StudyEvent()
        for  event in events {
            var event1 = FFEvent()
            event1.stringCustomerName = event.eventName
            event1.numCustomerID = NSNumber( longLong: event.eventId )
            event1.dateDay =
                NSDate(timeIntervalSince1970: event.eventDay.timeIntervalSince1970)
            event1.dateTimeBegin =
                NSDate(timeIntervalSince1970: event.eventStart.timeIntervalSince1970)
            event1.dateTimeEnd =
                NSDate(timeIntervalSince1970: event.eventEnd.timeIntervalSince1970)
            
            
//             event1.dateDay = NSDate(year: NSDate.componentsOfCurrentDate().year,
//                month: NSDate.componentsOfCurrentDate().month, day: NSDate.componentsOfCurrentDate().day)
//             event1.dateTimeBegin = NSDate(hour:16, min:00);
//             event1.dateTimeEnd = NSDate(hour:17, min:00);
           
            
            var guest : [AnyObject] = [NSNumber(longLong: event.eventId), event.eventName]
            event1.arrayWithGuests = [guest]
            result.addObject( event1 )
        }
        return result
    }
    
    
}
