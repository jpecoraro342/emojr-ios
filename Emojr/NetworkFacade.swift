//
//  NetworkFacade.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

import Foundation

class NetworkFacade : NSObject {

    static let sharedInstance = NetworkFacade()
    
    let dataAccessor : NetworkingAccessor;
    
    override init() {
        // TODO: pass data accessor and socket to use in the init method
        //dataAccessor = RestAccessor();
        //dataAccessor = DummyNetworkAccessor();
        dataAccessor = FirebaseAccessor()
        
        super.init();
    }
    
    // GET
    func isUsernameAvailable(_ username: String, completionBlock: BooleanClosure?) {
        dataAccessor.isUsernameAvailable(username, completionBlock: completionBlock)
    }
    
    func getUsers(_ searchString: String?=nil, completionBlock: UserArrayClosure?) {
        dataAccessor.getUsers(searchString, completionBlock: completionBlock)
    }
    
    func getAllFollowing(_ userId: String, completionBlock: UserArrayClosure?) {
        dataAccessor.getAllFollowing(userId, completionBlock: completionBlock)
    }
    
    func getAllFollowers(_ userId: String, completionBlock: UserArrayClosure?) {
        dataAccessor.getAllFollowers(userId, completionBlock: completionBlock)
    }
    
    func getPost(_ postId: String, completionBlock: PostClosure?) {
        dataAccessor.getPost(postId, completionBlock: completionBlock)
    }
    
    func getDiscoverPosts(lastCreatedDate: Date?, completionBlock: PostArrayClosure?) {
        dataAccessor.getDiscoverPosts(lastCreatedDate: lastCreatedDate, completionBlock: completionBlock)
    }
    
    func getAllPostsFromUser(_ userId: String, lastCreatedDate: Date?, completionBlock: PostArrayClosure?) {
        dataAccessor.getAllPostsFromUser(userId, lastCreatedDate: lastCreatedDate, completionBlock: completionBlock)
    }
    
    func getAllFollowingPosts(_ userId: String, lastCreatedDate: Date?, completionBlock: PostArrayClosure?) {
        dataAccessor.getAllFollowingPosts(userId, lastCreatedDate: lastCreatedDate, completionBlock: completionBlock)
    }
    
    // POST
    func startFollowingUser(_ userId: String, userIdToFollow: String, completionBlock: BooleanClosure?) {
        dataAccessor.startFollowingUser(userId, userIdToFollow: userIdToFollow, completionBlock: completionBlock)
    }
    
    func signUpUser(_ username: String, password: String, completionBlock: UserDataClosure?) {
        dataAccessor.signUpUser(username, password: password, completionBlock: completionBlock)
    }
    
    func signInUser(_ username: String, password: String, completionBlock: UserDataClosure?) {
        dataAccessor.signInUser(username, password: password, completionBlock: completionBlock)
    }
    
    func createPost(_ userId: String, post: String, completionBlock: PostClosure?) {
        dataAccessor.createPost(userId, post: post, completionBlock: completionBlock)
    }
    
    func reactToPost(_ userId: String, postId: String, reaction: String, completionBlock: ReactionClosure?) {
        dataAccessor.reactToPost(userId, postId: postId, reaction: reaction, completionBlock: completionBlock)
    }
    
    // DELETE
    func stopFollowingUser(_ userId: String, userIdToStopFollowing: String, completionBlock: BooleanClosure?) {
        dataAccessor.stopFollowingUser(userId, userIdToStopFollowing: userIdToStopFollowing, completionBlock: completionBlock)
    }
}
