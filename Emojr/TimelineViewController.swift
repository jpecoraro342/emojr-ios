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
        // refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var accountView: AccountView?
    var emoteView: EmoteView?
    var fadeView: UIView?
    var reacting = false
    var reactingToPostId: String?
    
    let networkFacade = NetworkFacade()
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        
        refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createViews() {
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
        frame = self.view.frame
        frame.origin.x = 0 - frame.width
        emoteView?.frame = frame
        
        fadeView = UIView(frame: self.view.frame)
        fadeView?.backgroundColor = UIColor.blackColor()
        fadeView?.alpha = 0.0
        
        //let recognizer = UITapGestureRecognizer(target: self, action: #selector(TimelineViewController.dismissPostForm))
        let recognizer = UITapGestureRecognizer(target: self, action: "dismissPostForm")
        fadeView?.addGestureRecognizer(recognizer)
    }
    
    func refreshData() {
        self.posts = []
        
        networkFacade.getAllFollowingPosts(User.sharedInstance.id!) { (error, list) in
            if let posts = list {
                self.posts = posts
                self.sortPostsByDate()
                self.timelineTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func sortPostsByDate() {
        posts.sortInPlace({$0.created.isGreaterThanDate($1.created)})
    }
    
    func reactToPostWithId(id: String) {
        reactingToPostId = id
        displayPostForm(true)
    }
    
    func displayPostForm(reacting: Bool) {        
        emoteView?.setButtonTitle(reacting)
        self.reacting = reacting
        
        var frame = self.view.frame
        frame.origin.x = 0 - frame.width
        emoteView?.frame = frame
        self.view.addSubview(fadeView!)
        self.view.addSubview(emoteView!)
        
        UIView.animateWithDuration(0.5, animations: {
            self.fadeView?.alpha = 0.6
            
            var frame = self.emoteView?.frame
            frame!.origin.x = 0
            self.emoteView?.frame = frame!
        }) { (completed) in
            self.emoteView?.emojiField.becomeFirstResponder()
        }
    }
    
    func dismissPostForm() {
        UIView.animateWithDuration(0.4, animations: {
            self.fadeView?.alpha = 0.0
            
            var frame = self.emoteView?.frame
            frame!.origin.x = self.view.frame.width
            self.emoteView?.frame = frame!
        }) { (completed) in
            self.emoteView?.removeFromSuperview()
            self.fadeView?.removeFromSuperview()
        }
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
        UIView.animateWithDuration(0.4, animations: {
            var frame = self.accountView!.frame
            frame.origin.y = 0
            self.accountView!.frame = frame
            }) { (completed) in
                
        }
    }
    
    func dismissAccount() {
        UIView.animateWithDuration(0.5, animations: {
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
            networkFacade.reactToPost(User.sharedInstance.username!, postId: id, reaction: post)
            { (error, reaction) in
                if let newReaction = reaction {
                    // TODO: Attach reaction to post
                    self.reactingToPostId = nil
                }
            }
        }
    }
    
    
}

extension TimelineViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        reactToPostWithId(posts[indexPath.row].id)
        timelineTableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        
        cell.configureWithPost(post)
        
        return cell;
    }
}