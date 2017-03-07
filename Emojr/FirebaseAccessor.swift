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
        
    }
    
    func getDiscoverPosts(lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        let postsRef = database.child("posts")
        
        var query = postsRef.queryOrderedByKey()
        var pageSize = 100
        
        if let lastEvaluatedKey = lastEvaluatedKey {
            query = query.queryStarting(atValue: lastEvaluatedKey)
            pageSize += 1
        }
        
        var returnPosts: [Post] = []
        
        query.queryLimited(toFirst: UInt(pageSize)).observeSingleEvent(of: .value, with: { (snapshot) in
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
                                return
                            }
                        
                            post.reactions = reactions(from: children)
                            
                            returnPosts.append(post)
                            
                            group.leave()
                        })
                }
            }
            
            group.notify(queue: DispatchQueue.main, execute: { 
                completionBlock?(nil, returnPosts)
            })
        })
    }
    
    func getAllPostsFromUser(_ userId: String, lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        
    }
    
    func getAllFollowingPosts(_ userId: String, lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        
    }
    
    // POST
    func startFollowingUser(_ userId: String, userIdToFollow: String, completionBlock: BooleanClosure?) {
        
    }
    
    func signUpUser(_ username: String, email: String, password: String, completionBlock: UserDataClosure?) {
        auth?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
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
            }
        })
    }
    
    func signInUser(_ email: String, password: String, completionBlock: UserDataClosure?) {
        auth?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
            } else if let user = user {
                let user = UserData(username: user.displayName ?? "", id: user.uid)
                
                completionBlock?(nil, user)
            } else {
                print("Unknown error creating user")
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
        
    }
}
