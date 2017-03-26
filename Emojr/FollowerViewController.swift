//
//  FollowingViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class FollowerViewController: UserListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Followers"
        noDataMessage = "No followers yet!"
    }

    override func refreshData() {
        refreshControl.beginRefreshing()
        
        networkFacade.getAllFollowers(User.sharedInstance.id!, completionBlock: userResponseHandler)
    }
}
