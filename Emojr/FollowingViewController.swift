//
//  FollowingViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController {
    
    @IBOutlet weak var followingTableView: UITableView!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allUsers = [UserData]()
    var filteredUsers = [UserData]()
    var followingUsers = Dictionary<String, Bool>()
    
    var userFeedId: String?
    var userFeedName: String?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    let networkFacade = NetworkFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.backgroundImage = UIImage();
        followingTableView.addSubview(refreshControl)

        refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == FollowingToUserTimeline {
            let destinationVc = segue.destinationViewController as! UserTimelineViewController
            destinationVc.userID = userFeedId
            destinationVc.username = userFeedName
        }
    }
    
    func refreshData() {
        networkFacade.getAllUsers { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                let listWithoutMe = list!.filter({ $0.id != User.sharedInstance.id})
                
                self.allUsers = listWithoutMe
                self.filteredUsers = listWithoutMe
                
                for user in self.allUsers {
                    self.followingUsers[user.id!] = false;
                }
                
                self.queryFollowing();
            }
        }
    }
    
    func queryFollowing() {
        networkFacade.getAllFollowing(User.sharedInstance.id!) { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                for user in list! {
                    self.followingUsers[user.id!] = true;
                }
                
                self.followingTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func startFollowingUser(userId: String) {
        networkFacade.startFollowingUser(User.sharedInstance.id!, userIdToFollow: userId) { (success) -> Void in
            if (success) {
                self.followingUsers[userId] = true;
                self.followingTableView.reloadData()
            }
            else {
                print("unable to follow user")
            }
        }
    }
    
    func stopFollowingUser(userId: String) {
        networkFacade.stopFollowingUser(User.sharedInstance.id!, userIdToStopFollowing: userId) { (success) -> Void in
            if (success) {
                self.followingUsers[userId] = false;
                self.followingTableView.reloadData()
            }
            else {
                print("unable to stop following user")
            }
        }
    }
    
    func askToFollowUser(user: UserData) {
        if followingUsers[user.id!] == true {
            // Nothing to do here, already following
        }
        else {
            let alertController = UIAlertController(title: "Follow \(user.username!)", message: "Are you sure you want to start following \(user.username!)?", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Follow", style: .Default) { (action) in
                self.startFollowingUser(user.id!)
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
            }
        }
    }
    
    func askToStopFollowingUser(user: UserData) {
        if followingUsers[user.id!] == false {
            // Nothing to do here, not currently following
        }
        else {
            let alertController = UIAlertController(title: "Unfollow \(user.username!)", message: "Are you sure you want to stop following \(user.username!)?", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Unfollow", style: .Destructive) { (action) in
                self.stopFollowingUser(user.id!)
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
            }
        }
    }
}

extension FollowingViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = allUsers[indexPath.row]
        if user.id != User.sharedInstance.id {
            userFeedId = user.id
            userFeedName = user.username
            self.performSegueWithIdentifier(FollowingToUserTimeline, sender: self)
            
        }
        
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

extension FollowingViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowingCell") as! FollowingTableViewCell;
        
        let user = filteredUsers[indexPath.row]
    
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
    
    func usersWithPrefix(prefix: String) -> [UserData] {
        if prefix == "" {
            return allUsers
        }
        
        var users = [UserData]()
        
        for user in allUsers {
            if let username = user.username {
                if (username.hasPrefix(prefix)) {
                    users.append(user)
                }
            }
        }
        
        return users
    }
}

extension FollowingViewController : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = usersWithPrefix(searchText)
        followingTableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // TODO: Limit input to emoji
        return true
    }
}

extension FollowingViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

