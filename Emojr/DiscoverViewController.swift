//
//  DiscoverViewController.swift
//  Emojr
//
//  Created by Joseph on 6/7/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class DiscoverViewController: TimelineViewController {
    
    override var noDataMessage: String {
        return "There aren't any posts here! Check you connection and hope more users show up soon!"
    }
    
    override func refreshData() {
        super.refreshData()
        
        networkFacade.getDiscoverPosts() { [weak self] (error, list) in
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
        self.navigationItem.title = "Discover"
    }
}
