//
//  MeViewController.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/29/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import UIKit

class MeViewController:  UIViewController, UIWebViewDelegate{
     
     
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var menuButton: UIButton!
    
    var isRequestWeb : Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRequestWeb = true
        webview.opaque = false
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
    
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
     
    
    if isRequestWeb {
        
        var response:NSURLResponse?
        var error:NSError?
        var data = NSURLConnection.sendSynchronousRequest(request,returningResponse:&response,error:&error) as NSData?
        
        let returnCode : Int = 200
        
        let httpResponse = response as! NSHTTPURLResponse
        let code = httpResponse.statusCode
        
        if error == nil && data?.length > 0{
            if  code != returnCode {
                    return false;
            }
            webview.loadData(data, MIMEType : "text/html", textEncodingName: nil, baseURL : request.URL )
            
        } else {
            return false
        }
       
        isRequestWeb = false;
        return false;
    }
    
      return true;
    }
    
    
    func customSetup()
    {
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside);
            
            //    menuButton.tar = self.revealViewController()
            //  menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
       
         //   var url  : String =  "http://www.remember9.com/products/ipad-productions.html" //"http://www.sina.com" //
            var url  : String =  "http://www.pebook.cn/"
            var request : NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
            webview.loadRequest(request)
       
    }
    
    
    
}
