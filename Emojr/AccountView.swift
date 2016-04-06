//
//  AccountView.swift
//  Emojr
//
//  Created by James on 3/26/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class AccountView: UIView {
    
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var emoteButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var transitionLabel: UILabel!
    
    var controller: TimelineViewController?;
    
    class func instanceFromNib() -> AccountView {
        return UINib(nibName: "AccountView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AccountView
    }
    
    func configureWithController(controller: TimelineViewController) {        
        self.controller = controller
        usernameLabel.text = User.sharedInstance.username
    }
    
    @IBAction func myFeed(sender: AnyObject) {
        controller?.performSegueWithIdentifier("accountToUserTimeline", sender: self)
    }

    @IBAction func myFolowers(sender: AnyObject) {
        controller?.performSegueWithIdentifier("accountToFollowers", sender: self)
    }
    
    @IBAction func followPeople(sender: AnyObject) {
        controller?.performSegueWithIdentifier("accountToFollowing", sender: self)
    }
    
    @IBAction func logout(sender: AnyObject) {
        controller?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func accountButtonTouched() {
        controller!.displayAccount()
        UIView.animateWithDuration(0.5) {
            self.accountButton.alpha = 0.0
            self.emoteButton.alpha = 0.0
            self.closeButton.alpha = 1.0
        }
        transitionLabel.text = "Timeline"
    }
    
    @IBAction func closeButtonTouched() {
        controller!.dismissAccount()
        
        UIView.animateWithDuration(0.5) {
            self.accountButton.alpha = 1.0
            self.emoteButton.alpha = 1.0
            self.closeButton.alpha = 0.0
        }
        transitionLabel.text = "Account"
    }
    
    @IBAction func emoteButtonTouched() {
        controller!.displayPostForm(false)
    }
}
