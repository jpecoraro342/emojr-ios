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
        
        self.navigationItem.title = "Followers"
    }

    override func refreshData() {
        super.refreshData()
        
        networkFacade.getAllFollowers(User.sharedInstance.id!, completionBlock: { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                self.allUsers = list!
                
                self.followingTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        });
    }
}
