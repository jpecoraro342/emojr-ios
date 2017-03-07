//
//  LoginManager.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/8/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        
        loadMainTab(false)
        return
        
        guard let email = UICKeyChainStore.string(forKey: "com.currentuser.email", service: "com.emojr")
            else { loadMainTab(false); return; }
        
        guard let password = UICKeyChainStore.string(forKey: "com.currentuser.password", service: "com.emojr")
            else { loadMainTab(false); return; }
        
        login(email, password: password, activityIndicator: activityIndicator) { (errorString, user) in
            activityIndicator?.stopAnimating()
            activityIndicator?.isHidden = true
            
            if let data = user {
                User.sharedInstance.configureWithUserData(data)
                
                UICKeyChainStore.setString(email, forKey: "com.currentuser.email", service: "com.emojr")
                UICKeyChainStore.setString(password, forKey: "com.currentuser.password", service: "com.emojr")
                
                self.loadMainTab(true)
            } else {
                self.loadMainTab(false)
            }
        }
    }
    
    func didLogIn() {
        
    }
    
    func login(_ email: String, password: String, activityIndicator: UIActivityIndicatorView? = nil, completionHandler: UserDataClosure?) {
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
        
        NetworkFacade.sharedInstance.signInUser(email, password: password) { (errorString, userData) in
            activityIndicator?.stopAnimating()
            activityIndicator?.isHidden = true
            
            if let userData = userData {
                User.sharedInstance.configureWithUserData(userData)
                
                UICKeyChainStore.setString(email, forKey: "com.currentuser.email", service: "com.emojr")
                UICKeyChainStore.setString(password, forKey: "com.currentuser.password", service: "com.emojr")
            }
            
            completionHandler?(errorString, userData)
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
        
        let homeVC = navControllerEmbeddedVC(TimelineViewController(with: .home))
        let discoverVC = navControllerEmbeddedVC(DiscoverViewController())
        let myEmotesVC = navControllerEmbeddedVC(storyboard.instantiateViewController(withIdentifier: AccountVCIdentifier))
        
        return [homeVC, discoverVC, myEmotesVC]
    }
    
    func getLoggedOutTabs() -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: LoginNavVCIdentifier)
        let discoverVC = navControllerEmbeddedVC(DiscoverViewController())
        let myEmotesVC = storyboard.instantiateViewController(withIdentifier: LoginNavVCIdentifier)
        
        return [homeVC, discoverVC, myEmotesVC]
    }
    
    func setVCTitlesAndIcons(_ tabVCList: [UIViewController]) {
        tabVCList[0].tabBarItem.title = "Home"
        tabVCList[0].tabBarItem.image = UIImage(named: "homeEmojiBW")?.withRenderingMode(.alwaysOriginal)
        tabVCList[0].tabBarItem.selectedImage = UIImage(named: "homeEmoji")?.withRenderingMode(.alwaysOriginal)
        
        tabVCList[1].tabBarItem.title = "Hot"
        tabVCList[1].tabBarItem.image = UIImage(named: "hotEmojiBW")?.withRenderingMode(.alwaysOriginal)
        tabVCList[1].tabBarItem.selectedImage = UIImage(named: "hotEmoji")?.withRenderingMode(.alwaysOriginal)
        
        tabVCList[2].tabBarItem.title = "Me"
        tabVCList[2].tabBarItem.image = UIImage(named: "meEmojiBW")?.withRenderingMode(.alwaysOriginal)
        tabVCList[2].tabBarItem.selectedImage = UIImage(named: "meEmoji")?.withRenderingMode(.alwaysOriginal)
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
