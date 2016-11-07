//
//  HomeTimelineViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/9/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class HomeTimelineViewController: TimelineViewController {
    override func refreshData() {
        super.refreshData()
        
        networkFacade.getAllFollowingPosts(User.sharedInstance.id!) { [weak self](error, list) in
            guard let posts = list
                else {return }
            
            if let strongSelf = self {
                strongSelf.tableDataSource.configureWithPosts(posts, delegate: self)
                strongSelf.timelineTableView.reloadData()
                strongSelf.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Home"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func rightBarButtonItem() -> UIBarButtonItem? {
        let postButton = UIBarButtonItem(title: "📝   ", style: .plain, target: self, action: #selector(postButtonTapped))
        postButton.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 32)], for: UIControlState())
        
        return postButton
    }
}
