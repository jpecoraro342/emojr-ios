//
//  UserTimelineViewController.swift
//  Emojr
//
//  Created by James on 4/6/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class UserTimelineViewController: TimelineViewController {
    
    var user: UserData?
    
    override var noDataMessage: String {
        if user == nil {
            return "There aren't any posts here! Looks like you haven't posted anything yet!"
        } else {
            return "This user doesn't have any posts! Tell them to get postin'!"
        }
    }
    
    override func refreshData() {
        super.refreshData()
        
        networkFacade.getAllPostsFromUser(user?.id ?? User.sharedInstance.id!, completionBlock: self.handlePostResponse)
    }
    
    override func rightBarButtonItem() -> UIBarButtonItem? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = user?.username ?? User.sharedInstance.username!
    }
}
