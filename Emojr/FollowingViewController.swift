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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        // refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        
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
    
    func refreshData() {
        networkFacade.getAllUsers { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                self.allUsers = list!
                self.filteredUsers = list!
                
                for var user in self.allUsers {
                    self.followingUsers[user.id] = false;
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
                for var user in list! {
                    self.followingUsers[user.id] = true;
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
    
}

extension FollowingViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = allUsers[indexPath.row]
        if user.id != User.sharedInstance.id {
            if followingUsers[user.id] == true {
                // Nothing to do here, already following
            }
            else {
                let alertController = UIAlertController(title: "Follow \(user.username)", message: "Are you sure you want to start following \(user.username)?", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Follow", style: .Default) { (action) in
                    self.startFollowingUser(user.id)
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                }
            }
        }
        
        followingTableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        
        if followingUsers[user.id] == true {
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
            if user.username.hasPrefix(prefix) || user.fullname!.hasPrefix(prefix) {
                users.append(user)
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
