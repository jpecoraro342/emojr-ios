//
//  AddUsersViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/7/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class AddUsersViewController: UserListViewController {
    
    var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = nil
        
        (UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])).tintColor = UIColor.white
        
        searchBar.tintColor = blue
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = "Add Users"
        searchBar.endEditing(true)
    }
    
    override func refreshData() {
        super.refreshData()
        
        networkFacade.getUsers(nil, completionBlock: { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                self.allUsers = list!
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        });
    }
    
    func updateDataWithSearchString(_ searchString: String) {
        self.refreshControl.beginRefreshing()
        networkFacade.getUsers(searchString, completionBlock: { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                self.allUsers = list!
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        });
    }
}

extension AddUsersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateDataWithSearchString(searchText)
    }
}
