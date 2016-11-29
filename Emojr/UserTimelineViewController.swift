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
            return "There aren't any posts here! Looks like you haven't posted anything yet, try tapping the 📝 button!"
        } else {
            return "This user doesn't have any posts! Tell them to get postin'!"
        }
    }
    
    override func refreshData() {
        super.refreshData()
        
        networkFacade.getAllPostsFromUser(user?.id ?? User.sharedInstance.id!) { [weak self] (error, list) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
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
        self.navigationItem.title = user?.id ?? User.sharedInstance.username!
    }
}
