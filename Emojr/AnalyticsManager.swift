//
//  AnalyticsManager.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 5/19/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation
import Crashlytics

struct AnalyticsManager {
    static func setupUser(_ user: UserData) {
        setupCrashlyticsUser(user)
    }
    
    static func setupCrashlyticsUser(_ user: UserData) {
        Crashlytics.sharedInstance().setUserIdentifier(user.id)
        Crashlytics.sharedInstance().setUserName(user.username)
    }
}
