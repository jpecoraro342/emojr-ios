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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshData() {
        super.refreshData()
        
        networkFacade.getDiscoverPosts() { [weak self] (error, list) in
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
        
        refreshData()
    }
}
