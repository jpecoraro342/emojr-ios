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
    func isUsernameAvailable(username: String, completionBlock: BooleanClosure?) {
        if let _ = usernameDictionary[username] {
            completionBlock?(success: false)
            return
        }
        
        completionBlock?(success: true)
    }
    
    func getAllUsers(completionBlock: UserArrayClosure?) {
        completionBlock?(error: nil, list: Array(userDictionary.values))
    }
    
    func getAllFollowing(userId: String, completionBlock: UserArrayClosure?) {
        completionBlock?(error: nil, list: userFollowingDictionary[userId])
    }
    
    func getAllFollowers(userId: String, completionBlock: UserArrayClosure?) {
        var followers = [UserData]();
        
        for (user, followingList) in userFollowingDictionary {
            if user == userId {
                continue
            }
            
            if followingList.contains(userDictionary[userId]!) {
                followers.append(userDictionary[user]!)
            }
        }
        
        completionBlock?(error: nil, list: followers)
    }
    
    // func getAllPosts(completionBlock: PostArrayClosure);
    func getPost(postId: String, completionBlock: PostClosure?) {
        completionBlock?(error: nil, post: postDictionary[postId])
    }
    
    func getAllPostsFromUser(userId: String, completionBlock: PostArrayClosure?) {
        var posts = [Post]();
        
        for (_, post) in postDictionary {
            if post.user.id == userId {
                posts.append(post)
            }
        }
        
        completionBlock?(error: nil, list: posts)
    }
    
    func getAllFollowingPosts(userId: String, completionBlock: PostArrayClosure?) {
        completionBlock?(error: nil, list: Array(postDictionary.values))
    }
    
    // POST
    func startFollowingUser(userId: String, usernameToFollow: String, completionBlock: BooleanClosure?) {
        var followingList = userFollowingDictionary[userId]
        let userToFollow = usernameDictionary[usernameToFollow]!
        
        if followingList!.contains(userToFollow) {
            completionBlock?(success: false)
        }
        else {
            followingList?.append(userToFollow)
            userFollowingDictionary[userId] = followingList
            completionBlock?(success: true)
        }
    }
    
    func signUpUser(username: String, password: String, fullname: String, completionBlock: UserDataClosure?) {
        if let _ = usernameDictionary[username] {
            completionBlock?(error: defaultError, user: nil)
        }
        else {
            let newUser = UserData(username: username, fullname: fullname)
            userDictionary[newUser.id] = newUser
            usernameDictionary[newUser.username] = newUser
            userFollowingDictionary[newUser.id] = [UserData]()
            completionBlock?(error: nil, user: newUser)
        }
    }
    
    func signInUser(username: String, password: String, completionBlock: UserDataClosure?) {
        if let user = usernameDictionary[username] {
            completionBlock?(error: nil, user: user)
        }
        else {
            completionBlock?(error: defaultError, user: nil)
        }
    }
    
    func createPost(userId: String, post: String, completionBlock: PostClosure?) {
        let newPost = Post(user: userDictionary[userId]!, post: post, reactions: [Reaction](), created: NSDate(timeIntervalSinceNow: -60*60*3))
        postDictionary[newPost.id] = newPost;
        
        completionBlock?(error: nil, post: newPost)
    }
    
    func reactToPost(username: String, postId: String, reaction: String, completionBlock: ReactionClosure?) {
        let newReaction = Reaction(username: username, reaction: reaction)
        
        var post = postDictionary[postId]
        var reactionArr = post?.reactions
        reactionArr?.append(newReaction)
        
        post?.reactions = reactionArr!
        postDictionary[postId] = post
        
        completionBlock?(error: nil, reaction: newReaction);
    }
    
    // Utility
    
    func initializeDummyData() {
        signUpUser("😎😈😎", password: "test", fullname: "Joe P", completionBlock: nil)
        signUpUser("🍆", password: "test", fullname: "Jacob J", completionBlock: nil)
        signUpUser("😌", password: "test", fullname: "Jimmy R", completionBlock: nil)
        
        let joe = usernameDictionary["😎😈😎"]!
        let james = usernameDictionary["😌"]!
        let jacob = usernameDictionary["🍆"]!
        
        startFollowingUser(james.id, usernameToFollow: "🍆", completionBlock: nil)
        startFollowingUser(jacob.id, usernameToFollow: "😌", completionBlock: nil)
        
        startFollowingUser(james.id, usernameToFollow: "😎😈😎", completionBlock: nil)
        startFollowingUser(jacob.id, usernameToFollow: "😎😈😎", completionBlock: nil)
        
        var postId = ""
        
        createPost(joe.id, post: "🍔🍺", completionBlock: { (error, post) in
            postId = post!.id
        })
        
        createPost(joe.id, post: "👋🏼👵🏻😡", completionBlock: nil)
        
        createPost(james.id, post: "👺👾🙇", completionBlock: nil)
        createPost(jacob.id, post: "🐊☀️❄️🌄🌋", completionBlock: nil)
        
        let tempPost = postDictionary[postId]!
        
        reactToPost(james.id, postId: tempPost.id, reaction: "👍🏽", completionBlock: nil)
        reactToPost(jacob.id, postId: tempPost.id, reaction: "👃🏼", completionBlock: nil)
    }
    
    func URLStringWithExtension(urlExtension: String) -> String {
        return "\(baseURL)/\(urlExtension)";
    }
}
    