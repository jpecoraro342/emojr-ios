//
//  FollowingViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class FollowingViewController: UserListViewController {
    override func refreshData() {
        followingUsers = User.sharedInstance.following
        
        networkFacade.getAllFollowing(User.sharedInstance.id!) { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                self.allUsers = list!
                
                self.followingTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

