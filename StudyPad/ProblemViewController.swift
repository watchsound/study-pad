//
//  HelpViewController.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/29/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import UIKit
import StoreKit

 class ProblemViewController:  UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate, UIAlertViewDelegate{
    
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var menuButton: UIButton!
    
   
    var _learningUnit: LearningUnit?;
    var notesButton : FFRedAndWhiteButton = FFRedAndWhiteButton()
    var notesButtonItem : UIBarButtonItem?
    var bookmarkButton : FFRedAndWhiteButton = FFRedAndWhiteButton()
    var detailButtonItem : UIBarButtonItem?
    
    var scratchButton : FFRedAndWhiteButton = FFRedAndWhiteButton()
    var scratchButtonItem : UIBarButtonItem?
    
    var waitingDialog : UIAlertView?
    
    var scratchView : ScratchViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        customSetup();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self as! SKPaymentTransactionObserver)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
         super.viewWillDisappear(animated)
         SKPaymentQueue.defaultQueue().removeTransactionObserver(self as! SKPaymentTransactionObserver)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bookmarkClicked(sender: AnyObject) {
        if (  _learningUnit   != nil){
            if ( _learningUnit?.bookmarked == 0 ){
                 R9DBConnectionManager.shared.bookmarkLearningUnit( _learningUnit!, bookmarkIt: true )
                //TODO - there is a bug in iToast... it shows wrong orientation for landscape
                // iToast.makeText("Successfully bookmarked").show()
                bookmarkButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                bookmarkButton.setTitle("Unmark", forState: UIControlState.Normal)
            } else {
                 R9DBConnectionManager.shared.bookmarkLearningUnit( _learningUnit!, bookmarkIt: false )
                //  iToast.makeText("Bookmark removed.").show()
                bookmarkButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                bookmarkButton.setTitle("Bookmark", forState: UIControlState.Normal)
            }
        }
    }
    
    func noteClicked(sender: AnyObject) {
        if (  _learningUnit   != nil){
            
            let vc = storyboard?.instantiateViewControllerWithIdentifier("NoteEditorViewController") as! NoteEditorViewController
            vc.setLearningUnit(self._learningUnit!)
            
            var popover  = UIPopoverController(contentViewController: vc)
            vc.popover = popover
            
            popover.presentPopoverFromBarButtonItem(notesButtonItem!, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)  
        }
    }
    
    func detailClicked(sender: AnyObject) {
        if (  _learningUnit   != nil){
            
            let vc = storyboard?.instantiateViewControllerWithIdentifier("LearningUnitDetailViewController") as! LearningUnitDetailViewController
            vc.setLearningUnit(self._learningUnit!) 
            
            var popover  = UIPopoverController(contentViewController: vc)
           
            popover.presentPopoverFromBarButtonItem(detailButtonItem!, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: false)
        }
    }
    
    
    func scratchClicked(sender: AnyObject) {
        if (  _learningUnit   != nil){
            
            if ( scratchView == nil ){
               scratchView = storyboard?.instantiateViewControllerWithIdentifier("ScratchViewController") as! ScratchViewController
            
               scratchView!.preferredContentSize = CGSizeMake(900, 700)
            }
            
            var popover  = UIPopoverController(contentViewController: scratchView!)
            
            popover.presentPopoverFromBarButtonItem(scratchButtonItem!, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
        }
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
        
        addRightBarButtonItems();
        
        if (_learningUnit != nil) {
            loadWebview( _learningUnit! );
        } else {
            var unitId : Int64 = R9Properties.shared.getLastAccess()
            if ( unitId < 0 ){
                unitId = 0
            }
            //if ( unitId >= 0 ){
                if let unit = R9DBConnectionManager.shared.getLearingUnitById(unitId) {
                    _learningUnit = unit
                    loadWebview( _learningUnit! );
                }
           // }
        }
    }
    
    func addRightBarButtonItems() {
        bookmarkButton = FFRedAndWhiteButton(frame: CGRectMake(0, 0, 100, 30))
        bookmarkButton.imageView!.image = UIImage(named: "reveal-icon")
        bookmarkButton.addTarget(self, action: "bookmarkClicked:", forControlEvents: .TouchUpInside)
        bookmarkButton.setTitle("Bookmark", forState: UIControlState.Normal)
        
        var bookmarkButtonItem : UIBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
        
        var fixedItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        
        
        notesButton  = FFRedAndWhiteButton(frame: CGRectMake(0, 0, 80, 30))
        notesButton.imageView!.image = UIImage(named: "reveal-icon")
        notesButton .addTarget(self, action: "noteClicked:", forControlEvents: .TouchUpInside)
        notesButton .setTitle("Note", forState: UIControlState.Normal)
        
        notesButtonItem = UIBarButtonItem(customView: notesButton )
        
        var fixedItem2 : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        
        
        var detailButton  = FFRedAndWhiteButton(frame: CGRectMake(0, 0, 80, 30))
        detailButton.imageView!.image = UIImage(named: "reveal-icon")
        detailButton .addTarget(self, action: "detailClicked:", forControlEvents: .TouchUpInside)
        detailButton .setTitle("Detail", forState: UIControlState.Normal)
        
        detailButtonItem = UIBarButtonItem(customView: detailButton )
        
//        self.navigationItem.rightBarButtonItems?.append(bookmarkButtonItem)
//        self.navigationItem.rightBarButtonItems?.append(fixedItem)
//        self.navigationItem.rightBarButtonItems?.append(notesButtonItem)
        
         var fixedItem3 : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        
        scratchButton = FFRedAndWhiteButton(frame: CGRectMake(0, 0, 100, 30))
        scratchButton.imageView!.image = UIImage(named: "reveal-icon")
        scratchButton.addTarget(self, action: "scratchClicked:", forControlEvents: .TouchUpInside)
        scratchButton.setTitle("Scratch", forState: UIControlState.Normal)
        
        scratchButtonItem  = UIBarButtonItem(customView: scratchButton)
        
        
        self.navigationItem.setRightBarButtonItems([bookmarkButtonItem, fixedItem, notesButtonItem!, fixedItem2, detailButtonItem!, fixedItem3, scratchButtonItem!], animated: false)
        
    }
    
    func hideWaitingDialog(){
        if waitingDialog != nil {
            let indicator : UIActivityIndicatorView = waitingDialog?.viewWithTag(8899) as! UIActivityIndicatorView
            indicator.stopAnimating()
            waitingDialog?.hidden = true
        }
    }
    
    func showWaitingDialog(){
        hideWaitingDialog()
        
        waitingDialog = UIAlertView(title: "Please wait", message: "", delegate: nil, cancelButtonTitle: nil)
        waitingDialog?.show()
        let aiv : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        
       
        aiv.center = CGPointMake(waitingDialog!.bounds.size.width / 2.0, waitingDialog!.bounds.size.height - 40.0);
        aiv.tag = 8899
        aiv.startAnimating();
        waitingDialog!.addSubview(aiv);
        
    }
   
    
     func loadWebview(learningUnit: LearningUnit)   {
        
        //check if 
        let hasPermission = checkPermission(learningUnit)
        if !hasPermission {
            return;
        }
        
        
        
        if count(learningUnit.notes) > 0  {
            notesButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        } else {
            notesButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        
        if  learningUnit.bookmarked > 0   {
            bookmarkButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            bookmarkButton.setTitle("Unmark", forState: UIControlState.Normal)
        } else {
            bookmarkButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            bookmarkButton.setTitle("Bookmark", forState: UIControlState.Normal)
        }
        
        let basePath : String = DataManager.shared.getPathForLearningUnitInAssets( learningUnit.folderName )
        
        var htmlPath :String = basePath.stringByAppendingPathComponent("index.html");
        
        if  NSFileManager.defaultManager().fileExistsAtPath(htmlPath) {
            
        } else {
            htmlPath  = basePath.stringByAppendingPathComponent("index.svg");
        }
        
        //reading
        var err: NSError? = NSError()
        let htmlCont = String(contentsOfFile: htmlPath, encoding: NSUTF8StringEncoding, error: &err)
        // println(htmlCont)
       
        let baseURL :NSURL = NSURL.fileURLWithPath(basePath, isDirectory: true)!
        
        webview.loadHTMLString(htmlCont, baseURL: baseURL);
        
        self.navigationController?.title = learningUnit.name
       // self.navigationController?.navigationBar.titleTextAttributes = [ ]
        
        R9Properties.shared.setLastAccess(learningUnit.unitId)
        R9DBConnectionManager.shared.closeLatestStudyEvent();
        R9DBConnectionManager.shared.markStudyEventStart(learningUnit.name, eventType: 0, learningUnitId: learningUnit.unitId)
    }
    
    func loadLearningUnit(learningUnit: LearningUnit)   {
        _learningUnit = learningUnit;
    }
    
    
    func showMessage(message :String){
        let alerView : UIAlertView = UIAlertView(title: "Alert", message: message, delegate: nil, cancelButtonTitle: "Close")
        
        alerView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if ( buttonIndex == 0 ){
            return;
        }
        
        showWaitingDialog()
         getProductInfo();
    }
    
    
    func checkPermission(learningUnit: LearningUnit) -> Bool {
        let hasPermission = R9Properties.shared.checkPermission(learningUnit)
        
        if ( hasPermission ){
            return true;
        }
        
        if !SKPaymentQueue.canMakePayments() {
            showMessage( "The rest of learning units need one-time payment. Can't make payment. Please check the permisson." )
            return false
        }
        
        //otherButtonTitle
        let alerView : UIAlertView = UIAlertView(title: "Alert", message: Constants.RequirePaymentMessage, delegate: self, cancelButtonTitle: "No", otherButtonTitles:"Yes")
        
        alerView.show()         
        
        return false;
    }
    
    func getProductInfo() {
        var set :NSSet = NSSet(array: [ Constants.ProductId ])
        
        var request = SKProductsRequest(productIdentifiers: set as Set<NSObject>)
        request.delegate = self as! SKProductsRequestDelegate
        request.start()
       
    }
    
    // SKProductsRequestDelegate
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!){
        let myProduct : NSArray = response.products;
        if (myProduct.count == 0) {
              hideWaitingDialog()
             showMessage( "Failed to fetch production information from Apple store.  Please try it later." )
            return;
        }
        var payment : SKPayment = SKPayment(product: myProduct[0] as! SKProduct)
        SKPaymentQueue.defaultQueue().addPayment(payment )
    }
    
    ///MARK - related to IAP
    
    func completeTransaction( transaction : SKPaymentTransaction ) {
    // Your application should implement these two methods.
        let productIdentifier : String = transaction.payment.productIdentifier;
//         if ([productIdentifier length] > 0) {
//          // 向自己的服务器验证购买凭证
//         }
    // Remove the transaction from the payment queue.
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    
    }
    
    func failedTransaction( transaction : SKPaymentTransaction ) {
       if(transaction.error.code != SKErrorPaymentCancelled) {
          // NSLog(@"购买失败");
        showMessage( "Failed to make purchase. Please try it later.")
      } else {
        // NSLog(@"用户取消交易");
         showMessage( "Transaction is cancelled.")
      }
      SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
      func restoreTransaction( transaction : SKPaymentTransaction ) {
    // 对于已购商品，处理恢复购买的逻辑
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
     }
    
    ////MARK - related to IAP SKPaymentTransactionObserver -----
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!){
         hideWaitingDialog()
        
        for value in transactions  {
            var t =  value as! SKPaymentTransaction
            R9Properties.shared.setPaymentStatusEnum(t.transactionState)
            switch (t.transactionState)
            {
            case SKPaymentTransactionState.Purchased: //交易完成
                completeTransaction(t);
                break;
            case SKPaymentTransactionState.Failed://交易失败
                  failedTransaction(t);
                break;
            case SKPaymentTransactionState.Restored://已经购买过该商品
                 restoreTransaction(t);
                break;
            case SKPaymentTransactionState.Purchasing:      //商品添加进列表
                break;
            case SKPaymentTransactionState.Deferred:      //商品添加进列表
                break;
            default:
                break;
            }
        }
        
       
    }
    
    
    
    // Sent when transactions are removed from the queue (via finishTransaction:).
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!){
          hideWaitingDialog()
    }
    
    // Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
    func paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!){
          hideWaitingDialog()
    }
    
    // Sent when all transactions from the user's purchase history have successfully been added back to the queue.
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!){
        hideWaitingDialog()
    }
    
    // Sent when the download state has changed.
    func paymentQueue(queue: SKPaymentQueue!, updatedDownloads downloads: [AnyObject]!){
        hideWaitingDialog()
    }
}
