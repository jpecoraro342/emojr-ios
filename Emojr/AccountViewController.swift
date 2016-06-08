//
//  AccountViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 4/21/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        self.usernameLabel.text = User.sharedInstance.username
    }
    
    @IBAction func myFeedButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier(AccountToUserTimeline, sender: self)
    }
    
    @IBAction func addUsersButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func followingButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier(AccountToFollowing, sender: self)
    }
    
    @IBAction func myFollowersButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier(AccountToFollower, sender: self)
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        User.sharedInstance.logout()
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AccountViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
