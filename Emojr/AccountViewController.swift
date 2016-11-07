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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func myFeedButtonTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: AccountToUserTimeline, sender: self)
    }
    
    @IBAction func addUsersButtonTapped(_ sender: AnyObject) {
        let addUserVC = AddUsersViewController()
        self.navigationController?.pushViewController(addUserVC, animated: true)
    }
    
    @IBAction func followingButtonTapped(_ sender: AnyObject) {
        let followingVC = FollowingViewController()
        self.navigationController?.pushViewController(followingVC, animated: true)
    }
    
    @IBAction func myFollowersButtonTapped(_ sender: AnyObject) {
        let followerVC = FollowerViewController()
        self.navigationController?.pushViewController(followerVC, animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        LoginManager().logout()
    }
}

extension AccountViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
