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
            return "Discover"
        case .user(let user):
            return user?.username ?? User.sharedInstance.username!
        }
    }
    
    var noDataMessage: String {
        switch self {
        case .home:
            return "There aren't any posts here! Try following some more users to see their posts!"
        case .discover:
            return "There aren't any posts here! Check you connection and hope more users show up soon!"
        case .user(let user):
            if user == nil {
                return "There aren't any posts here! Looks like you haven't posted anything yet!"
            } else {
                return "This user doesn't have any posts! Tell them to get postin'!"
            }
            
        }
    }
    
    var dataSource: TimelineTableViewDataSource {
        switch self {
        case .home:
            let source = FollowingPostsDataSource()
            source.user = User.sharedInstance.userData
            return source
        case .discover:
            return DiscoverPostsDataSource()
        case .user(let user):
            let source = UserPostsDataSource()
            source.user = user ?? User.sharedInstance.userData
            return source
        }
    }
}
