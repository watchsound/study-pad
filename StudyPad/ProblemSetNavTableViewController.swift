//
//  ProblemSetNavTableViewController.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/29/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import UIKit

class ProblemSetNavTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bookmarkedButton: UIButton!
    @IBOutlet weak var notedButton: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    
  
   // var learningUnitDict :Dictionary<String, [LearningUnit]> = [:]
    //var groupsInOrder : [String] = []
    var chapterList : [Chapter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor =  UIColor(white: 1.0, alpha: 1.0);
        
        var  revealController : SWRevealViewController  = self.revealViewController();
        
        
        revealController.rearViewRevealWidth = 60;
        revealController.rearViewRevealOverdraw = 280;
         revealController.bounceBackOnOverdraw = false;
        revealController.stableDragOnOverdraw = true;
        
        
        var  grandParentRevealController : SWRevealViewController  = revealController.revealViewController();
        
        
        self.view.addGestureRecognizer(grandParentRevealController.panGestureRecognizer())
       //
        revealController.setFrontViewPosition(FrontViewPosition.RightMost, animated:true);
        
        
        refreshLearningUnits()
    }

    @IBAction func bookmarkClicked(sender: AnyObject) {
         bookmarkedButton.selected = !bookmarkedButton.selected
         refreshLearningUnits()
    }
    
    
    @IBAction func notesClicked(sender: AnyObject) {
        notedButton.selected = !notedButton.selected
        refreshLearningUnits()
    }
    
    func refreshLearningUnits() {
        let bookmarked = bookmarkedButton.selected
        let noted = notedButton.selected
    //    learningUnitDict.removeAll( )
    //    groupsInOrder.removeAll()
        chapterList.removeAll(keepCapacity: true)
        var totalUnits : [LearningUnit] = R9DBConnectionManager.shared.populateLearningUnitsFromDatabase() as! [LearningUnit]
        var learningUnitList : [LearningUnit] = totalUnits.filter{
            if let s = $0 as? LearningUnit {
                if bookmarked && noted {
                    return s.bookmarked > 0 &&  count(s.notes) > 0
                } else if bookmarked {
                    return s.bookmarked > 0
                } else if noted {
                    return count(s.notes) > 0
                } else {
                    return true;
                }
            } else {
                return false              // this object is of the wrong type, return false.
            }
        }
        var chapterNumber2group : Dictionary<Int, String> = [:]
        for unit in learningUnitList {
            var chapter : Chapter? = nil
            var aChapter : Chapter? = nil
            for aChapter in chapterList {
                if  aChapter.chapterName == unit.chapter {
                    chapter = aChapter;
                    break;
                }
            }
            if  (chapter  == nil) {
                chapter =  Chapter();
                chapter?.chapterName = unit.chapter
                chapter?.chapterOrder = unit.chapterNumber
                chapterList.append(chapter!)
            }
            chapter?.learningUnit.append(unit)
//            
//            chapterNumber2group[unit.chapterNumber] = unit.chapter
//            var list : [LearningUnit]? = learningUnitDict[ unit.chapter ]
//            if ( list == nil ){
//                learningUnitDict[ unit.chapter ] = []
//            }
//            learningUnitDict[ unit.chapter ]?.append(unit)
        }
        var aChapter : Chapter? = nil
        for aChapter in chapterList {
             sort( &aChapter.learningUnit,
                {(s1:LearningUnit , s2:LearningUnit) -> Bool in s1.inChapterNumber < s2.inChapterNumber })
        }
        
        sort( &chapterList,
            {(s1:Chapter , s2:Chapter) -> Bool in s1.chapterOrder < s2.chapterOrder })
        
//        var keys : [Int] = []
//        for v in chapterNumber2group.keys  {
//            keys.append( v )
//        }
//        keys.sort{$0 < $1}
//        
//        for v in keys {
//            groupsInOrder.append( chapterNumber2group[v]! )
//        }
//        
        
        tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

      func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       //  return learningUnitDict.count
         return chapterList.count
    }

      func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // var group = groupsInOrder[section]
       //  return learningUnitDict[group]!.count
         return chapterList[section].learningUnit.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      //  return  groupsInOrder[section]
        return chapterList[section].chapterName
    }
    
    
    
      func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let revealController : SWRevealViewController = self.revealViewController();
        var CellIdentifier : String = "problemsetMenuItemCellId";
        
       var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as? UITableViewCell
      // var cell = tableView.dequeueReusableCellWithIdentifier( CellIdentifier)
       
        var imageView : UIImageView = cell?.viewWithTag(9901) as! UIImageView
        var titleLabel : UILabel = cell?.viewWithTag(9902) as! UILabel
        var conceptLabel : UILabel = cell?.viewWithTag(9903) as! UILabel
        var detailLabel : UILabel = cell?.viewWithTag(9904) as! UILabel
        var bookmarkView : UIImageView = cell?.viewWithTag(9905) as! UIImageView
        var noteView : UIImageView = cell?.viewWithTag(9906) as! UIImageView
        var levelLabel : UILabel = cell?.viewWithTag(9907) as! UILabel
        
        var maskView : UIView? = cell?.viewWithTag(9910)
        
        
        
    //    let sectionData : [LearningUnit]  =  learningUnitDict[ groupsInOrder[indexPath.section] ]!
        var learningUnit : LearningUnit = chapterList[indexPath.section].learningUnit[indexPath.row]
       // sectionData[ indexPath.row ]
        var studyPoint : StudyPoint = learningUnit.studyPoints[0]
       
        
        var image : UIImage? =  DataManager.shared.loadImageIconForLearningUnit(learningUnit.folderName)
        if  image != nil  {
            imageView.image  = image
        } else {
             var text :FontAwesome? = FontAwesome.Question;
             imageView.image  = UIImage.fontAwesomeIconWithName(text!, textColor: UIColor(white: 0.0, alpha: 1.0), size: CGSizeMake(24, 24));
        }
        titleLabel.text =  learningUnit.name
        conceptLabel.text = studyPoint.description()
        levelLabel.text =  "\(studyPoint.difficultLevel)"
        detailLabel.text = learningUnit.description
        
        let hasPermisson = R9Properties.shared.checkPermission(learningUnit)
        if hasPermisson {
            maskView!.alpha = 0
        } else {
            maskView!.alpha = 0.5
        }
        
        
        if ( learningUnit.bookmarked == 0 ){
           bookmarkView.hidden = true
        } else {
            bookmarkView.hidden = false
            bookmarkView.image  = UIImage.fontAwesomeIconWithName(FontAwesome.BookmarkO, textColor: UIColor(white: 0.0, alpha: 1.0), size: CGSizeMake(24, 24));
        }
        
        
        if ( count( learningUnit.notes ) == 0 ){
            noteView.hidden = true
        } else {
            noteView.hidden = false
            noteView.image  = UIImage.fontAwesomeIconWithName(FontAwesome.Pencil, textColor: UIColor(white: 0.0, alpha: 1.0), size: CGSizeMake(24, 24));
        }
        
       // cell!.imageView!.frame = CGRectMake(0,0,44,44);
        //cell?.textLabel?.text =  learningUnit.name + " Level: " + studyPoint.description()
        //cell?.detailTextLabel?.text = learningUnit.description
        
        return cell!;
    }
    
//      func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var header : UIView = UIView();
//        
//    }
    


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
 
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        var destViewController :AnyObject =  segue.destinationViewController
        if  destViewController .isKindOfClass(UINavigationController ) {
            var  navController : UINavigationController = destViewController as! UINavigationController
            var cvc : ProblemViewController = navController.childViewControllers.first as! ProblemViewController ;
            if  (sender?.isKindOfClass(UITableViewCell) != nil) {
                var cell : UITableViewCell = sender as! UITableViewCell
                let indexPath : NSIndexPath = tableview.indexPathForCell(cell)!
              //  let sectionData : [LearningUnit]  =  learningUnitDict[ groupsInOrder[indexPath.section] ]!
                var selected : LearningUnit = chapterList[indexPath.section].learningUnit[indexPath.row]
                //LearningUni t = sectionData[ indexPath.row ]
                cvc.loadLearningUnit( selected )
            }
        }
    }
    

}
