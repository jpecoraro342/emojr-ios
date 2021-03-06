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
    
    let database = Database.database().reference()
    let auth = Auth.auth()
    
    // GET
    func getUsers(_ searchString: String?, completionBlock: UserArrayClosure?) {
        // TODO: Figure out how to scalably search all users for a name
        
        database.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            self.getUsers(from: snapshot, withCallback: { (error, users) in
                if let error = error {
                    log.debug("Error getting all users")
                    completionBlock?(error, nil)
                    return
                } else if let users = users {
                    let filteredUsers = users.filter {
                        (searchString != nil && $0.username != nil) ? $0.username!.contains(searchString!) : true
                    }
                    
                    completionBlock?(nil, filteredUsers)
                }
            })
        })
    }
    
    func getAllFollowing(_ userId: String, completionBlock: UserArrayClosure?) {
        database.child("follows/\(userId)").observeSingleEvent(of: .value, with: { (snapshot) in
            self.getUsers(from: snapshot, withCallback: completionBlock)
        })
    }
    
    func getAllFollowers(_ userId: String, completionBlock: UserArrayClosure?) {
        database.child("followers/\(userId)").observeSingleEvent(of: .value, with: { (snapshot) in
            self.getUsers(from: snapshot, withCallback: completionBlock)
        })
    }
    
    func getPost(_ postId: String, completionBlock: PostClosure?) {
        let postRef = database.child("allPosts/\(postId)")
        
        postRef.observeSingleEvent(of: .value, with: { snapshot in
            self.buildPost(from: snapshot, withCallback: completionBlock)
        })
    }
    
    func getDiscoverPosts(lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        let postsRef = database.child("allPosts").queryOrderedByKey()
        
        postsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.getPosts(from: snapshot, withCallback: completionBlock)
        })
    }
    
    func getAllPostsFromUser(_ userId: String, lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        let postsRef = database.child("userPosts/\(userId)").queryOrderedByKey()
        
        postsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.getPosts(from: snapshot, withCallback: completionBlock)
        })
    }
    
    func getAllFollowingPosts(_ userId: String, lastEvaluatedKey: String?, completionBlock: PostArrayClosure?) {
        let postsRef = database.child("timeline/\(userId)").queryOrderedByKey()
        
        postsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.getPosts(from: snapshot, withCallback: completionBlock)
        })
    }
    
    // POST
    func startFollowingUser(_ userId: String, userIdToFollow: String, completionBlock: BooleanClosure?) {
        self.database.child("follows/\(userId)/\(userIdToFollow)").setValue(true)
        
        self.database.child("followers/\(userIdToFollow)/\(userId)").setValue(true)
        
        completionBlock?(true)
    }
    
    func signUpUser(_ username: String, email: String, password: String, completionBlock: UserDataClosure?) {
        self.database.child("usernames/\(username)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                self.auth.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if let error = error {
                        log.debug("Error creating user: \(error.localizedDescription)")
                        completionBlock?("Couldn't sign up! \(error.localizedDescription )", nil)
                    } else if let user = user {
                        let request = user.createProfileChangeRequest()
                        request.displayName = username
                        request.commitChanges(completion: { (error) in
                            if let error = error {
                                log.debug("Error setting username: \(error.localizedDescription)")
                            }
                        })
                        
                        self.database.child("usernames/\(username)").setValue(user.uid)
                        self.database.child("users/\(user.uid)").setValue(username)
                        
                        let user = UserData(username: username, id: user.uid)
                        
                        completionBlock?(nil, user)
                    } else {
                        log.debug("Unknown error creating user")
                        completionBlock?("Couldn't sign up! Please try again.", nil)
                    }
                })
            } else {
                completionBlock?("Username taken! Please choose another.", nil)
            }
        })
    }
    
    func signInUser(_ email: String, password: String, completionBlock: UserDataClosure?) {
        auth.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                log.debug("Error signing in user: \(error.localizedDescription)")
                
                completionBlock?("Couldn't sign in! Are you trying to sign up instead?", nil)
            } else if let user = user {
                let user = UserData(username: user.displayName ?? "", id: user.uid)
                
                completionBlock?(nil, user)
            } else {
                log.debug("Unknown error signing in user")
                completionBlock?("Couldn't sign in! Please try again.", nil)
            }
        })
    }
    
    func createPost(_ userId: String, post: String, completionBlock: PostClosure?) {
        let user = User.sharedInstance
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let created = dateFormatter.string(from: Date())
        
        let postValue: [String: AnyObject] = ["userID": user.id as AnyObject? ?? "" as AnyObject,
                                              "username": user.username as AnyObject? ?? "" as AnyObject,
                                              "text": post as AnyObject,
                                              "created": created as AnyObject]
        
        let newPostRef = database.child("allPosts").childByAutoId()
        let followersRef = database.child("followers/\(userId)")
        
        followersRef.observeSingleEvent(of: .value, with: { snapshot in
            var fanoutObject: [String: AnyObject] = [:]
            
            // Add post to each of the user's follower's timeline
            let followersData = snapshot.value as? [String: AnyObject]
            if let followers = followersData?.keys {
                followers.forEach {
                    fanoutObject["/timeline/\($0)/\(newPostRef.key)"] = postValue as AnyObject?
                }
            }
            
            // Add post to the all posts list for Discover
            fanoutObject["allPosts/\(newPostRef.key)"] = postValue as AnyObject?
            
            // Add post to the posting user's feed
            fanoutObject["userPosts/\(userId)/\(newPostRef.key)"] = postValue as AnyObject?
            
            // Update all values in the fanout dictionary
            self.database.updateChildValues(fanoutObject)
        })
        
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
        database.child("follows/\(userId)/\(userIdToStopFollowing)").removeValue()
        
        database.child("followers//\(userIdToStopFollowing)/\(userId)").removeValue()
        
        completionBlock?(true)
    }

    // MARK: - Helpers
    
    private func getUsers(from snapshot: DataSnapshot, withCallback callback: UserArrayClosure?) {
        var returnUsers: [UserData] = []
        
        guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
            callback?(NSError(domain: "Firebase", code: 404, userInfo: nil), nil)
            return
        }
        
        let group = DispatchGroup()
        
        for child in children {
            group.enter()
            
            var thisUser = UserData(username: "", id: child.key)
            
            database.child("users/\(child.key)").observeSingleEvent(of: .value, with: { (usernameSnapshot) in
                if let username = usernameSnapshot.value as? String {
                    thisUser.username = username
                    
                    returnUsers.append(thisUser)
                }
                
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            callback?(nil, returnUsers)
        })
    }
    
    private func buildPost(from snapshot: DataSnapshot, withCallback callback: PostClosure?) {
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
                    guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                        callback?(nil, nil)
                        return
                    }
                    
                    post.reactions = reactions(from: children)
                    
                    callback?(nil, post)
                })
        }
    }
    
    private func getPosts(from snapshot: DataSnapshot, withCallback callback: PostArrayClosure?) {
        
        var returnPosts: [Post] = []
        
        guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
            callback?(NSError(domain: "Firebase", code: 404, userInfo: nil), nil)
            return
        }
        
        let group = DispatchGroup()
        
        for child in children {
            group.enter()
            
            buildPost(from: child, withCallback: { (error, post) in
                
                if let post = post {
                    returnPosts.insert(post, at: 0)
                }
                
                if let error = error {
                    log.debug("Error building post: \(error.localizedDescription)")
                }
                
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            callback?(nil, returnPosts)
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
