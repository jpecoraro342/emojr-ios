//
//  TimelineViewController.swift
//  Emojr
//
//  Created by James on 3/26/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var timelineTableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        // refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    
    var accountView: AccountView?
    var emoteView: EmoteView?
    var reacting = false
    var reactingToPostId: String?
    
    let networkFacade = NetworkFacade()
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.addSubview(refreshControl)
        
        accountView = AccountView.instanceFromNib()
        accountView?.configureWithController(self)
        var frame = self.view.frame
        frame.origin.y = (-1*frame.size.height + 84)
        accountView?.frame = frame
        accountView?.bounds = self.view.bounds
        if let view = accountView {
            self.view.addSubview(view)
        }
        
        emoteView = EmoteView.instanceFromNib()
        emoteView?.configureWithController(self)
        emoteView?.frame = self.view.frame
        emoteView?.bounds = self.view.bounds
        
        networkFacade.signInUser("😌", password: "test") { (error, user) in
            if let data = user {
                User.sharedInstance.configureWithUserData(data)
            }
            
            self.refreshData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshData() {
        self.posts = []
        
        networkFacade.getAllFollowingPosts(User.sharedInstance.id!) { (error, list) in
            if let posts = list {
                self.posts = posts
                self.timelineTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func reactToPostWithId(id: String) {
        reactingToPostId = id
        displayPostForm(true)
    }
    
    func displayPostForm(reacting: Bool) {
        // TODO: Animate view in by growing from center
        self.reacting = reacting
        self.view.addSubview(emoteView!)
    }
    
    func dismissPostForm() {
        // TODO: Animate view away by shrinking to center
        emoteView?.removeFromSuperview()
    }
    
    func postFormReturnedPost(post: String) {
        dismissPostForm()
        
        if reacting {
            postReaction(post)
        } else {
            postPost(post)
        }
    }
    
    func displayAccount() {
        UIView.animateWithDuration(1.0, animations: { 
            var frame = self.accountView!.frame
            frame.origin.y = 0
            self.accountView!.frame = frame
            }) { (completed) in
                
        }
    }
    
    func dismissAccount() {
        UIView.animateWithDuration(1.0, animations: {
            var frame = self.accountView!.frame
            frame.origin.y = (-1*self.view.frame.size.height + 84)
            self.accountView!.frame = frame
        }) { (completed) in
            
        }
    }
    
    func postPost(post: String) {
        networkFacade.createPost(User.sharedInstance.id!, post: post)
        { (error, post) in
            if let newPost = post {
                self.posts.insert(newPost, atIndex: 0)
                self.timelineTableView.reloadData()
            }
        }
    }
    
    func postReaction(post: String) {
        if let id = reactingToPostId {
            networkFacade.reactToPost(User.sharedInstance.id!, postId: id, reaction: post)
            { (error, reaction) in
                if let newReaction = reaction {
                    // TODO: Attach reaction to post
                    self.reactingToPostId = nil
                }
            }
        }
    }
    
    func timeDisplayForTimestamp(timestamp: Double) -> String {
        let then = NSDate(timeIntervalSince1970: timestamp)
        let past = NSDate().timeIntervalSinceDate(then)
        
        let pastInt = Int(past)
        
        if pastInt < 60 {
            return "\(pastInt)s"
        } else if pastInt < 3600 {
            let minutes = pastInt / 3600
            return "\(minutes)m"
        } else if pastInt < 86400 {
            let hours = pastInt / 86400
            return "\(hours)h"
        } else if pastInt < 604800 {
            let days = pastInt / 604800
            return "\(days)d"
        } else {
            let weeks = pastInt / 2592000
            return "\(weeks)w"
        }
    }
}

extension TimelineViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        reactToPostWithId(posts[indexPath.row].id)
    }
}

extension TimelineViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as! TimelineTableViewCell;
        
        let post = posts[indexPath.row];
        
        cell.usernameLabel.text = post.user.username
        cell.statusImageLabel.text = post.post
        cell.timestampLabel.text = timeDisplayForTimestamp(NSDate().timeIntervalSince1970 - 12)
        
        return cell;
    }
}