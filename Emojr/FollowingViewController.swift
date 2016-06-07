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
    
    var allUsers = [UserData]()
    
    var userData : UserData?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    let networkFacade = NetworkFacade()
    let followManager = FollowUserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            destinationVc.userData = userData
        }
    }
    
    func refreshData() {
        networkFacade.getAllFollowing(User.sharedInstance.id!) { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                self.allUsers = list!
                
                self.followingTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension FollowingViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = allUsers[indexPath.row]
        if user.id != User.sharedInstance.id {
            userData = user
            self.performSegueWithIdentifier(FollowingToUserTimeline, sender: self)
            
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
        return self.allUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowingCell") as! FollowingTableViewCell;
        
        let user = allUsers[indexPath.row]
    
        cell.usernameLabel.text = user.username
        cell.fullNameLabel.text = user.fullname
        
        cell.emojiFollowingLabel.hidden = true
        
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

extension FollowingViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

