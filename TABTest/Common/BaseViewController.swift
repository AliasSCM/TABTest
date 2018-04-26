//
//  BaseViewController.swift
//  TABTest
//
//  Created by master on 4/26/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

/// Base View controller class using which all other view controllesr should override from.
/// - important: This class
/// + Handles error and alert display
/// + Handles loading indicators.
class BaseViewController: UIViewController {
   /// activity indicator view to sow a loadign indicator
    var activityIndicator : UIActivityIndicatorView?
    /// label to indicate message of acitvity indicatpor
    var strLabel : UILabel?
    /// Visual effect view that has contains the loading indicator
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Show alert and loading methods
    
    /// Method to show alert
    /// - parameter title : Title of the alert
    /// - parameter descrip : Description of the alert
    func showAlert(title : String , descrip : String)
    {
        let alert = UIAlertController(title: title, message: descrip, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
    }
    /// Method to show loading indicator
    /// - parameter title : Title when loading indicator is shown
    func showActivityIndicator(_ title: String)
    {
        
       self.removeActivityIndicator()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel?.text = title
        strLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel?.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - (strLabel?.frame.width)!/2, y: view.frame.midY - (strLabel?.frame.height)!/2 , width: 160, height: 46)
        effectView.backgroundColor = UIColor.red
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator?.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator?.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator!)
        effectView.contentView.addSubview(strLabel!)
        self.view.addSubview(effectView)
    }
    /// Method to remove lodaing indicator from screen
    func removeActivityIndicator()
    {
        if(activityIndicator != nil && activityIndicator?.superview != nil){
            strLabel?.removeFromSuperview()
            activityIndicator?.removeFromSuperview()
            effectView.removeFromSuperview()
           }
    }
}
