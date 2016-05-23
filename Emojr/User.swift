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
    
    func configureWithUserData(data: UserData) {
        self.id = data.id
        self.username = data.username
        self.fullname = data.fullname
        
        AnalyticsManager.sharedInstance.setupUser(data)
        self.userData = data
    }
    
    func logout() {
        
    }
}