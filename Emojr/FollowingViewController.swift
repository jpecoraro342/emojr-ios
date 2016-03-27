//
//  FollowingViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController {
    
    @IBOutlet weak var followingTableView: UITableView!
    @IBOutlet weak var navigationBar: UIView!
    
    var allUsers = [UserData]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        // refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    let networkFacade = NetworkFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followingTableView.addSubview(refreshControl)

        refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshData() {
        networkFacade.getAllUsers { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                self.allUsers = list!
                self.followingTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension FollowingViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        followingTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension FollowingViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowingCell") as! FollowingTableViewCell;
    
        cell.usernameLabel.text = allUsers[indexPath.row].username
        cell.fullNameLabel.text = allUsers[indexPath.row].fullname
        
        return cell;
    }
}
