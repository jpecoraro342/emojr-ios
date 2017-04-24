//
//  TimelineEnum.swift
//  Emojr
//
//  Created by James on 2/19/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import Foundation

enum Timeline {
    case home, discover, user(user: UserData?)
}

extension Timeline {
    var navigationTitle: String {
        switch self {
        case .home:
            return "Home"
        case .discover:
            return "Hot"
        case .user(let user):
            return user?.username ?? User.sharedInstance.username!
        }
    }
    
    var noDataMessage: String {
        switch self {
        case .home:
            return "There aren't any posts here! Try following some more users to see their posts!"
        case .discover:
            return "There aren't any posts here! Check your connection and hope more users show up soon!"
        case .user(let user):
            if user?.id == User.sharedInstance.id {
                return "There aren't any posts here! Looks like you haven't posted anything yet!"
            } else {
                return "This user doesn't have any posts! Tell them to get postin'!"
            }
            
        }
    }
    
    var dataSource: TimelineTableViewDataSource {
        return TimelineTableViewDataSource(with: self)
    }
}
