//
//  LoginManager.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/8/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class LoginManager: NSObject {
    
    func attemptLogin(activityIndicator: UIActivityIndicatorView?=nil) {
        if User.sharedInstance.manuallyLoggedOut {
            skipLogin()
            return
        }
        
        if User.sharedInstance.isLoggedIn {
            loadMainTab()
            return
        }
        
        guard let username = UICKeyChainStore.stringForKey("com.currentuser.username", service: "com.emojr")
            else { skipLogin(); return; }
        
        guard let password = UICKeyChainStore.stringForKey("com.currentuser.password", service: "com.emojr")
            else { skipLogin(); return; }
        
        login(username, password: password, activityIndicator: activityIndicator)
    }
    
    func login(username: String, password: String, activityIndicator: UIActivityIndicatorView?=nil) {
        activityIndicator?.hidden = false
        activityIndicator?.startAnimating()
        
        NetworkFacade.sharedInstance.signInUser(username, password: password) { (error, user) in
            if let _ = error {
                // TODO: Show unable to login banner
                self.skipLogin()
            } else if let data = user {
                User.sharedInstance.configureWithUserData(data)
                
                activityIndicator?.hidden = true
                activityIndicator?.stopAnimating()
                
                self.loadMainTab()
            }
        }
    }
    
    func logout() {
        User.sharedInstance.logout()
        skipLogin()
    }
    
    func skipLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewControllerWithIdentifier(LoginNavVCIdentifier)
        let discoverVC = storyboard.instantiateViewControllerWithIdentifier(DiscoverVCIdentifier)
        let myEmotesVC = storyboard.instantiateViewControllerWithIdentifier(LoginNavVCIdentifier)
        let accountVC = storyboard.instantiateViewControllerWithIdentifier(LoginNavVCIdentifier)
        
        let discoverNav = UINavigationController(rootViewController: discoverVC)
        styleNavigationController(discoverNav)
        
        homeVC.tabBarItem.title = "Home"
        discoverNav.tabBarItem.title = "Discover"
        myEmotesVC.tabBarItem.title = "My Emotes"
        accountVC.tabBarItem.title = "Account"
        
        let tabController = UITabBarController()
        tabController.tabBar.translucent = false
        tabController.tabBar.tintColor = blue
        
        tabController.setViewControllers([homeVC, discoverNav, myEmotesVC, accountVC], animated: false)
        
        tabController.selectedIndex = 1
        
        if let window = UIApplication.sharedApplication().delegate?.window {
            window!.rootViewController = tabController
        }
    }
    
    func loadMainTab() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainTabVC = storyboard.instantiateViewControllerWithIdentifier(MainTabVCIdentifier)
        
        if let window = UIApplication.sharedApplication().delegate?.window {
            window!.rootViewController = mainTabVC
        }
    }
    
    func styleNavigationController(navController: UINavigationController) {
        navController.navigationBar.barTintColor = blue
        navController.navigationBar.tintColor = UIColor.whiteColor()
        
        navController.navigationBar.translucent = false
    }

}
