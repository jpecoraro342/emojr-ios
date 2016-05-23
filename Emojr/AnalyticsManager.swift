//
//  AnalyticsManager.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 5/19/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation
import Crashlytics

class AnalyticsManager: NSObject {
    
    static let sharedInstance = AnalyticsManager()
    
    func setupUser(user: UserData) {
        setupCrashlyticsUser(user)
    }
    
    private func setupCrashlyticsUser(user: UserData) {
        Crashlytics.sharedInstance().setUserIdentifier(user.id)
        Crashlytics.sharedInstance().setUserName(user.username)
    }
    
}
