//
//  Analytics.swift
//  Emojr
//
//  Created by James on 4/5/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import Foundation
import FirebaseAnalytics

struct Analytics {
    static func log(log: Log) {
        log.log()
    }
}

enum Log {
    case post(userID: String)
    case reaction(userID: String)
}

extension Log {
    fileprivate func log() {
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: self.parameters())
    }
    
    fileprivate func parameters() -> [String: NSObject] {
        switch self {
        case .post(let userID):
            return ["userID": userID as NSObject]
        case .reaction(let userID):
            return ["userID": userID as NSObject]
        }
    }
}
