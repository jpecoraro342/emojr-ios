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
        dataAccessor = FirebaseAccessor()
        
        super.init();
    }
    
    // GET
    
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
    
    func getDiscoverPosts(lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        dataAccessor.getDiscoverPosts(lastEvaluatedKey: lastEvaluatedKey, completionBlock: completionBlock)
    }
    
    func getAllPostsFromUser(_ userId: String, lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        dataAccessor.getAllPostsFromUser(userId, lastEvaluatedKey: lastEvaluatedKey, completionBlock: completionBlock)
    }
    
    func getAllFollowingPosts(_ userId: String, lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        dataAccessor.getAllFollowingPosts(userId, lastEvaluatedKey: lastEvaluatedKey, completionBlock: completionBlock)
    }
    
    // POST
    func startFollowingUser(_ userId: String, userIdToFollow: String, completionBlock: BooleanClosure?) {
        dataAccessor.startFollowingUser(userId, userIdToFollow: userIdToFollow, completionBlock: completionBlock)
    }
    
    func signUpUser(_ username: String, email: String, password: String, completionBlock: UserDataClosure?) {
        dataAccessor.signUpUser(username, email: email, password: password, completionBlock: completionBlock)
    }
    
    func signInUser(_ email: String, password: String, completionBlock: UserDataClosure?) {
        dataAccessor.signInUser(email, password: password, completionBlock: completionBlock)
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
