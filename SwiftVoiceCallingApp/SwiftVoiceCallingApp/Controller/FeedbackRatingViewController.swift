//
//  FeedbackRatingViewController.swift
//  SwiftVoiceCallingApp
//
//  Created by Rahul Dhek on 14/07/19.
//  Copyright © 2019 Plivo. All rights reserved.
//

import UIKit

import CallKit
import AVFoundation
import PlivoVoiceKit
import ReachabilitySwift

class FeedbackRatingViewController: UIViewController , PlivoEndpointDelegate{
    var viewController: ContactsViewController?
    
    
    @IBOutlet var rating: [UIButton]!
    var starRating=0;
    @IBAction func ontap(_ sender: UIButton) {
        self.starRating=sender.tag+1
        let tag = sender.tag
        for button in rating{
            if button.tag<=tag{
                button.setTitle("♦︎", for: .normal)
            }else{
                button.setTitle("♢", for: .normal)
            }
        }
//        if (sender.tag == 4){
//            fiveStarHiddenView.isHidden = true
//        }
//        else{
//            fiveStarHiddenView.isHidden = false
//        }
    }
    @IBAction func onSkipTapped(_ sender: Any) {
        let _mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let _appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        let tabbarControler: UITabBarController? = _mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController") as? UITabBarController
        let plivoVC: PlivoCallController? = (tabbarControler?.viewControllers?[2] as? PlivoCallController)
        Phone.sharedInstance.setDelegate(plivoVC!)
        tabbarControler?.selectedViewController = tabbarControler?.viewControllers?[1]
        _appDelegate?.window?.rootViewController = tabbarControler
    }
    @IBAction func onSubmitTapped(_ sender: Any) {
        
        var validationMessage = ""
        let issueList = [AnyObject]()
        var validationFlag = false
        self.starRating = 1
        if (self.starRating==0){
            validationFlag = true
            validationMessage = "Rating cannot be empty"
        }
        
        if (validationFlag){
            let alert = UIAlertController(title: "Validation", message: validationMessage , preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            Phone.sharedInstance.submitFeedback(starRating: self.starRating, issueList: issueList, notes : "sadasd", sendConsoleLog : true)
            let _mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let _appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
            let tabbarControler: UITabBarController? = _mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController") as? UITabBarController
            let plivoVC: PlivoCallController? = (tabbarControler?.viewControllers?[2] as? PlivoCallController)
            Phone.sharedInstance.setDelegate(plivoVC!)
            tabbarControler?.selectedViewController = tabbarControler?.viewControllers?[1]
            _appDelegate?.window?.rootViewController = tabbarControler
        }
    }
}
