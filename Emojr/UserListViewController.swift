//
//  UserListViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/7/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit
import SnapKit

class UserListViewController: UIViewController {
    
    var followingTableView = UITableView()
    
    var allUsers = [UserData]()
    
    var followingUsers = Dictionary<String, Bool>()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    let networkFacade = NetworkFacade()
    let followManager = FollowUserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTableView()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(UserListViewController.navigateToAddBySearch))
        self.navigationItem.rightBarButtonItem = addButton
        
        refreshData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func layoutTableView() {
        view.addSubview(followingTableView)
        
        followingTableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        followingTableView.addSubview(refreshControl)
        
        followingTableView.delegate = self;
        followingTableView.dataSource = self;
        followingTableView.rowHeight = 60;
        followingTableView.registerNib(UINib(nibName: "UserTableViewCell", bundle:nil), forCellReuseIdentifier: UserCellIdentifier)
    }
    
    func refreshData() {
        followingUsers = User.sharedInstance.following
    }
    
    func navigateToAddBySearch() {
        self.navigationController?.pushViewController(AddUsersViewController(), animated: true)
    }
    
    func askToFollowUser(user: UserData) {
        if followingUsers[user.id!] == true {
            // Nothing to do here, already following
        }
        else {
            followManager.askToFollowUser(user, presentingViewController: self, completionBlock: { (success) in
                if (success) {
                    User.sharedInstance.startFollowing(user.id!)
                    self.followingUsers[user.id!] = true;
                    self.followingTableView.reloadData()
                }
                else {
                    print("unable to follow user")
                }
            })
        }
    }
    
    func askToStopFollowingUser(user: UserData) {
        if followingUsers[user.id!] == false {
            // Nothing to do here, not currently following
        }
        else {
            followManager.askToStopFollowingUser(user, presentingViewController: self, completionBlock: { (success) in
                if (success) {
                    User.sharedInstance.stopFollowing(user.id!)
                    self.followingUsers[user.id!] = false;
                    self.followingTableView.reloadData()
                }
                else {
                    print("unable to stop following user")
                }
            })
        }
    }
    
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UserListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = allUsers[indexPath.row]
        // if user.id != User.sharedInstance.id {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let userVC = storyboard.instantiateViewControllerWithIdentifier(UserTimelineVCIdentifier) as! UserTimelineViewController
            
            userVC.userData = user
            
            self.navigationController?.pushViewController(userVC, animated: true)
        // }
        
        followingTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let user = allUsers[indexPath.row];
        
        if followingUsers[user.id!] == true {
            // Currently following, show stop following rowaction
            let unfollow = UITableViewRowAction(style: .Normal, title: "Unfollow") { action, index in
                self.askToStopFollowingUser(self.allUsers[indexPath.row])
            }
            
            unfollow.backgroundColor = UIColor.redColor()
            
            return [unfollow]
        }
        else {
            // Not following, show following rowaction
            let follow = UITableViewRowAction(style: .Normal, title: "Follow") { action, index in
                self.askToFollowUser(self.allUsers[indexPath.row])
            }
            
            follow.backgroundColor = blue;
            
            return [follow]
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (User.sharedInstance.id! == allUsers[indexPath.row].id!) {
            return false
        }
        return true
    }
}

extension UserListViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = followingTableView.dequeueReusableCellWithIdentifier(UserCellIdentifier) as! UserTableViewCell;
        
        let user = allUsers[indexPath.row]
        
        cell.usernameLabel.text = user.username
        cell.fullNameLabel.text = user.fullname
        
        if followingUsers[user.id!] == true {
            cell.emojiFollowingLabel.hidden = false
        }
        else {
            cell.emojiFollowingLabel.hidden = true
        }
        
        return cell;
    }
}

extension UserListViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
