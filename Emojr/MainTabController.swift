//
//  MainTabController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 4/21/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = blue
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
}

extension MainTabController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}