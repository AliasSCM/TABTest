//
//  WebKitViewController.swift
//  TABTest
//
//  Created by master on 4/26/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit
import WebKit

/// ViewController class that has a web view to load URLs to display
class WebKitViewController: BaseViewController , WKUIDelegate {
    /// webview instance of WKWebView
    var webView: WKWebView!
    /// URL of the page to open
    var url : URL!
    // MARK: Actions & Outlets
    
    ///Outlet for close button
    @IBOutlet var closeButton: UIButton!
    /// Action method when close is pressed. Hooked up to touchupinside
    @IBAction func closeButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    /// Class method to create an instance of this view Controller
    class func createInstance() -> WebKitViewController
    {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebKitViewController
        
        return vc
    }
    //MARK: ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect.init(x : 0 , y : 52 , width : self.view.frame.size.width , height : self.view.frame.size.height -  52), configuration: webConfiguration)
        webView.uiDelegate = self
        self.view.addSubview(webView)
        
        let request = URLRequest(url:url!)
        webView.load(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
