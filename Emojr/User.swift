//
//  User.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/25/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation
import Crashlytics

class User : NSObject {
    
    static let sharedInstance = User()
    
    var id: String?
    var username: String?
    var fullname: String?
    
    var userData: UserData?
    
    func configureWithUserData(data: UserData) {
        self.id = data.id
        self.username = data.username
        self.fullname = data.fullname
        
        self.setupCrashlyticsUser(data)
        self.userData = data
    }
    
    func setupCrashlyticsUser(user: UserData) {
        Crashlytics.sharedInstance().setUserIdentifier(user.id)
        Crashlytics.sharedInstance().setUserName(user.username)
    }
    
    
    func logout() {
        
    }
}