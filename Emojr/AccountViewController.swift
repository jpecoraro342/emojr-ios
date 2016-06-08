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
        let addUserVC = UserListViewController()
        self.navigationController?.pushViewController(addUserVC, animated: true)
    }
    
    @IBAction func followingButtonTapped(sender: AnyObject) {
        let followingVC = FollowingViewController()
        self.navigationController?.pushViewController(followingVC, animated: true)
        // performSegueWithIdentifier(AccountToFollowing, sender: self)
    }
    
    @IBAction func myFollowersButtonTapped(sender: AnyObject) {
        let followerVC = FollowerViewController()
        self.navigationController?.pushViewController(followerVC, animated: true)
        // performSegueWithIdentifier(AccountToFollower, sender: self)
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
