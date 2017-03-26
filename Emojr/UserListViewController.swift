//
//  UserListViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/7/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    var tableView = UITableView()
    
    var allUsers = [UserData]()
    var shownUsers = [UserData]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    lazy var noDataView: NoDataView = {
        let view = NoDataView.instanceFromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.messageLabel.text = self.noDataMessage
        
        return view
    }()
    
    var noDataMessage = "No users here!"
    
    let networkFacade = NetworkFacade()
    let followManager = FollowUserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTableView()
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    func rightBarButtonItem() -> UIBarButtonItem? {
        return UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(navigateToAddBySearch))
    }
    
    func layoutTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.constrainToEdges(of: view)
        
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib(nibName: "UserTableViewCell", bundle:nil), forCellReuseIdentifier: UserCellIdentifier)
    }
    
    func refreshData() {
        refreshControl.beginRefreshing()
        
        networkFacade.getUsers(completionBlock: userResponseHandler)
    }
    
    func userResponseHandler(_ error: Error?, _ list: [UserData]?) {
        if let error = error {
            print(error)
            refreshControl.endRefreshing()
        } else {
            self.allUsers = list ?? []
            self.updateShownUsers()
        }
    }
    
    func updateShownUsers() {
        shownUsers = allUsers
        
        tableView.reloadData()
        refreshControl.endRefreshing()
        
        if shownUsers.count == 0 {
            displayNoDataView()
        } else {
            removeNoDataView()
        }
    }
    
    func navigateToAddBySearch() {
        self.navigationController?.pushViewController(AddUsersViewController(), animated: true)
    }
    
    func askToFollowUser(_ user: UserData) {
        if !User.sharedInstance.isFollowing(user: user) {
            followManager.askToFollowUser(user, presentingViewController: self, completionBlock: { (success) in
                if (success) {
                    User.sharedInstance.startFollowing(user.id!)
                    self.refreshData()
                    self.tableView.reloadData()
                }
                else {
                    print("unable to follow user")
                }
            })
        }
    }
    
    func askToStopFollowingUser(_ user: UserData) {
        if User.sharedInstance.isFollowing(user: user) {
            followManager.askToStopFollowingUser(user, presentingViewController: self, completionBlock: { (success) in
                if (success) {
                    User.sharedInstance.stopFollowing(user.id!)
                    self.refreshData()
                    self.tableView.reloadData()
                }
                else {
                    print("unable to stop following user")
                }
            })
        }
    }
    
    func displayNoDataView() {
        self.view.addSubview(noDataView)
        noDataView.constrainToEdges(of: view)
    }
    
    func removeNoDataView() {
        noDataView.removeFromSuperview()
    }
    
    @IBAction func closeView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = shownUsers[indexPath.row];
        
        if user.username! != User.sharedInstance.username! {
            showActionSheet(for: user)
        }
    }
    
    func showActionSheet(for user: UserData) {
        let actionSheet = UIAlertController(title: "What would you like to do?",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        var followActionTitle: String?
        var followActionBlock: ((UIAlertAction) -> Void)?
        
        if User.sharedInstance.isFollowing(user: user) {
            followActionTitle = "Unfollow \(user.username!)?"
            
            followActionBlock = { action in
                self.askToStopFollowingUser(user)
            }
        } else {
            followActionTitle = "Follow \(user.username!)?"
            
            followActionBlock = { action in
                self.askToFollowUser(user)
            }
        }
        
        let followAction = UIAlertAction(title: followActionTitle,
                                         style: .default,
                                         handler: followActionBlock)
        actionSheet.addAction(followAction)
        
        let viewUserPageAction = UIAlertAction(title: "View \(user.username!)'s Feed", style: .default) { (action: UIAlertAction) in
            let userTimelineVC = TimelineViewController(with: .user(user: user))
            userTimelineVC.user = user
            self.navigationController?.pushViewController(userTimelineVC, animated: true)
        }
        
        actionSheet.addAction(viewUserPageAction)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if (User.sharedInstance.id! == shownUsers[indexPath.row].id!) {
            return false
        }
        return true
    }
}

extension UserListViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shownUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCellIdentifier) as! UserTableViewCell;
        
        let user = shownUsers[indexPath.row]
        
        cell.usernameLabel.text = user.username
        
        if User.sharedInstance.isFollowing(user: user) {
            cell.emojiFollowingLabel.isHidden = false
        }
        else {
            cell.emojiFollowingLabel.isHidden = true
        }
        
        return cell;
    }
}
