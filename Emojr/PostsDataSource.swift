//
//  PostsDataSource.swift
//  Emojr
//
//  Created by James on 2/19/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import Foundation

protocol PostsDataSource {
    func getFirstPage()
    func getNextPage()
}

class DiscoverPostsDataSource: TimelineTableViewDataSource, PostsDataSource {
    func getFirstPage() {
        getPosts(withRequest: Router.DiscoverPosts(lastCreatedDate: nil), shouldRefresh: true)
    }
    
    func getNextPage() {
        getPosts(withRequest: Router.DiscoverPosts(lastCreatedDate: lastCreatedDate), shouldRefresh: false)
    }
}

class UserPostsDataSource: TimelineTableViewDataSource, PostsDataSource {
    var user: UserData?
    
    func getFirstPage() {
        if let id = user?.id {
            getPosts(withRequest: Router.UserPosts(userID: id, lastCreatedDate: nil), shouldRefresh: true)
        }
    }
    
    func getNextPage() {
        if let id = user?.id {
            getPosts(withRequest: Router.UserPosts(userID: id, lastCreatedDate: lastCreatedDate), shouldRefresh: false)
        }
    }
}

class FollowingPostsDataSource: TimelineTableViewDataSource, PostsDataSource {
    var user: UserData?
    
    func getFirstPage() {
        if let id = user?.id {
            getPosts(withRequest: Router.FollowingPosts(userID: id, lastCreatedDate: nil), shouldRefresh: true)
        }
    }
    
    func getNextPage() {
        if let id = user?.id {
            getPosts(withRequest: Router.FollowingPosts(userID: id, lastCreatedDate: lastCreatedDate), shouldRefresh: false)
        }
    }
}
