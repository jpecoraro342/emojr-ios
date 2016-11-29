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
    
    var userData: UserData?
    
    var isLoggedIn = false
    
    var followers = Dictionary<String, Bool>()
    var following = Dictionary<String, Bool>()
    
    var manuallyLoggedOut: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "manuallyLoggedOut")
        }
        get {
            return UserDefaults.standard.bool(forKey: "manuallyLoggedOut")
        }
    }
    
    func configureWithUserData(_ data: UserData) {
        manuallyLoggedOut = false
        isLoggedIn = true
        
        self.id = data.id
        self.username = data.username
        
        AnalyticsManager.setupUser(data)
        self.userData = data
        
        updateFollowers()
        updateFollowing()
    }
    
    func updateFollowers() {
        guard let userId = id
            else { return }
        
        NetworkFacade().getAllFollowers(userId, completionBlock: { (error, list) -> Void in
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
        
        NetworkFacade().getAllFollowing(userId, completionBlock: { (error, list) -> Void in
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
    
    func stopFollowing(_ userId: String) {
        self.following[userId] = false;
    }
    
    func startFollowing(_ userId: String) {
        self.following[userId] = true;
    }
    
    func logout() {
        manuallyLoggedOut = true
        isLoggedIn = false
        
        self.id = nil
        self.username = nil
        self.userData = nil
    }
}
