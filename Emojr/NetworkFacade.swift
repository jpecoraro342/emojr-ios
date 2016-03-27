//
//  NetworkFacade.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

import Foundation

class NetworkFacade : NSObject {

    let dataAccessor : NetworkingAccessor;
    
    override init() {
        // TODO: pass data accessor and socket to use in the init method
        dataAccessor = RestNetworkAccessor();
        // dataAccessor = DummyNetworkAccessor();
        
        super.init();
    }
    
    // GET
    func isUsernameAvailable(username: String, completionBlock: BooleanClosure?) {
        dataAccessor.isUsernameAvailable(username, completionBlock: completionBlock)
    }
    
    func getAllUsers(completionBlock: UserArrayClosure?) {
        dataAccessor.getAllUsers(completionBlock)
    }
    
    func getAllFollowing(userId: String, completionBlock: UserArrayClosure?) {
        dataAccessor.getAllFollowing(userId, completionBlock: completionBlock)
    }
    
    func getAllFollowers(userId: String, completionBlock: UserArrayClosure?) {
        dataAccessor.getAllFollowers(userId, completionBlock: completionBlock)
    }
    
    func getPost(postId: String, completionBlock: PostClosure?) {
        dataAccessor.getPost(postId, completionBlock: completionBlock)
    }
    
    func getAllPostsFromUser(userId: String, completionBlock: PostArrayClosure?) {
        dataAccessor.getAllPostsFromUser(userId, completionBlock: completionBlock)
    }
    
    func getAllFollowingPosts(userId: String, completionBlock: PostArrayClosure?) {
        dataAccessor.getAllFollowingPosts(userId, completionBlock: completionBlock)
    }
    
    // POST
    func startFollowingUser(userId: String, userIdToFollow: String, completionBlock: BooleanClosure?) {
        dataAccessor.startFollowingUser(userId, userIdToFollow: userIdToFollow, completionBlock: completionBlock)
    }
    
    func signUpUser(username: String, password: String, fullname: String, completionBlock: UserDataClosure?) {
        dataAccessor.signUpUser(username, password: password, fullname: fullname, completionBlock: completionBlock)
    }
    
    func signInUser(username: String, password: String, completionBlock: UserDataClosure?) {
        dataAccessor.signInUser(username, password: password, completionBlock: completionBlock)
    }
    
    func createPost(userId: String, post: String, completionBlock: PostClosure?) {
        dataAccessor.createPost(userId, post: post, completionBlock: completionBlock)
    }
    
    func reactToPost(username: String, postId: String, reaction: String, completionBlock: ReactionClosure?) {
        dataAccessor.reactToPost(username, postId: postId, reaction: reaction, completionBlock: completionBlock)
    }
}


