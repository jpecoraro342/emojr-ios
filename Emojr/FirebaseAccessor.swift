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

typealias FilterBlock = ([Post]) -> [Post]

class FirebaseAccessor: NetworkingAccessor {
    struct Constants {
        static let pageSize: UInt = 100
    }
    
    static let shared = FirebaseAccessor()
    
    let database = FIRDatabase.database().reference()
    let auth = FIRAuth.auth()
    
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
        let postRef = database.child("posts/\(postId)")
        
        postRef.observeSingleEvent(of: .value, with: { snapshot in
            self.buildPost(from: snapshot, withCallback: completionBlock)
        })
    }
    
    func getDiscoverPosts(lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        getAllPosts(fromKey: lastEvaluatedKey, withCallback: completionBlock)
    }
    
    func getAllPostsFromUser(_ userId: String, lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        let filterBlock: FilterBlock = { posts in
            posts.filter { $0.user?.id == userId }
        }
        
        getAllPosts(fromKey: lastEvaluatedKey, andManipulateWith: filterBlock, withCallback: completionBlock)
    }
    
    func getAllFollowingPosts(_ userId: String, lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        let followRef = database.child("follows/\(userId)")
        followRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let children = snapshot.children.allObjects as? [FIRDataSnapshot] else {
                let error = NSError(domain: "Firebase", code: 404, userInfo: nil)
                completionBlock?(error, nil)
                return
            }
            
            var keys: [String] = []
            
            for child in children {
                keys.append(child.key)
            }
            
            let filterBlock: FilterBlock = { posts in
                posts.filter { keys.contains($0.user?.id ?? "") }
            }
            
            self.getAllPosts(fromKey: lastEvaluatedKey, andManipulateWith: filterBlock, withCallback: completionBlock)
        })
    }
    
    // POST
    func startFollowingUser(_ userId: String, userIdToFollow: String, completionBlock: BooleanClosure?) {
        let newFollowRef = self.database.child("follows/\(userId)")
        
        newFollowRef.setValue([userIdToFollow: true])
    }
    
    func signUpUser(_ username: String, email: String, password: String, completionBlock: UserDataClosure?) {
        auth?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                completionBlock?("Couldn't sign up! Please try again.", nil)
            } else if let user = user {
                let request = user.profileChangeRequest()
                request.displayName = username
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        print("Error setting username: \(error.localizedDescription)")
                    }
                })
                
                let user = UserData(username: username, id: user.uid)
                
                completionBlock?(nil, user)
                
            } else {
                 print("Unknown error creating user")
                completionBlock?("Couldn't sign up! Please try again.", nil)
            }
        })
    }
    
    func signInUser(_ email: String, password: String, completionBlock: UserDataClosure?) {
        auth?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                
                completionBlock?("Couldn't sign in! Are you trying to sign up instead?", nil)
            } else if let user = user {
                let user = UserData(username: user.displayName ?? "", id: user.uid)
                
                completionBlock?(nil, user)
            } else {
                print("Unknown error creating user")
                completionBlock?("Couldn't sign in! Please try again.", nil)
            }
        })
    }
    
    func createPost(_ userId: String, post: String, completionBlock: PostClosure?) {
        let newPostRef = database.child("posts").childByAutoId()
        
        let user = User.sharedInstance
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let created = dateFormatter.string(from: Date())
        
        newPostRef.setValue(["userID": user.id ?? "",
                             "username": user.username ?? "",
                             "text": post,
                             "created": created])
        
        let newPost = Post(key: newPostRef.key,
                           user: user.userData!,
                           post: post,
                           reactions: [],
                           created: created)
        
        completionBlock?(nil, newPost)
    }
    
    func reactToPost(_ userId: String, postId: String, reaction: String, completionBlock: ReactionClosure?) {
        let newReactionRef = database.child("reactions/\(postId)").childByAutoId()
        
        newReactionRef.setValue(["userID": userId,
                                 "text": reaction])
        
        let newReaction = Reaction(id: newReactionRef.key,
                                   userID: User.sharedInstance.userData!.id,
                                   reaction: reaction,
                                   created: Date())
        
        completionBlock?(nil, newReaction)
    }
    
    // DELETE
    func stopFollowingUser(_ userId: String, userIdToStopFollowing: String, completionBlock: BooleanClosure?) {
        let newFollowRef = self.database.child("follows/\(userId)/\(userIdToStopFollowing)")
        
        newFollowRef.removeValue()
    }

    // MARK: - Helpers
    
    func postsQuery(withKey lastEvaluatedKey: String?) -> FIRDatabaseQuery {
        let postsRef = database.child("posts")
        
        var query = postsRef.queryOrderedByKey()
        var pageSize = Constants.pageSize
        
        if let lastEvaluatedKey = lastEvaluatedKey {
            query = query.queryStarting(atValue: lastEvaluatedKey)
            pageSize += 1
        }
        
        return query.queryLimited(toFirst: pageSize)
    }
    
    func buildPost(from snapshot: FIRDataSnapshot, withCallback callback: PostClosure?) {
        if let postData = snapshot.value as? [String : AnyObject],
            let userID = postData["userID"] as? String,
            let username = postData["username"] as? String,
            let postText = postData["text"] as? String,
            let created = postData["created"] as? String {
            
            var post = Post(key: snapshot.key,
                            user: UserData(username: username, id: userID),
                            post: postText,
                            reactions: [],
                            created: created)
            
            self.database.child("reactions/\(snapshot.key)")
                .queryOrderedByKey()
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let children = snapshot.children.allObjects as? [FIRDataSnapshot] else {
                        callback?(nil, nil)
                        return
                    }
                    
                    post.reactions = reactions(from: children)
                    
                    callback?(nil, post)
                })
        }
    }
    
    private func getAllPosts(fromKey lastEvaluatedKey: String?,
                             andManipulateWith filterBlock: FilterBlock? = nil,
                             withCallback completionBlock: PostArrayClosure?) {
        
        var returnPosts: [Post] = []
        
        postsQuery(withKey: lastEvaluatedKey).observeSingleEvent(of: .value, with: { (snapshot) in
            guard var children = snapshot.children.allObjects as? [FIRDataSnapshot] else {
                let error = NSError(domain: "Firebase", code: 404, userInfo: nil)
                completionBlock?(error, nil)
                return
            }
            
            if (lastEvaluatedKey != nil) && !children.isEmpty {
                children.removeFirst()
            }
            
            let group = DispatchGroup()
            
            for child in children {
                if let postData = child.value as? [String : AnyObject],
                    let userID = postData["userID"] as? String,
                    let username = postData["username"] as? String,
                    let postText = postData["text"] as? String,
                    let created = postData["created"] as? String {
                    
                    group.enter()
                    
                    var post = Post(key: child.key,
                                    user: UserData(username: username, id: userID),
                                    post: postText,
                                    reactions: [],
                                    created: created)
                    
                    self.database.child("reactions/\(child.key)")
                        .queryOrderedByKey()
                        .observeSingleEvent(of: .value, with: { (snapshot) in
                            guard let children = snapshot.children.allObjects as? [FIRDataSnapshot] else {
                                group.leave()
                                return
                            }
                            
                            post.reactions = reactions(from: children)
                            
                            returnPosts.insert(post, at: 0)
                            
                            group.leave()
                        })
                }
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                if let filter = filterBlock {
                    returnPosts = filter(returnPosts)
                }
                
                completionBlock?(nil, returnPosts)
            })
        })
    }
}

/*
 Posts: {
    postID: {
         userID: String
         username: String
         text: String
         created: String
    }
 }
 
 
 Reactions: {
    postID: {
        userID: String
        text: String
    }
 }
 
 Follows: {
    userID: {
        followedUserID: Bool
    }
 }
 */
