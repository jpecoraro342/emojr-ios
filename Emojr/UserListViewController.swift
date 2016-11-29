//
//  UserListViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/7/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit
import SnapKit

class UserListViewController: UIViewController {
    
    var tableView = UITableView()
    
    var allUsers = [UserData]()
    
    var followingUsers = Dictionary<String, Bool>()
    
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(UserListViewController.navigateToAddBySearch))
        self.navigationItem.rightBarButtonItem = addButton
        
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func layoutTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib(nibName: "UserTableViewCell", bundle:nil), forCellReuseIdentifier: UserCellIdentifier)
    }
    
    func refreshData() {
        followingUsers = User.sharedInstance.following
    }
    
    func navigateToAddBySearch() {
        self.navigationController?.pushViewController(AddUsersViewController(), animated: true)
    }
    
    func askToFollowUser(_ user: UserData) {
        if followingUsers[user.id!] != true {
            followManager.askToFollowUser(user, presentingViewController: self, completionBlock: { (success) in
                if (success) {
                    User.sharedInstance.startFollowing(user.id!)
                    self.followingUsers[user.id!] = true;
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
        if followingUsers[user.id!] != false {
            followManager.askToStopFollowingUser(user, presentingViewController: self, completionBlock: { (success) in
                if (success) {
                    User.sharedInstance.stopFollowing(user.id!)
                    self.followingUsers[user.id!] = false;
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
        let user = allUsers[indexPath.row];
        
        if followingUsers[user.id!] == true {
            // Currently following, show stop following rowaction
            let unfollow = UITableViewRowAction(style: .normal, title: "Unfollow") { action, index in
                self.askToStopFollowingUser(self.allUsers[indexPath.row])
            }
            
            unfollow.backgroundColor = UIColor.red
            
            return [unfollow]
        }
        else {
            // Not following, show following rowaction
            let follow = UITableViewRowAction(style: .normal, title: "Follow") { action, index in
                self.askToFollowUser(self.allUsers[indexPath.row])
            }
            
            follow.backgroundColor = blue;
            
            return [follow]
        }
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if (User.sharedInstance.id! == allUsers[indexPath.row].id!) {
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
        return self.allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCellIdentifier) as! UserTableViewCell;
        
        let user = allUsers[indexPath.row]
        
        cell.usernameLabel.text = user.username
        
        if followingUsers[user.id!] == true {
            cell.emojiFollowingLabel.isHidden = false
        }
        else {
            cell.emojiFollowingLabel.isHidden = true
        }
        
        return cell;
    }
}

extension UserListViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
