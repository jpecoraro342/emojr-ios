//
//  TimelineViewController.swift
//  Emojr
//
//  Created by James on 3/26/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    var timelineTableView = UITableView()
    
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
    
    var selectedUserData : UserData?
    
    let networkFacade = NetworkFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTableView()
        createViews()
        setupLongTapGesture()
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem()
        
        refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func rightBarButtonItem() -> UIBarButtonItem? {
        return nil
    }
    
    func layoutTableView() {
        view.addSubview(timelineTableView)
        
        timelineTableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        timelineTableView.addSubview(refreshControl)
        
        timelineTableView.delegate = tableDataSource;
        timelineTableView.dataSource = tableDataSource;
        timelineTableView.rowHeight = 120;
        
        timelineTableView.registerNib(UINib(nibName: "TimelineTableViewCell", bundle:nil), forCellReuseIdentifier: TimelineCellIdentifier)
    }
    
    func setupLongTapGesture() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(self.longTapOnCell(_:)))
        longTap.minimumPressDuration = 0.8
        longTap.numberOfTapsRequired = 0
        longTap.numberOfTouchesRequired = 1
        longTap.cancelsTouchesInView = true
        longTap.delaysTouchesBegan = false
        longTap.delaysTouchesEnded = true
        
        self.view.addGestureRecognizer(longTap)
    }
    
    func createViews() {
        timelineTableView.addSubview(refreshControl)
        
        var frame = self.view.frame
        frame.origin.y = 0
        
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
        
    }
    
    func loadNewPage() {
        print("refresh")
    }
    
    func reactToPostWithId(id: String, index: NSIndexPath) {
        guard let _ = User.sharedInstance.id
            else { return } // TODO: Display warning banner
        
        reactionInfo = (id, index)
        displayPostForm(true)
    }
    
    func displayPostForm(reacting: Bool) {        
        emoteView?.setButtonTitle(reacting)
        self.reacting = reacting
        
        var frame = self.view.frame
        frame.origin.x = 0 - frame.width
        emoteView?.frame = frame
        self.navigationController?.view.addSubview(fadeView!)
        self.navigationController?.view.addSubview(emoteView!)
        
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
        { [weak self](error, post) in
            guard var newPost = post
                else {return }
            
            if let strongSelf = self {
                newPost.user = User.sharedInstance.userData
                strongSelf.tableDataSource.insertPost(newPost)
                strongSelf.timelineTableView.reloadData()
            }
        }
    }
    
    func postReaction(post: String) {
        if let id = reactionInfo.id {
            networkFacade.reactToPost(User.sharedInstance.id!, postId: id, reaction: post)
            { [weak self](error, reaction) in
                guard let _ = reaction
                    else {return }
                
                if let strongSelf = self {
                    let cell = strongSelf.timelineTableView.cellForRowAtIndexPath(strongSelf.reactionInfo.index!) as! TimelineTableViewCell
                    cell.addReaction(post)
                    strongSelf.reactionInfo = (nil, nil)
                }
            }
        }
    }
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        self.displayPostForm(false)
    }
}

extension TimelineViewController {
    func longTapOnCell(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            let location = sender.locationInView(self.timelineTableView)
            let indexPath = self.timelineTableView.indexPathForRowAtPoint(location)
            
            if let index = indexPath {
                longPressOnIndex(index.row)
            }
        }
    }
    
    func longPressOnIndex(index: Int) {
        let userSelected = tableDataSource.posts[index].user
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        if let user = userSelected {
            let viewUserPageAction = UIAlertAction(title: "View \(user.username!) Feed", style: .Default) { (action: UIAlertAction) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let userTimelineVC = storyboard.instantiateViewControllerWithIdentifier(UserTimelineVCIdentifier) as! UserTimelineViewController
                userTimelineVC.userData = user
                self.navigationController?.pushViewController(userTimelineVC, animated: true)
            }
            
            alertController.addAction(viewUserPageAction)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

extension TimelineViewController : TimelineTableViewDelegate {
    func cellSelectedInTable(tableView: UITableView, indexPath: NSIndexPath) {
        let userForSelectedPost = tableDataSource.posts[indexPath.row].user
        
        if let user = userForSelectedPost {
            if (user.id == User.sharedInstance.id) {
                return;
            }
        }
        
        reactToPostWithId(tableDataSource.posts[indexPath.row].id!, index: indexPath)
        timelineTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func loadingCellDisplayed(cell: LoadingTableViewCell) {
        // cell.startRefreshAnimation()
    }
    
    func shouldShowLoadingCell() -> Bool {
        return false
    }
}

extension TimelineViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}