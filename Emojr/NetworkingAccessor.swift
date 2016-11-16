//
//  NetworkingAccessor.swift
//  SplitStreamr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

protocol NetworkingAccessor {
    
    // GET
    func isUsernameAvailable(_ username: String, completionBlock: BooleanClosure?);
    func getUsers(_ searchString: String?, completionBlock: UserArrayClosure?);
    
    func getAllFollowing(_ userId: String, completionBlock: UserArrayClosure?);
    func getAllFollowers(_ userId: String, completionBlock: UserArrayClosure?);
    
    // func getAllPosts(completionBlock: PostArrayClosure);
    func getPost(_ postId: String, completionBlock: PostClosure?);
    func getDiscoverPosts(completionBlock: PostArrayClosure?)
    func getAllPostsFromUser(_ userId: String, completionBlock: PostArrayClosure?);
    
    func getAllFollowingPosts(_ userId: String, completionBlock: PostArrayClosure?);
    
    // POST
    func startFollowingUser(_ userId: String, userIdToFollow: String, completionBlock: BooleanClosure?);
    
    func signUpUser(_ username: String, password: String, completionBlock: UserDataClosure?);
    func signInUser(_ username: String, password: String, completionBlock: UserDataClosure?);
    
    func createPost(_ userId: String, post: String, completionBlock: PostClosure?);
    func reactToPost(_ userId: String, postId: String, reaction: String, completionBlock: ReactionClosure?);
    
    // DELETE
    func stopFollowingUser(_ userId: String, userIdToStopFollowing: String, completionBlock: BooleanClosure?);
}
