//
//  FollowingViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class FollowingViewController: UserListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Following"
        noDataMessage = "You're not following anyone yet!"
    }
    
    override func refreshData() {
        refreshControl.beginRefreshing()
        
        networkFacade.getAllFollowing(User.sharedInstance.id!, completionBlock: userResponseHandler)
    }
}

