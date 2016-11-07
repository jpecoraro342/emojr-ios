//
//  DataAccessor.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/25/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation

class DummyNetworkAccessor: NSObject, NetworkingAccessor {
    var userDictionary: Dictionary<String, UserData> = Dictionary<String, UserData>()
    var usernameDictionary: Dictionary<String, UserData> = Dictionary<String, UserData>()
    var userFollowingDictionary: Dictionary<String, [UserData]> = Dictionary<String, [UserData]>()
    
    var postDictionary: Dictionary<String, Post> = Dictionary<String, Post>()
    var reactionDictionary: Dictionary<String, Reaction> = Dictionary<String, Reaction>()
    
    let defaultError: NSError = NSError(domain: networkErrorDomain, code: 0, userInfo: [ NSLocalizedDescriptionKey : "It's dummy data, how did you screw it up?" ])
    
    override init() {
        super.init()
        
        initializeDummyData()
    }
    
    // GET
    func isUsernameAvailable(_ username: String, completionBlock: BooleanClosure?) {
        if let _ = usernameDictionary[username] {
            completionBlock?(false)
            return
        }
        
        completionBlock?(true)
    }
    
    func getUsers(_ searchString: String?=nil, completionBlock: UserArrayClosure?) {
        completionBlock?(nil, Array(userDictionary.values))
    }
    
    func getAllFollowing(_ userId: String, completionBlock: UserArrayClosure?) {
        completionBlock?(nil, userFollowingDictionary[userId])
    }
    
    func getAllFollowers(_ userId: String, completionBlock: UserArrayClosure?) {
        var followers = [UserData]();
        
        for (user, followingList) in userFollowingDictionary {
            if user == userId {
                continue
            }
            
            if followingList.contains(userDictionary[userId]!) {
                followers.append(userDictionary[user]!)
            }
        }
        
        completionBlock?(nil, followers)
    }
    
    // func getAllPosts(completionBlock: PostArrayClosure);
    func getPost(_ postId: String, completionBlock: PostClosure?) {
        completionBlock?(nil, postDictionary[postId])
    }
    
    func getDiscoverPosts(_ userId: String?=nil, completionBlock: PostArrayClosure?) {
        completionBlock?(nil, Array(postDictionary.values))
    }
    
    func getAllPostsFromUser(_ userId: String, completionBlock: PostArrayClosure?) {
        var posts = [Post]();
        
        for (_, post) in postDictionary {
            if post.user!.id == userId {
                posts.append(post)
            }
        }
        
        completionBlock?(nil, posts)
    }
    
    func getAllFollowingPosts(_ userId: String, completionBlock: PostArrayClosure?) {
        completionBlock?(nil, Array(postDictionary.values))
    }
    
    // POST
    func startFollowingUser(_ userId: String, userIdToFollow: String, completionBlock: BooleanClosure?) {
        var followingList = userFollowingDictionary[userId]
        let userToFollow = userDictionary[userIdToFollow]!
        
        if followingList!.contains(userToFollow) {
            completionBlock?(false)
        }
        else {
            followingList?.append(userToFollow)
            userFollowingDictionary[userId] = followingList
            completionBlock?(true)
        }
    }
    
    func signUpUser(_ username: String, password: String, fullname: String, completionBlock: UserDataClosure?) {
        if let _ = usernameDictionary[username] {
            completionBlock?(defaultError, nil)
        }
        else {
            let newUser = UserData(username: username, fullname: fullname)
            userDictionary[newUser.id!] = newUser
            usernameDictionary[newUser.username!] = newUser
            userFollowingDictionary[newUser.id!] = [UserData]()
            completionBlock?(nil, newUser)
        }
    }
    
    func signInUser(_ username: String, password: String, completionBlock: UserDataClosure?) {
        if let user = usernameDictionary[username] {
            completionBlock?(nil, user)
        }
        else {
            completionBlock?(defaultError, nil)
        }
    }
    
    func createPost(_ userId: String, post: String, completionBlock: PostClosure?) {
        let newPost = Post(user: userDictionary[userId]!, post: post, reactions: [Reaction](), created: Date(timeIntervalSinceNow: -60*60*3))
        postDictionary[newPost.id!] = newPost;
        
        completionBlock?(error: nil, post: newPost)
    }
    
    func reactToPost(_ userId: String, postId: String, reaction: String, completionBlock: ReactionClosure?) {
        let newReaction = Reaction(user: userDictionary[userId]!, reaction: reaction)
        
        var post = postDictionary[postId]
        var reactionArr = post?.reactions
        reactionArr?.append(newReaction)
        
        post?.reactions = reactionArr!
        postDictionary[postId] = post
        
        completionBlock?(nil, newReaction);
    }
    
    // DELETE
    
    func stopFollowingUser(_ userId: String, userIdToStopFollowing: String, completionBlock: BooleanClosure?) {
        // TODO: Implement this
    }
    
    // Utility
    
    func initializeDummyData() {
        signUpUser("😎😈😎", password: "test", fullname: "Joe P", completionBlock: nil)
        signUpUser("🍆", password: "test", fullname: "Jacob J", completionBlock: nil)
        signUpUser("😌", password: "test", fullname: "Jimmy R", completionBlock: nil)
        
        let joe = usernameDictionary["😎😈😎"]!
        let james = usernameDictionary["😌"]!
        let jacob = usernameDictionary["🍆"]!
        
        startFollowingUser(james.id!, userIdToFollow: "🍆", completionBlock: nil)
        startFollowingUser(jacob.id!, userIdToFollow: "😌", completionBlock: nil)
        
        startFollowingUser(james.id!, userIdToFollow: "😎😈😎", completionBlock: nil)
        startFollowingUser(jacob.id!, userIdToFollow: "😎😈😎", completionBlock: nil)
        
        var postId = ""
        
        createPost(joe.id!, post: "🍔🍺", completionBlock: { (error, post) in
            postId = post!.id!
        })
        
        createPost(joe.id!, post: "👋🏼👵🏻😡", completionBlock: nil)
        
        createPost(james.id!, post: "👺👾🙇", completionBlock: nil)
        createPost(jacob.id!, post: "🐊☀️❄️🌄🌋", completionBlock: nil)
        
        let tempPost = postDictionary[postId]!
        
        reactToPost(james.id!, postId: tempPost.id!, reaction: "👍🏽", completionBlock: nil)
        reactToPost(jacob.id!, postId: tempPost.id!, reaction: "👃🏼", completionBlock: nil)
    }
    
    func URLStringWithExtension(_ urlExtension: String) -> String {
        return "\(baseURL)/\(urlExtension)";
    }
}
    
