//
//  User.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/25/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation

class User : NSObject {
    
    static let sharedInstance = User()
    
    var id: String?
    var username: String?
    var fullname: String?
    
    var userData: UserData?
    
    var followers = Dictionary<String, Bool>()
    var following = Dictionary<String, Bool>()
    
    var manuallyLoggedOut = false
    
    let networkFacade = NetworkFacade()
    
    func configureWithUserData(data: UserData) {
        manuallyLoggedOut = false
        
        self.id = data.id
        self.username = data.username
        self.fullname = data.fullname
        
        AnalyticsManager.sharedInstance.setupUser(data)
        self.userData = data
        
        updateFollowers()
        updateFollowing()
    }
    
    func updateFollowers() {
        guard let userId = id
            else { return }
        
        networkFacade.getAllFollowers(userId, completionBlock: { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                for user in list! {
                    self.followers[user.id!] = true;
                }
            }
        });
    }
    
    func updateFollowing() {
        guard let userId = id
            else { return }
        
        networkFacade.getAllFollowing(userId, completionBlock: { (error, list) -> Void in
            if let err = error {
                print(err)
            }
            else {
                for user in list! {
                    self.following[user.id!] = true;
                }
            }
        });
    }
    
    func stopFollowing(userId: String) {
        self.following[userId] = false;
    }
    
    func startFollowing(userId: String) {
        self.following[userId] = true;
    }
    
    func logout() {
        manuallyLoggedOut = true
    }
}