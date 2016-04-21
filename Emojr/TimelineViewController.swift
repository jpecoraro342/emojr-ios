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
        
        return refreshControl
    }()
    
    var tableDataSource: TimelineTableViewDataSource = TimelineTableViewDataSource()
    
    var emoteView: EmoteView?
    var fadeView: UIView?
    var reacting = false
    var reactionInfo : (id: String?, index: NSIndexPath?)
    
    let networkFacade = NetworkFacade()
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.delegate = tableDataSource
        timelineTableView.dataSource = tableDataSource
        
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
        
        var frame = self.view.frame
        frame.origin.y = (-1*frame.size.height + 84)
        
        emoteView = EmoteView.instanceFromNib()
        emoteView?.configureWithController(self)
        frame = self.view.frame
        frame.origin.x = 0 - frame.width
        emoteView?.frame = frame
        
        fadeView = UIView(frame: self.view.frame)
        fadeView?.backgroundColor = UIColor.blackColor()
        fadeView?.alpha = 0.0
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TimelineViewController.dismissPostForm))
        emoteView?.addGestureRecognizer(recognizer)
    }
    
    func refreshData() {
        networkFacade.getAllFollowingPosts(User.sharedInstance.id!) { (error, list) in
            if let posts = list {
                self.tableDataSource.configureWithPosts(posts, delegate: self)
                self.timelineTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func reactToPostWithId(id: String, index: NSIndexPath) {
        reactionInfo = (id, index)
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
        if let id = reactionInfo.id {
            networkFacade.reactToPost(User.sharedInstance.id!, postId: id, reaction: post)
            { (error, reaction) in
                if let _ = reaction {
                    let cell = self.timelineTableView.cellForRowAtIndexPath(self.reactionInfo.index!) as! TimelineTableViewCell
                    cell.addReaction(post)
                    self.reactionInfo = (nil, nil)
                }
            }
        }
    }
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        self.displayPostForm(false)
    }
    
}

extension TimelineViewController : TimelineTableViewDelegate {
    func cellSelectedInTable(tableView: UITableView, indexPath: NSIndexPath) {
        reactToPostWithId(tableDataSource.posts[indexPath.row].id!, index: indexPath)
        timelineTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension TimelineViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}