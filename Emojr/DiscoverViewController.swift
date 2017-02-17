//
//  DiscoverViewController.swift
//  Emojr
//
//  Created by Joseph on 6/7/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class DiscoverViewController: TimelineViewController {
    
    private lazy var searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "🔎", style: .plain, target: self, action: #selector(searchButtonTapped))
        button.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 32)], for: UIControlState())
        
        return button
    }()
    
    override var noDataMessage: String {
        return "There aren't any posts here! Check you connection and hope more users show up soon!"
    }
    
    override func refreshData() {
        super.refreshData()
        
        networkFacade.getDiscoverPosts(completionBlock: self.handlePostResponse)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = searchButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Discover"
    }
    
    // MARK: - Action
    
    func searchButtonTapped(sender: UIBarButtonItem) {
        if User.sharedInstance.isLoggedIn {
            let addUserVC = AddUsersViewController()
            self.navigationController?.pushViewController(addUserVC, animated: true)
        }
    }
}
