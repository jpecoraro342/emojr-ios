//
//  FirebaseAccessor.swift
//  Emojr
//
//  Created by James on 2/26/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FirebaseAccessor: NetworkingAccessor {
    
    static let shared = FirebaseAccessor()
    
    let database = FIRDatabase.database().reference()
    
    // GET
    func isUsernameAvailable(_ username: String, completionBlock: BooleanClosure?) {
        
    }
    
    func getUsers(_ searchString: String?, completionBlock: UserArrayClosure?) {
        
    }
    
    func getAllFollowing(_ userId: String, completionBlock: UserArrayClosure?) {
        
    }
    
    func getAllFollowers(_ userId: String, completionBlock: UserArrayClosure?) {
        
    }
    
    func getPost(_ postId: String, completionBlock: PostClosure?) {
        
    }
    
    func getDiscoverPosts(lastCreatedDate: Date?, completionBlock: PostArrayClosure?) {
        
    }
    
    func getAllPostsFromUser(_ userId: String, lastCreatedDate: Date?, completionBlock: PostArrayClosure?) {
        
    }
    
    func getAllFollowingPosts(_ userId: String, lastCreatedDate: Date?, completionBlock: PostArrayClosure?) {
        
    }
    
    // POST
    func startFollowingUser(_ userId: String, userIdToFollow: String, completionBlock: BooleanClosure?) {
        
    }
    
    func signUpUser(_ username: String, password: String, completionBlock: UserDataClosure?) {
        
    }
    
    func signInUser(_ username: String, password: String, completionBlock: UserDataClosure?) {
        
    }
    
    func createPost(_ userId: String, post: String, completionBlock: PostClosure?) {
        
    }
    
    func reactToPost(_ userId: String, postId: String, reaction: String, completionBlock: ReactionClosure?) {
        
    }
    
    // DELETE
    func stopFollowingUser(_ userId: String, userIdToStopFollowing: String, completionBlock: BooleanClosure?) {
        
    }
}
