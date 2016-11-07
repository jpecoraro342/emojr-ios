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
        refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshData), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    let networkFacade = NetworkFacade()
    let followManager = FollowUserManager()
    
    var tableDataSource: TimelineTableViewDataSource = TimelineTableViewDataSource()
    
    var userData: UserData? = User.sharedInstance.userData

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.delegate = tableDataSource
        timelineTableView.dataSource = tableDataSource
        timelineTableView.addSubview(refreshControl)
        
        navigationItem.title = userData?.username
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 32)]
        
        updateFollowButton()
        
        refreshData()
    }
    
    func updateFollowButton() {
        if userData?.id != User.sharedInstance.id {
            if User.sharedInstance.following[userData!.id!] == true {
                let unfollowButton = UIBarButtonItem(title: "Unfollow", style: .plain, target: self, action: #selector(UserTimelineViewController.stopFollowingUser))
                navigationItem.rightBarButtonItem = unfollowButton
            }
            else {
                let followButton = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(UserTimelineViewController.followUser))
                navigationItem.rightBarButtonItem = followButton
            }
        }
    }
    
    func followUser() {
        followManager.askToFollowUser(userData!, presentingViewController: self, completionBlock: { (success) in
            if (success) {
                User.sharedInstance.startFollowing(self.userData!.id!)
                self.updateFollowButton()
            }
            else {
                // TODO:
                print("could not stop follow user")
            }
        })
    }
    
    func stopFollowingUser() {
        followManager.askToStopFollowingUser(userData!, presentingViewController: self, completionBlock: { (success) in
            if (success) {
                User.sharedInstance.stopFollowing(self.userData!.id!)
                print("Successfully unfollowed user")
                self.updateFollowButton()
            }
            else {
                // TODO:
                print("could not stop following user")
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
    func cellSelectedInTable(_ tableView: UITableView, indexPath: IndexPath) {
        //reactToPostWithId(tableDataSource.posts[indexPath.row].id, index: indexPath)
        timelineTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadingCellDisplayed(_ cell: LoadingTableViewCell) {
        // TODO: Handle htis
    }
    
    func shouldShowLoadingCell() -> Bool {
        //TODO: Make this true and hangle loading cell
        return false
    }
}

extension UserTimelineViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
