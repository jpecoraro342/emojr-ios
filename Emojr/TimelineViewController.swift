//
//  TimelineViewController.swift
//  Emojr
//
//  Created by James on 3/26/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    let networkFacade = NetworkFacade()
    
    var timelineTableView = UITableView()
    var emoteView: EmoteView?
    var noDataView: NoDataView?
    var fadeView: UIView?
    
    var refreshControl: BreakOutToRefreshView?
    
    func breakoutRefreshControl() -> BreakOutToRefreshView {
        let view = BreakOutToRefreshView(scrollView: self.timelineTableView)
        
        view.refreshDelegate = self
        
        return view
    }
    
    var tableDataSource: TimelineTableViewDataSource
    var type: Timeline
    var firstLoad = true
    var noDataMessage: String = "There aren't any posts here! Where'd they go?!"
    var user: UserData?
    
    var loadingCellRefreshControl: UIActivityIndicatorView?
    
    var reacting = false
    var reactionInfo : (id: String?, index: IndexPath?)
    
    var selectedUserData : UserData?
    
    init(with type: Timeline) {
        self.type = type
        tableDataSource = type.dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = type.navigationTitle
        self.noDataMessage = type.noDataMessage
        
        tableDataSource.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTableView()
        createViews()
        setupLongTapGesture()
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem()
        
        refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshControl = breakoutRefreshControl()
        timelineTableView.addSubview(refreshControl!)
        
        if noDataView?.superview != nil {
            refreshData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        refreshControl?.removeFromSuperview()
        refreshControl = nil
    }
    
    func rightBarButtonItem() -> UIBarButtonItem? {
        if case .user = type {
            return nil
        } else {
            let buttonImage = #imageLiteral(resourceName: "writeEmoji").withRenderingMode(.alwaysOriginal)
            let postButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(postButtonTapped))
            postButton.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 32)], for: UIControlState())
            
            return postButton
        }
    }
    
    func layoutTableView() {
        view.addSubview(timelineTableView)
        
        timelineTableView.translatesAutoresizingMaskIntoConstraints = false
        timelineTableView.constrainToEdges(of: view)
        
        timelineTableView.delegate = tableDataSource;
        timelineTableView.dataSource = tableDataSource;
        timelineTableView.rowHeight = 120;
        
        timelineTableView.tableFooterView = UIView(frame: .zero)
        
        timelineTableView.register(UINib(nibName: "TimelineTableViewCell", bundle:nil), forCellReuseIdentifier: TimelineCellIdentifier)
        
        timelineTableView.register(UINib(nibName: "LoadingTableViewCell", bundle:nil), forCellReuseIdentifier: LoadingCellIdentifier)
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
        noDataView?.translatesAutoresizingMaskIntoConstraints = false
        noDataView?.messageLabel.text = noDataMessage
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TimelineViewController.dismissPostForm))
        emoteView?.addGestureRecognizer(recognizer)
    }
    
    func displayNoDataView() {
        if let noDataView = noDataView {
            self.view.addSubview(noDataView)
            noDataView.constrainToEdges(of: view)
        }
    }
    
    func removeNoDataView() {
        noDataView?.removeFromSuperview()
    }

    func refreshData() {
        tableDataSource.getFirstPage()
    }
    
    func loadNextPage() {
        tableDataSource.getNextPage()
    }
    
    func reactToPostWithId(at indexPath: IndexPath) {
        if User.sharedInstance.isLoggedIn {
            let selectedPost = tableDataSource.posts[indexPath.row]
            
            guard let user = selectedPost.user, let id = selectedPost.key, user.id != User.sharedInstance.id else {
                return;
            }
            
            reactionInfo = (id, indexPath)
            displayPostForm(true)
        } else {
            presentLoginAlert(forReaction: true)
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
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 2,
                       options: .curveEaseOut,
                       animations: {
            self.fadeView?.alpha = 0.6
            
            var frame = self.emoteView?.frame
            frame!.origin.x = 0
            self.emoteView?.frame = frame!
        }, completion: { (completed) in
            self.emoteView?.emojiField.becomeFirstResponder()
        })
    }
    
    func dismissPostForm() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 4,
                       options: .curveEaseIn,
                       animations: {
            self.fadeView?.alpha = 0.0
            
            var frame = self.emoteView?.frame
            frame!.origin.x = self.view.frame.width + 30
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
                guard let newPost = post
                    else {return }
                
                if let strongSelf = self {
                    strongSelf.tableDataSource.insertPost(newPost)
                    let indexPath = IndexPath(row: 0, section: 0)
                    strongSelf.timelineTableView.insertRows(at: [indexPath], with: .top)
                }
            }
        }
    }
    
    func postReaction(_ post: String) {
        if let id = reactionInfo.id,
            let userId = User.sharedInstance.id {
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
            presentLoginAlert(forReaction: false)
        }
    }
    
    func presentLoginAlert(forReaction: Bool) {
        let message = forReaction ? "Login to react to posts!" : "Log in to post your own emotes!"
        
        let alert = UIAlertController(title: "Have an account?",
                                      message: message,
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in }
        
        alert.addAction(cancel)
        
        let login = UIAlertAction(title: "Log In", style: .default) { (action) in
            self.tabBarController?.selectedIndex = 2
        }
        
        alert.addAction(login)
        
        present(alert, animated: true, completion: nil)
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
                let userTimelineVC = TimelineViewController(with: .user(user: user))
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
        if !firstLoad {
            loadingCellRefreshControl = cell.activityIndicator
            loadingCellRefreshControl?.startAnimating()
            loadNextPage()
        } else {
            firstLoad = false
        }
    }
    
    func shouldShowLoadingCell() -> Bool {
        return !tableDataSource.endOfData
    }
    
    func dataSourceGotData(dataChanged: Bool) {
        if dataChanged {
            timelineTableView.reloadData()
            loadingCellRefreshControl?.stopAnimating()
            refreshControl?.endRefreshing()
            
            if tableDataSource.posts.count == 0 {
                displayNoDataView()
            } else {
                removeNoDataView()
            }
        }
    }
}

extension TimelineViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControl?.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshControl?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        refreshControl?.scrollViewWillBeginDragging(scrollView)
    }
}

extension TimelineViewController: BreakOutToRefreshDelegate {
    func refreshViewDidRefresh(_ refreshView: BreakOutToRefreshView) {
        refreshData()
    }
}
