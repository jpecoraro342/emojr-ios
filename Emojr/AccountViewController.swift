//
//  AccountViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 4/21/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

extension UILabel {
    func setLineHeight(height: CGFloat) {
        let text = self.text
        if let text = text {
            let string = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = height
            
            string.addAttribute(NSAttributedStringKey.paragraphStyle,
                                value: style,
                                range: NSRange(location: 0, length: text.characters.count))
            
            self.attributedText = string
        }
    }
}

class AccountViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var feedContainerView: UIView!
    @IBOutlet weak var settingsButtonView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var myFeedViewController: TimelineViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Account"
        
        myFeedViewController = TimelineViewController(with: .user(user: User.sharedInstance.userData))
        
        self.usernameLabel.text = User.sharedInstance.username
        
        addChildViewController(myFeedViewController!)
        myFeedViewController!.didMove(toParentViewController: self)
        
        feedContainerView.addSubview(myFeedViewController!.view)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        myFeedViewController?.view.frame = feedContainerView.bounds
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
}
