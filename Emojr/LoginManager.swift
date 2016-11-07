//
//  LoginManager.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/8/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class LoginManager: NSObject {
    
    func attemptLogin(_ activityIndicator: UIActivityIndicatorView?=nil) {
        if User.sharedInstance.manuallyLoggedOut {
            loadMainTab(false)
            return
        }
        
        if User.sharedInstance.isLoggedIn {
            loadMainTab(true)
            return
        }
        
        guard let username = UICKeyChainStore.string(forKey: "com.currentuser.username", service: "com.emojr")
            else { loadMainTab(false); return; }
        
        guard let password = UICKeyChainStore.string(forKey: "com.currentuser.password", service: "com.emojr")
            else { loadMainTab(false); return; }
        
        login(username, password: password, activityIndicator: activityIndicator)
    }
    
    func didLogIn() {
        
    }
    
    func login(_ username: String, password: String, activityIndicator: UIActivityIndicatorView?=nil) {
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
        
        NetworkFacade.sharedInstance.signInUser(username, password: password) { (error, user) in
            if let _ = error {
                // TODO: Show unable to login banner
                self.loadMainTab(false)
            } else if let data = user {
                User.sharedInstance.configureWithUserData(data)
                
                activityIndicator?.isHidden = true
                activityIndicator?.stopAnimating()
                
                self.loadMainTab(true)
            }
        }
    }
    
    func logout() {
        User.sharedInstance.logout()
        loadMainTab(false)
    }
    
    func loadMainTab(_ isLoggedIn: Bool) {
        let tabController = getMainTab(isLoggedIn)
        
        if let window = UIApplication.shared.delegate?.window {
            window!.rootViewController = tabController
        }
    }
    
    func getMainTab(_ isLoggedIn: Bool) -> UIViewController {
        let tabVCList = isLoggedIn ? getLoggedInTabs() : getLoggedOutTabs()
        
        setVCTitlesAndIcons(tabVCList)
        
        let tabController = UITabBarController()
        tabController.tabBar.isTranslucent = false
        tabController.tabBar.tintColor = blue
        
        tabController.setViewControllers(tabVCList, animated: false)
        
        tabController.selectedIndex = isLoggedIn ? 0 : 1
        
        return tabController
    }
    
    func getLoggedInTabs() -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = navControllerEmbeddedVC(HomeTimelineViewController())
        let discoverVC = navControllerEmbeddedVC(DiscoverViewController())
        let myEmotesVC = navControllerEmbeddedVC(storyboard.instantiateViewController(withIdentifier: UserTimelineVCIdentifier))
        let accountVC = navControllerEmbeddedVC(storyboard.instantiateViewController(withIdentifier: AccountVCIdentifier))
        
        return [homeVC, discoverVC, myEmotesVC, accountVC]
    }
    
    func getLoggedOutTabs() -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: LoginNavVCIdentifier)
        let discoverVC = navControllerEmbeddedVC(DiscoverViewController())
        let myEmotesVC = storyboard.instantiateViewController(withIdentifier: LoginNavVCIdentifier)
        let accountVC = storyboard.instantiateViewController(withIdentifier: LoginNavVCIdentifier)
        
        return [homeVC, discoverVC, myEmotesVC, accountVC]
    }
    
    func setVCTitlesAndIcons(_ tabVCList: [UIViewController]) {
        tabVCList[0].tabBarItem.title = "Home"
        tabVCList[0].tabBarItem.image = UIImage(named: "houseEmoji")?.withRenderingMode(.alwaysOriginal)
        
        tabVCList[1].tabBarItem.title = "Discover"
        tabVCList[1].tabBarItem.image = UIImage(named: "fireEmoji")?.withRenderingMode(.alwaysOriginal)
        
        tabVCList[2].tabBarItem.title = "My Emotes"
        tabVCList[2].tabBarItem.image = UIImage(named: "tongueOutEmoji")?.withRenderingMode(.alwaysOriginal)
        
        tabVCList[3].tabBarItem.title = "Account"
        tabVCList[3].tabBarItem.image = UIImage(named: "gearEmoji")?.withRenderingMode(.alwaysOriginal)
    }
    
    func navControllerEmbeddedVC(_ viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        styleNavigationController(navController)
        
        return navController
    }
    
    func styleNavigationController(_ navController: UINavigationController) {
        navController.navigationBar.barTintColor = blue
        navController.navigationBar.tintColor = UIColor.white
        
        navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        navController.navigationBar.isTranslucent = false
    }
}
