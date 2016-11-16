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
        
        networkFacade.getAllFollowingPosts(User.sharedInstance.id!) { [weak self] (error, list) in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Home"
    }
}
