//
//  TimelineViewController.swift
//  Emojr
//
//  Created by James on 3/26/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

extension UIView {
    func constrainToEdges(of view: UIView, leftConstant: CGFloat = 0, topConstant: CGFloat = 0, rightConstant: CGFloat = 0, bottomConstant: CGFloat = 0) {
        self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftConstant).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightConstant).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant).isActive = true
    }
}
class TimelineViewController: UIViewController {
    
    var timelineTableView = UITableView()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    var tableDataSource: TimelineTableViewDataSource = TimelineTableViewDataSource()
    
    var emoteView: EmoteView?
    var noDataView: NoDataView?
    var fadeView: UIView?
    
    var reacting = false
    var reactionInfo : (id: String?, index: IndexPath?)
    
    var noDataMessage: String {
        return "There aren't any posts here! Where'd they go?!"
    }
    
    var selectedUserData : UserData?
    
    let networkFacade = NetworkFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Timeline"
        
        layoutTableView()
        createViews()
        setupLongTapGesture()
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    func rightBarButtonItem() -> UIBarButtonItem? {
        let buttonImage = #imageLiteral(resourceName: "writeEmoji").withRenderingMode(.alwaysOriginal)
        let postButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(postButtonTapped))
        postButton.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 32)], for: UIControlState())
        
        return postButton
    }
    
    func layoutTableView() {
        view.addSubview(timelineTableView)
        
        timelineTableView.translatesAutoresizingMaskIntoConstraints = false
        timelineTableView.constrainToEdges(of: view)
        
        timelineTableView.addSubview(refreshControl)
        
        timelineTableView.delegate = tableDataSource;
        timelineTableView.dataSource = tableDataSource;
        timelineTableView.rowHeight = 120;
        
        timelineTableView.register(UINib(nibName: "TimelineTableViewCell", bundle:nil), forCellReuseIdentifier: TimelineCellIdentifier)
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
        emoteView = EmoteView.instanceFromNib()
        emoteView?.configureWithController(self)
        var frame = self.view.frame
        frame.origin.x = 0 - frame.width
        emoteView?.frame = frame
        
        fadeView = UIView(frame: self.view.frame)
        fadeView?.backgroundColor = UIColor.black
        fadeView?.alpha = 0.0
        
        noDataView = NoDataView.instanceFromNib()
        noDataView?.messageLabel.text = noDataMessage
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TimelineViewController.dismissPostForm))
        emoteView?.addGestureRecognizer(recognizer)
    }
    
    func displayNoDataView() {
        if let noDataView = noDataView {
            self.view.addSubview(noDataView)
        }
    }
    
    func removeNoDataView() {
        noDataView?.removeFromSuperview()
    }

    func refreshData() {
        
    }
    
    func handlePostResponse(_ error: Error?, _ list: Array<Post>?) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        
        guard let posts = list
            else { return }
        
        self.tableDataSource.configureWithPosts(posts, delegate: self)
        self.timelineTableView.reloadData()
        self.refreshControl.endRefreshing()
        
        if posts.count == 0 {
            self.displayNoDataView()
        } else {
            self.removeNoDataView()
        }
    }
    
    func loadNewPage() {
        print("refresh")
    }
    
    func reactToPostWithId(at indexPath: IndexPath) {
        if User.sharedInstance.isLoggedIn {
            let selectedPost = tableDataSource.posts[indexPath.row]
            
            guard let user = selectedPost.user, let id = user.id, id != User.sharedInstance.id else {
                return;
            }
            
            reactionInfo = (id, indexPath)
            displayPostForm(true)
        } else {
            // TODO: Pop up a message "Log in to post emotes!"
            let alert = UIAlertController(title: "Have an account?",
                                          message: "Login to react to posts!",
                                          preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK!", style: .default) { (action) in }
            
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func displayPostForm(_ reacting: Bool) {        
        emoteView?.setButtonTitle(reacting)
        self.reacting = reacting
        
        var frame = self.view.frame
        frame.origin.x = 0 - frame.width
        emoteView?.frame = frame
        self.navigationController?.view.addSubview(fadeView!)
        self.navigationController?.view.addSubview(emoteView!)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.fadeView?.alpha = 0.6
            
            var frame = self.emoteView?.frame
            frame!.origin.x = 0
            self.emoteView?.frame = frame!
        }, completion: { (completed) in
            self.emoteView?.emojiField.becomeFirstResponder()
        }) 
    }
    
    func dismissPostForm() {
        UIView.animate(withDuration: 0.4, animations: {
            self.fadeView?.alpha = 0.0
            
            var frame = self.emoteView?.frame
            frame!.origin.x = self.view.frame.width
            self.emoteView?.frame = frame!
        }, completion: { (completed) in
            self.emoteView?.removeFromSuperview()
            self.fadeView?.removeFromSuperview()
        }) 
    }
    
    func postFormReturnedPost(_ post: String) {
        dismissPostForm()
        
        if reacting {
            postReaction(post)
        } else {
            postPost(post)
        }
    }
    
    func postPost(_ post: String) {
        if let id = User.sharedInstance.id {
            networkFacade.createPost(id, post: post)
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
    }
    
    func postReaction(_ post: String) {
        if let id = reactionInfo.id,
            let userId = User.sharedInstance.id{
            networkFacade.reactToPost(userId, postId: id, reaction: post)
            { [weak self](error, reaction) in
                guard let _ = reaction
                    else {return }
                
                if let strongSelf = self {
                    let cell = strongSelf.timelineTableView.cellForRow(at: strongSelf.reactionInfo.index!) as! TimelineTableViewCell
                    cell.addReaction(post)
                    strongSelf.reactionInfo = (nil, nil)
                }
            }
        }
    }
    
    @IBAction func postButtonTapped(_ sender: AnyObject) {
        if User.sharedInstance.isLoggedIn {
            self.displayPostForm(false)
        } else {
            // TODO: Pop up a message "Log in to post emotes!"
            let alert = UIAlertController(title: "Have an account?",
                                          message: "Login to post your own emotes!",
                                          preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK!", style: .default) { (action) in }
            
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Long Tap Gesture

extension TimelineViewController {
    func longTapOnCell(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let location = sender.location(in: self.timelineTableView)
            let indexPath = self.timelineTableView.indexPathForRow(at: location)
            
            if let index = indexPath {
                longPressOnIndex(index.row)
            }
        }
    }
    
    func longPressOnIndex(_ index: Int) {
        let userSelected = tableDataSource.posts[index].user
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let user = userSelected {
            let viewUserPageAction = UIAlertAction(title: "View \(user.username!)'s Feed", style: .default) { (action: UIAlertAction) in
                let userTimelineVC = UserTimelineViewController()
                userTimelineVC.user = user
                self.navigationController?.pushViewController(userTimelineVC, animated: true)
            }
            
            alertController.addAction(viewUserPageAction)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - TimelineTableViewDelegate

extension TimelineViewController : TimelineTableViewDelegate {
    func cellSelectedInTable(_ tableView: UITableView, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        reactToPostWithId(at: indexPath)
    }
    
    func loadingCellDisplayed(_ cell: LoadingTableViewCell) {
        // cell.startRefreshAnimation()
    }
    
    func shouldShowLoadingCell() -> Bool {
        return false
    }
}

extension TimelineViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
