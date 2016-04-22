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
    
    func startFollowingUser(userId: String, completionBlock: ((success: Bool) -> Void)?) {
        networkFacade.startFollowingUser(User.sharedInstance.id!, userIdToFollow: userId) { (success) -> Void in
            completionBlock?(success: success)
        }
    }
    
    func stopFollowingUser(userId: String, completionBlock: ((success: Bool) -> Void)?) {
        networkFacade.stopFollowingUser(User.sharedInstance.id!, userIdToStopFollowing: userId) { (success) -> Void in
            completionBlock?(success: success)
        }
    }
    
    func askToFollowUser(user: UserData, presentingViewController: UIViewController, completionBlock: ((success: Bool) -> Void)?) {
        let alertController = UIAlertController(title: "Follow \(user.username!)", message: "Are you sure you want to start following \(user.username!)?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Follow", style: .Default) { (action) in
            self.startFollowingUser(user.id!, completionBlock: completionBlock)
        }
        alertController.addAction(OKAction)
        
        presentingViewController.presentViewController(alertController, animated: true) {
        }
    }
    
    func askToStopFollowingUser(user: UserData, presentingViewController: UIViewController, completionBlock: ((success: Bool) -> Void)?) {
        let alertController = UIAlertController(title: "Unfollow \(user.username!)", message: "Are you sure you want to stop following \(user.username!)?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Unfollow", style: .Destructive) { (action) in
            self.stopFollowingUser(user.id!, completionBlock: completionBlock)
        }
        alertController.addAction(OKAction)
        
        presentingViewController.presentViewController(alertController, animated: true) {
        }
    }
}
