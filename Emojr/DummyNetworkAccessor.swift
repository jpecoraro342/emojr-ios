//
//  DataAccessor.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/25/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation

class DummyNetworkAccessor: NSObject, NetworkingAccessor {
    
    let userDictionary: Dictionary<String, UserData> = Dictionary<String, UserData>();
    let userPostDictionary: Dictionary<String, Post> = Dictionary<String, Post>();
    
    let postDictionary: Dictionary<String, Post> = Dictionary<String, Post>();
    let reactionDictionary: Dictionary<String, Reaction> = Dictionary<String, Reaction>();
    
    let defaultError: NSError = NSError(domain: networkErrorDomain, code: 0, userInfo: [ NSLocalizedDescriptionKey : "It's dummy data, how did you screw it up?" ]);
    
    override init() {
        super.init();
    }
    
    // GET
    func isUsernameAvailable(username: String, completeionBlock: BooleanClosure) {
        
    }
    
    func getAllUsers(completionBlock: UserArrayClosure) {
        
    }
    
    func getAllFollowing(userId: String, completionBlock: UserArrayClosure) {
        
    }
    
    func getAllFollowers(userId: String, completionBlock: UserArrayClosure) {
        
    }
    
    // func getAllPosts(completionBlock: PostArrayClosure);
    func getPost(postId: String, completionBlock: PostClosure) {
        
    }
    
    func getAllPostsFromUser(userId: String, completionBlock: PostArrayClosure) {
        
    }
    
    // POST
    func startFollowingUser(userId: String, usernameToFollow: String, completionBlock: BooleanClosure) {
        
    }
    
    func signUpUser(username: String, password: String, completionBlock: UserDataClosure) {
        
    }
    
    func signInUser(username: String, password: String, completionBlock: UserDataClosure) {
        
    }
    
    func createPost(userId: String, post: String, completionBlock: PostClosure) {
        
    }
    
    func reactToPost(userId: String, postId: String, reaction: String, completionBlock: ReactionClosure) {
        
    }
    
    // Utility
    
    func initializeDummyData() {
        
    }
    
    func URLStringWithExtension(urlExtension: String) -> String {
        return "\(baseURL)/\(urlExtension)";
    }
}
    