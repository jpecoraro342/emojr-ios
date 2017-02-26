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
    @IBOutlet weak var settingsButtonStack: UIStackView!
    @IBOutlet weak var settingsButton: UIButton!
    
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
        let alert = UIAlertController(title: "Are you sure you want to log out?",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in }
        
        alert.addAction(cancel)
        
        let login = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
            LoginManager().logout()
        }
        
        alert.addAction(login)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonTapped(_ sender: AnyObject) {
        for view in settingsButtonStack.arrangedSubviews {
            if view !== settingsButton {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    view.isHidden = !view.isHidden
                }, completion: nil)
            }
        }
    }
}
