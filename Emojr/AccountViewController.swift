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
    @IBOutlet weak var feedContainerView: UIView!
    
    var myFeedViewController: TimelineViewController = TimelineViewController(with: .user(user: nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Account"
        
        self.usernameLabel.text = User.sharedInstance.username
        
        addChildViewController(myFeedViewController)
        myFeedViewController.didMove(toParentViewController: self)
        
        feedContainerView.addSubview(myFeedViewController.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        myFeedViewController.view.frame = feedContainerView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
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
