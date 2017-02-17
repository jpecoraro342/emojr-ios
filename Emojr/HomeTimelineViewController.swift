//
//  HomeTimelineViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/9/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class HomeTimelineViewController: TimelineViewController {
    
    override var noDataMessage: String {
        return "There aren't any posts here! Try following some more users to see their posts!"
    }
    
    override func refreshData() {
        super.refreshData()
        
        networkFacade.getAllFollowingPosts(User.sharedInstance.id!, completionBlock: self.handlePostResponse)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Home"
    }
}
