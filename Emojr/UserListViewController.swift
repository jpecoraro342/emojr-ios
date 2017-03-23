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
    
    let networkFacade = NetworkFacade()
    let followManager = FollowUserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTableView()
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem()
        
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        networkFacade.getUsers { (error, users) in
            if let error = error {
                print(error)
            } else {
                self.allUsers = users ?? []
                self.updateShownUsers()
            }
        }
    }
    
    func updateShownUsers() {
        shownUsers = allUsers
        
        tableView.reloadData()
        refreshControl.endRefreshing()
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
    
    
    @IBAction func closeView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let user = shownUsers[indexPath.row];
        
        if User.sharedInstance.isFollowing(user: user) {
            // Currently following, show stop following rowaction
            let unfollow = UITableViewRowAction(style: .normal, title: "Unfollow") { action, index in
                self.askToStopFollowingUser(user)
            }
            
            unfollow.backgroundColor = UIColor.red
            
            return [unfollow]
        }
        else {
            // Not following, show following rowaction
            let follow = UITableViewRowAction(style: .normal, title: "Follow") { action, index in
                self.askToFollowUser(user)
            }
            
            follow.backgroundColor = blue;
            
            return [follow]
        }
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
