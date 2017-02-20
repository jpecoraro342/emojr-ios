//
//  RestAccessor.swift
//  Emojr
//
//  Created by James on 11/12/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkConstants {
    
    static let PrintHashPlaintext = false
    static let PrintRequests = false
    static let PrintResponses = false
    static let ParamRegexPattern = "([^\\/]+\\/(?={[^}]+}){[^}]+})"
    
    static let HostName = "emojr.herokuapp.com/api"
}

protocol Resource: URLRequestConvertible {
    var method: Alamofire.Method { get }
    var path: String { get }
    var parameters: [String : AnyObject]? { get }
}

class RestAccessor: NSObject {
    static let sharedManager: SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            NetworkConstants.HostName : .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: true,
                validateHost: true
            )
        ]
        
        return SessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
}

extension RestAccessor: NetworkingAccessor {
    func getUsers(_ searchString: String?, completionBlock: UserArrayClosure?) {
        RestAccessor.sharedManager.request(Router.AllUsers(searchString: searchString))
            .responseJSON(completionHandler: { response in
                var friends : Array<UserData> = Array<UserData>();
                
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    
                    let json = response.result.value
                    for jsonUser in json as! Array<Dictionary<String, AnyObject>> {
                        if let userData = UserData(fromJson: jsonUser) {
                            friends.append(userData);
                        }
                    }
                    
                    completionBlock?(nil, friends);
                }
                else {
                    completionBlock?(response.result.error, friends);
                }
            })
    }
    
    func getAllFollowing(_ userId: String, completionBlock: UserArrayClosure?) {
        RestAccessor.sharedManager.request(Router.Following(userID: userId))
            .responseJSON(completionHandler: { response in
                var friends : Array<UserData> = Array<UserData>();
                
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    
                    let json = response.result.value
                    for jsonUser in json as! Array<Dictionary<String, AnyObject>> {
                        if let userData = UserData(fromJson: jsonUser) {
                            friends.append(userData);
                        }
                    }
                    
                    completionBlock?(nil, friends);
                }
                else {
                    completionBlock?(response.result.error, friends);
                }
            })
    }
    
    func getAllFollowers(_ userId: String, completionBlock: UserArrayClosure?) {
        RestAccessor.sharedManager.request(Router.Followers(userID: userId))
            .responseJSON(completionHandler: { response in
                var friends : Array<UserData> = Array<UserData>();
                
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    
                    let json = response.result.value
                    
                    for jsonUser in json as! Array<Dictionary<String, AnyObject>> {
                        if let userData = UserData(fromJson: jsonUser) {
                            friends.append(userData);
                        }
                    }
                    
                    completionBlock?(nil, friends);
                }
                else {
                    completionBlock?(response.result.error, friends);
                }
            })
    }
    
    func getPost(_ postId: String, completionBlock: PostClosure?) {
        RestAccessor.sharedManager.request(Router.Post(postID: postId))
            .responseJSON(completionHandler: { response in
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    
                    let json = response.result.value
                    completionBlock?(nil, Post(fromJson: json as! Dictionary<String, AnyObject>));
                }
                else {
                    completionBlock?(response.result.error, nil);
                }
            })
    }
    
    func getDiscoverPosts(lastCreatedDate: Date?, completionBlock: PostArrayClosure?) {
        RestAccessor.sharedManager.request(Router.DiscoverPosts(lastCreatedDate: lastCreatedDate))
            .responseJSON(completionHandler: { response in
                var posts : Array<Post> = Array<Post>();
                
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    
                    let json = response.result.value
                    for jsonPost in json as! Array<Dictionary<String, AnyObject>> {
                        if let post = Post(fromJson: jsonPost) {
                            posts.append(post);
                        }
                    }
                    
                    completionBlock?(nil, posts);
                }
                else {
                    completionBlock?(response.result.error, posts);
                }
            })
    }
    
    func getAllPostsFromUser(_ userId: String, lastCreatedDate: Date?, completionBlock: PostArrayClosure?) {
        RestAccessor.sharedManager.request(Router.UserPosts(userID: userId, lastCreatedDate: lastCreatedDate))
            .responseJSON(completionHandler: { response in
                var posts : Array<Post> = Array<Post>();
                
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    
                    let json = response.result.value
                    for jsonPost in json as! Array<Dictionary<String, AnyObject>> {
                        if let post = Post(fromJson: jsonPost) {
                            posts.append(post);
                        }
                    }
                    
                    completionBlock?(nil, posts);
                }
                else {
                    completionBlock?(response.result.error, posts);
                }
            })
    }
    
    func getAllFollowingPosts(_ userId: String, lastCreatedDate: Date?, completionBlock: PostArrayClosure?) {
        RestAccessor.sharedManager.request(Router.FollowingPosts(userID: userId, lastCreatedDate: lastCreatedDate))
            .responseJSON(completionHandler: { response in
                var posts : Array<Post> = Array<Post>();
                
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    
                    let json = response.result.value
                    for jsonPost in json as! Array<Dictionary<String, AnyObject>> {
                        if let post = Post(fromJson: jsonPost) {
                            posts.append(post);
                        }
                    }
                    
                    completionBlock?(nil, posts);
                }
                else {
                    completionBlock?(response.result.error, posts);
                }
            })
    }
    
    // POST
    func isUsernameAvailable(_ username: String, completionBlock: BooleanClosure?) {
        RestAccessor.sharedManager.request(Router.UsernameAvailable(username: username))
            .responseJSON(completionHandler: { response in
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    let json = response.result.value as! Dictionary<String, AnyObject>
                    completionBlock?((json["available"] as? String) != nil);
                }
                else {
                    completionBlock?(false);
                }
            })
    }
    
    func startFollowingUser(_ userId: String, userIdToFollow: String, completionBlock: BooleanClosure?) {
        RestAccessor.sharedManager.request(Router.FollowUser(userID: userId, userIDToFollow: userIdToFollow))
            .responseJSON(completionHandler: { response in
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    completionBlock?(true);
                }
                else {
                    completionBlock?(false);
                }
            })
    }
    
    func signUpUser(_ username: String, password: String, completionBlock: UserDataClosure?) {
        RestAccessor.sharedManager.request(Router.SignUp(username: username, password: password))
            .responseJSON(completionHandler: { response in
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    let json = response.result.value
                    completionBlock?(nil, UserData(fromJson: json as! Dictionary<String, AnyObject>));
                }
                else {
                    let json = response.result.value as! Dictionary<String, AnyObject>
                    completionBlock?(json["message"] as! String?, nil)
                }
            })
    }
    
    func signInUser(_ username: String, password: String, completionBlock: UserDataClosure?) {
        RestAccessor.sharedManager.request(Router.SignIn(username: username, password: password))
            .responseJSON(completionHandler: { response in
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    let json = response.result.value
                    completionBlock?(nil, UserData(fromJson: json as! Dictionary<String, AnyObject>));
                }
                else {
                    let json = response.result.value as! Dictionary<String, AnyObject>
                    completionBlock?(json["message"] as! String?, nil)
                }
            })
    }
    
    func createPost(_ userId: String, post: String, completionBlock: PostClosure?) {
        RestAccessor.sharedManager.request(Router.CreatePost(userID: userId, text: post))
            .responseJSON(completionHandler: { response in
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    let json = response.result.value
                    completionBlock?(nil, Post(fromJson: json as! Dictionary<String, AnyObject>));
                }
                else {
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    
                    completionBlock?(response.result.error, nil);
                }
            })
    }
    
    func reactToPost(_ userId: String, postId: String, reaction: String, completionBlock: ReactionClosure?) {
        RestAccessor.sharedManager.request(Router.ReactToPost(userID: userId, postID: postId, text: reaction))
            .responseJSON(completionHandler: { response in
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    let json = response.result.value
                    completionBlock?(nil, Reaction(fromJson: json as! Dictionary<String, AnyObject>));
                }
                else {
                    completionBlock?(response.result.error, nil);
                }
            })
    }
    
    // DELETE
    func stopFollowingUser(_ userId: String, userIdToStopFollowing: String, completionBlock: BooleanClosure?) {
        RestAccessor.sharedManager.request(Router.UnfollowUser(userID: userId, userIDToUnfollow: userIdToStopFollowing))
            .responseJSON(completionHandler: { response in
                if (response.result.isSuccess
                    && (response.response?.statusCode)! >= 200
                    && (response.response?.statusCode)! <= 300) {
                    completionBlock?(true);
                }
                else {
                    completionBlock?(false);
                }
            })
    }
}






