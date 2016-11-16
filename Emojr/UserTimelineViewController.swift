//
//  UserTimelineViewController.swift
//  Emojr
//
//  Created by James on 4/6/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class UserTimelineViewController: TimelineViewController {
    
    let followManager = FollowUserManager()
    
    var userData: UserData? = User.sharedInstance.userData
    
    override var noDataMessage: String {
        return "There aren't any posts here! Looks like you haven't posted anything yet, try tapping the 📝 button!"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFollowButton()
    }
    
    func updateFollowButton() {
        if userData?.id != User.sharedInstance.id {
            if User.sharedInstance.following[userData!.id!] == true {
                let unfollowButton = UIBarButtonItem(title: "Unfollow", style: .plain, target: self, action: #selector(UserTimelineViewController.stopFollowingUser))
                navigationItem.rightBarButtonItem = unfollowButton
            }
            else {
                let followButton = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(UserTimelineViewController.followUser))
                navigationItem.rightBarButtonItem = followButton
            }
        }
    }
    
    func followUser() {
        followManager.askToFollowUser(userData!, presentingViewController: self, completionBlock: { (success) in
            if (success) {
                User.sharedInstance.startFollowing(self.userData!.id!)
                self.updateFollowButton()
            }
            else {
                // TODO:
                print("could not stop follow user")
            }
        })
    }
    
    func stopFollowingUser() {
        followManager.askToStopFollowingUser(userData!, presentingViewController: self, completionBlock: { (success) in
            if (success) {
                User.sharedInstance.stopFollowing(self.userData!.id!)
                print("Successfully unfollowed user")
                self.updateFollowButton()
            }
            else {
                // TODO:
                print("could not stop following user")
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = userData?.username
        
        refreshData()
    }
    
    override func refreshData() {
        super.refreshData()
        
        networkFacade.getAllPostsFromUser(User.sharedInstance.id!) { [weak self] (error, list) in
            guard let posts = list
                else { return }
            
            if let strongSelf = self {
                strongSelf.tableDataSource.configureWithPosts(posts, delegate: self)
                strongSelf.timelineTableView.reloadData()
                strongSelf.refreshControl.endRefreshing()
                
                if posts.count == 0 {
                    strongSelf.displayNoDataView()
                } else {
                    strongSelf.removeNoDataView()
                }
            }
        }
    }
}

extension UserTimelineViewController /*TimelineTableViewDelegate*/ {
    override func cellSelectedInTable(_ tableView: UITableView, indexPath: IndexPath) {
        timelineTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserTimelineViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
