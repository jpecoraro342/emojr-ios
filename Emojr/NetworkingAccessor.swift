//
//  NetworkingAccessor.swift
//  SplitStreamr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

protocol NetworkingAccessor {
    
    // GET
    func isUsernameAvailable(username: String, completionBlock: BooleanClosure?);
    func getAllUsers(completionBlock: UserArrayClosure?);
    
    func getAllFollowing(userId: String, completionBlock: UserArrayClosure?);
    func getAllFollowers(userId: String, completionBlock: UserArrayClosure?);
    
    // func getAllPosts(completionBlock: PostArrayClosure);
    func getPost(postId: String, completionBlock: PostClosure?);
    func getAllPostsFromUser(userId: String, completionBlock: PostArrayClosure?);
    
    func getAllFollowingPosts(userId: String, completionBlock: PostArrayClosure?);
    
    // POST
    func startFollowingUser(userId: String, usernameToFollow: String, completionBlock: BooleanClosure?);
    
    func signUpUser(username: String, password: String, fullname: String, completionBlock: UserDataClosure?);
    func signInUser(username: String, password: String, completionBlock: UserDataClosure?);
    
    func createPost(userId: String, post: String, completionBlock: PostClosure?);
    func reactToPost(userId: String, postId: String, reaction: String, completionBlock: ReactionClosure?);
    
}
