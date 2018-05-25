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
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.title = "Followers"
        noDataMessage = "No followers yet!"
    }

    override func refreshData() {
        networkFacade.getAllFollowers(User.sharedInstance.id!, completionBlock: userResponseHandler)
    }
}
