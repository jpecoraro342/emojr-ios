//
//  DiscoverViewController.swift
//  Emojr
//
//  Created by Joseph on 6/7/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class DiscoverViewController: TimelineViewController {
    
    private lazy var searchButton: UIBarButtonItem = {
        let buttonImage = #imageLiteral(resourceName: "searchEmoji").withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(searchButtonTapped))
        button.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 32)], for: UIControlState())
        
        return button
    }()
    
    init() {
        super.init(with: .discover)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = searchButton
    }
    
    // MARK: - Action
    
    func searchButtonTapped(sender: UIBarButtonItem) {
        if User.sharedInstance.isLoggedIn {
            let addUserVC = AddUsersViewController()
            self.navigationController?.pushViewController(addUserVC, animated: true)
        }
    }
}
