//
//  UserTimelineViewController.swift
//  Emojr
//
//  Created by James on 4/6/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController {
    
    @IBOutlet weak var timelineTableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    let networkFacade = NetworkFacade()
    var tableDataSource: TimelineTableViewDataSource = TimelineTableViewDataSource()
    
    var userID: String = User.sharedInstance.id!
    var username: String = User.sharedInstance.username!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.delegate = tableDataSource
        timelineTableView.dataSource = tableDataSource
        timelineTableView.addSubview(refreshControl)
        
        usernameLabel.text = username
        
        refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshData() {
        networkFacade.getAllPostsFromUser(userID) { (error, list) in
            if let posts = list {
                self.tableDataSource.configureWithPosts(posts, delegate: self)
                self.timelineTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension UserTimelineViewController : TimelineTableViewDelegate {
    func cellSelectedInTable(tableView: UITableView, indexPath: NSIndexPath) {
        //reactToPostWithId(tableDataSource.posts[indexPath.row].id, index: indexPath)
        timelineTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension UserTimelineViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
