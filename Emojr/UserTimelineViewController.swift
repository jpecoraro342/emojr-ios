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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    let networkFacade = NetworkFacade()
    let followManager = FollowUserManager()
    
    var tableDataSource: TimelineTableViewDataSource = TimelineTableViewDataSource()
    
    var userData: UserData? = User.sharedInstance.userData
    
    var isFollowing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.delegate = tableDataSource
        timelineTableView.dataSource = tableDataSource
        timelineTableView.addSubview(refreshControl)
        
        navigationItem.title = userData?.username
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(32)]
        
        if userData?.id != User.sharedInstance.id {
            if (isFollowing) {
                
            }
            else {
                let followButton = UIBarButtonItem(title: "👀", style: .Plain, target: self, action: #selector(UserTimelineViewController.followUser))
                navigationItem.rightBarButtonItem = followButton
            }
        }
        
        refreshData()
    }
    
    func followUser() {
        followManager.askToFollowUser(userData!, presentingViewController: self, completionBlock: { (success) in
            if (success) {
                
            }
            else {
                
            }
        })
    }
    
    func stopFollowingUser() {
        
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
        guard let user = userData
            else { return }
        
        guard let userId = user.id
            else { return }
                
        networkFacade.getAllPostsFromUser(userId) { (error, list) in
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
