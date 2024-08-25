//
//  TopLeftMenuViewController.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/28/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import UIKit

class TopLeftMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor(white: 1.0, alpha: 1.0);
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.clearsSelectionOnViewWillAppear = false;
   
        
//        var  revealController : SWRevealViewController  = self.revealViewController();
//        revealController.rearViewRevealWidth = 60;
//        revealController.rearViewRevealOverdraw = 60;
//        revealController.bounceBackOnOverdraw = false;
//        revealController.stableDragOnOverdraw = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
         return UIStatusBarStyle.LightContent;
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
         return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 4
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 88;
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if Reachability.isConnectedToNetwork() {
            return  indexPath
        } else {
            if indexPath.row == 3 { //disable production list view for no connection
                return nil
            }  else {
                return  indexPath
            }
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let revealController : SWRevealViewController = self.revealViewController();
        var CellIdentifier : String = "topLeftMenuItemCellId";
        
        switch ( indexPath.row )
        {
        case 0:
            CellIdentifier = "home";
            break;
            
        case 1:
            CellIdentifier = "problemset";
            break;
            
        case 2:
            CellIdentifier = "report";
            break;
        case 3:
            CellIdentifier = "bookmark";
            break;
            
        case 4:
            CellIdentifier = "me";
            break;
            
        case 5:
            CellIdentifier = "spacing";
            break;
            
        default:
            CellIdentifier = "home";
        }

        
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as? UITableViewCell

       
//        if cell == nil
//        {
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier);
//        }
        
        var text :FontAwesome? = FontAwesome.Adjust;
        switch ( indexPath.row )
        {
        case 0: text = FontAwesome.Home; break;
        case 1: text = FontAwesome.Pencil; break;
        case 2: text = FontAwesome.Calendar; break;
        case 3: text = FontAwesome.ShoppingCart; break;
        case 4: text = FontAwesome.Female; break;
        case 5: text = FontAwesome.Question; break;
        default:  text = FontAwesome.Question;
        }
        if indexPath.row == 5 {
            
        } else {
            cell!.imageView!.image  = UIImage.fontAwesomeIconWithName(text!, textColor: UIColor(white: 0.0, alpha: 1.0), size: CGSizeMake(24, 24));
            cell!.imageView!.frame = CGRectMake(0,0,44,44);
        }
     //   cell!.backgroundColor = UIColor.clearColor();
//        
//        cell!.imageView!.image = UIImage(named:text!);
//
//        cell!.textLabel!.text = text;
//        cell!.textLabel!.textColor =  UIColor.whiteColor().colorWithAlphaComponent(1.0);
        return cell!;
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        
        // Pass the selected object to the new view controller.
        if ( segue.isKindOfClass(SWRevealViewControllerSeguePushController)) {
            let cell = sender as! UITableViewCell;
            let indexPath = tableView.indexPathForCell(cell);
            
            var destination  = segue.destinationViewController;
            if destination.isKindOfClass(SWRevealViewController) {
                let childRevealController : SWRevealViewController = destination as! SWRevealViewController;
                childRevealController.rearViewRevealWidth = 60;
                childRevealController.rearViewRevealOverdraw = 120;
                childRevealController.bounceBackOnOverdraw = false;
                childRevealController.stableDragOnOverdraw = true;
   
                childRevealController.rearViewRevealDisplacement = 0;
            }
        }
        
    }
    

}
