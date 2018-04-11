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
        let view = NoDataView.instanceFromNib(message: noDataMessage)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(refreshData))
        view.addGestureRecognizer(tap)
        
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
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
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib(nibName: "UserTableViewCell", bundle:nil), forCellReuseIdentifier: UserCellIdentifier)
    }
    
    @objc func refreshData() {
        refreshControl.beginRefreshing()
        
        networkFacade.getUsers(completionBlock: userResponseHandler)
    }
    
    func userResponseHandler(_ error: Error?, _ list: [UserData]?) {
        if let error = error {
            log.error(error)
            refreshControl.endRefreshing()
        } else {
            self.allUsers = list ?? []
            self.updateShownUsers()
        }
    }
    
    func updateShownUsers() {
        shownUsers = allUsers.filter { $0.username != User.sharedInstance.username! }
        
        tableView.reloadData()
        refreshControl.endRefreshing()
        
        if shownUsers.count == 0 {
            displayNoDataView()
        } else {
            removeNoDataView()
        }
    }
    
    @objc func navigateToAddBySearch() {
        self.navigationController?.pushViewController(AddUsersViewController(), animated: true)
    }
    
    func askToFollowUser(_ user: UserData) {
        followManager.startFollowing(user: user, completionBlock: followUserResultBlock)
    }
    
    func askToStopFollowingUser(_ user: UserData) {
        followManager.askToStopFollowingUser(user, presentingViewController: self, completionBlock: followUserResultBlock)
    }
    
    func followUserResultBlock(success: Bool) {
        tableView.reloadData()
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
            let userTimelineVC = TimelineViewController(with: .user(user: user))
            userTimelineVC.user = user
            self.navigationController?.pushViewController(userTimelineVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if (User.sharedInstance.id! == shownUsers[indexPath.row].id!) {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let user = shownUsers[indexPath.row]
        
        return followManager.editActionFor(user: user, presentingViewController: self, completionBlock: followUserResultBlock)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let user = shownUsers[indexPath.row]
        
        return User.sharedInstance.id != user.id
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
