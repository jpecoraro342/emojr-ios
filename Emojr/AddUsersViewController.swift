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
    var searchString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
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
    
    override func rightBarButtonItem() -> UIBarButtonItem? {
        return nil
    }
    
    func setupSearchBar() {
        searchBar.tintColor = blue
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
    }
    
    override func updateShownUsers() {
        shownUsers = allUsers.filter { (searchString != nil) ? $0.username!.contains(searchString!) : true }
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
        updateShownUsers()
    }
}
