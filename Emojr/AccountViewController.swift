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
        super.viewDidLoad()
        
        self.navigationItem.title = "Account"
        
        self.usernameLabel.text = User.sharedInstance.username
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func myFeedButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier(AccountToUserTimeline, sender: self)
    }
    
    @IBAction func addUsersButtonTapped(sender: AnyObject) {
        let addUserVC = AddUsersViewController()
        self.navigationController?.pushViewController(addUserVC, animated: true)
    }
    
    @IBAction func followingButtonTapped(sender: AnyObject) {
        let followingVC = FollowingViewController()
        self.navigationController?.pushViewController(followingVC, animated: true)
    }
    
    @IBAction func myFollowersButtonTapped(sender: AnyObject) {
        let followerVC = FollowerViewController()
        self.navigationController?.pushViewController(followerVC, animated: true)
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
