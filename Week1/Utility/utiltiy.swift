//
//  utiltiy.swift
//  kevin563-Week1
//
//  Created by Kevin Chang on 2015/6/13.
//  Copyright (c) 2015年 Kevin Chang. All rights reserved.
//

import UIKit
import Foundation

class Utility {

    var reachability:Reachability!;
    
    init ()
    {
        self.reachability = Reachability.reachabilityForInternetConnection();
        self.reachability.startNotifier();
    }
    
    // delect Newwork
    func networkStatus (notification: NSNotification, showWin: UIView, msgLabel: UILabel, message: String) {
        let networkReachability = notification.object as! Reachability;
        let networkStatus = networkReachability.currentReachabilityStatus().value
        
        if (networkStatus == NotReachable.value) {
            self.showAlert(showWin, msgLabel: msgLabel, msg: message)
        }
        else {
            self.clearAlert(showWin, msgLabel: msgLabel)
        }
    }
    
    // alert
    func showAlert (viewWindow: UIView, msgLabel: UILabel, msg: String) {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            viewWindow.frame = CGRect(x: 0, y: 0, width: 375, height: 30)
            viewWindow.alpha = 0.9
            msgLabel.hidden = false
            msgLabel.text! = msg
        }, completion: nil)
    }

    func clearAlert(viewWindow: UIView, msgLabel: UILabel) {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            viewWindow.frame = CGRect(x: 0, y: 0, width: 375, height: 0)
            msgLabel.hidden = true
            msgLabel.text! = ""
        }, completion: nil)
    }
}