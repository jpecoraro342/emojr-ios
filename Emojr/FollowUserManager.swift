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
            completionBlock?(success)
        }
    }
    
    func stopFollowingUser(_ userId: String, completionBlock: ((_ success: Bool) -> Void)?) {
        networkFacade.stopFollowingUser(User.sharedInstance.id!, userIdToStopFollowing: userId) { (success) -> Void in
            completionBlock?(success)
        }
    }
    
    func askToFollowUser(_ user: UserData?, presentingViewController: UIViewController, completionBlock: ((_ success: Bool) -> Void)?) {
        guard let user = user
            else { return }
        
        let alertController = UIAlertController(title: "Follow \(user.username ?? "")", message: "Are you sure you want to start following \(user.username ?? "")?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Follow", style: .default) { (action) in
            self.startFollowingUser(user.id!, completionBlock: completionBlock)
        }
        alertController.addAction(OKAction)
        
        presentingViewController.present(alertController, animated: true) {
        }
    }
    
    func askToStopFollowingUser(_ user: UserData?, presentingViewController: UIViewController, completionBlock: ((_ success: Bool) -> Void)?) {
        guard let user = user
            else { return }
        
        let alertController = UIAlertController(title: "Unfollow \(user.username ?? "")", message: "Are you sure you want to stop following \(user.username ?? "")?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Unfollow", style: .destructive) { (action) in
            self.stopFollowingUser(user.id!, completionBlock: completionBlock)
        }
        alertController.addAction(OKAction)
        
        presentingViewController.present(alertController, animated: true) {
        }
    }
}
