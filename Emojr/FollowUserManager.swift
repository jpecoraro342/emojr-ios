//
//  FollowUserManager.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 4/21/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation

class FollowUserManager: NSObject {
    
    var networkFacade: NetworkFacade = NetworkFacade()
    
    override init() {
        super.init()
    }
    
    init(networkFacade: NetworkFacade) {
        super.init()
        
        self.networkFacade = networkFacade
    }
    
    func startFollowingUser(_ userId: String, completionBlock: ((_ success: Bool) -> Void)?) {
        networkFacade.startFollowingUser(User.sharedInstance.id!, userIdToFollow: userId) { (success) -> Void in
            if success {
                User.sharedInstance.startFollowing(userId)
            }
            else {
                log.warning("Unable to following user \(userId)")
            }
            completionBlock?(success)
        }
    }
    
    func stopFollowingUser(_ userId: String, completionBlock: ((_ success: Bool) -> Void)?) {
        networkFacade.stopFollowingUser(User.sharedInstance.id!, userIdToStopFollowing: userId) { (success) -> Void in
            if success {
                User.sharedInstance.stopFollowing(userId)
            }
            else {
                log.warning("Unable to stop following user \(userId)")
            }
            completionBlock?(success)
        }
    }
    
    func askToFollowUser(_ user: UserData?, presentingViewController: UIViewController?, completionBlock: ((_ success: Bool) -> Void)?) {
        guard let user = user
            else { return }
        
        if User.sharedInstance.isFollowing(user: user) {
            log.debug("Already following user \(user.id ?? ""), no need to continue")
            return
        }
        
        let alertController = UIAlertController(title: "Follow \(user.username ?? "")", message: "Are you sure you want to start following \(user.username ?? "")?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Follow", style: .default) { (action) in
            self.startFollowingUser(user.id!, completionBlock: completionBlock)
        }
        alertController.addAction(OKAction)
        
        (presentingViewController ?? alertViewController)?.present(alertController, animated: true) {
        }
    }
    
    func askToStopFollowingUser(_ user: UserData?, presentingViewController: UIViewController?, completionBlock: ((_ success: Bool) -> Void)?) {
        guard let user = user
            else { return }
        
        if !User.sharedInstance.isFollowing(user: user) {
            log.debug("Already not following user \(user.id ?? ""), no need to continue")
            return
        }
        
        let alertController = UIAlertController(title: "Unfollow \(user.username ?? "")", message: "Are you sure you want to stop following \(user.username ?? "")?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Unfollow", style: .destructive) { (action) in
            self.stopFollowingUser(user.id!, completionBlock: completionBlock)
        }
        alertController.addAction(OKAction)
        
        (presentingViewController ?? alertViewController)?.present(alertController, animated: true) {
        }
    }
    
    func editActionFor(user: UserData?, presentingViewController: UIViewController?=nil, completionBlock: ((_ success: Bool) -> Void)?=nil) -> [UITableViewRowAction] {
        guard let user = user
            else { return [] }
        
        if User.sharedInstance.id == user.id {
            return []
        }
        
        if User.sharedInstance.isFollowing(user: user) {
            // Currently following, show stop following rowaction
            let unfollow = UITableViewRowAction(style: .normal, title: "✋🏼\nUnfollow") { action, index in
                self.askToStopFollowingUser(user, presentingViewController: presentingViewController, completionBlock: completionBlock)
            }
            
            unfollow.backgroundColor = blue
            
            return [unfollow]
        }
        else {
            // Not following, show following rowaction
            let follow = UITableViewRowAction(style: .normal, title: "👀\nFollow") { action, index in
                guard let userId = user.id
                    else {
                        completionBlock?(false)
                        return
                    }
                
                self.startFollowingUser(userId, completionBlock: completionBlock)
            }
            
            follow.backgroundColor = blue;
            
            return [follow]
        }
    }
    
    var alertViewController : UIViewController? {
        get {
            var rootViewController = UIApplication.shared.keyWindow?.rootViewController
            
            if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.first
            }
            
            if let tabBarController = rootViewController as? UITabBarController {
                rootViewController = tabBarController.selectedViewController
            }
            
            return rootViewController
        }
    }
}
