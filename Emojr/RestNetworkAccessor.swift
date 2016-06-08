//
//  RestNetworkAccessor.swift
//  SplitStreamr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

import Foundation
import Alamofire

class RestNetworkAccessor: NSObject, NetworkingAccessor {
    
    // GET
    func getUsers(searchString: String?=nil, completionBlock: UserArrayClosure?) {
        var parameters: Dictionary<String, String>?
        
        if let search = searchString {
            parameters = [ "searchString" : search]
        }
        
        Alamofire.request(.GET, URLStringWithExtension("users"), parameters: parameters)
            .responseJSON { response in
                var friends : Array<UserData> = Array<UserData>();
                
                if let json = response.result.value {
                    
                    for jsonUser in json as! Array<Dictionary<String, AnyObject>> {
                        friends.append(UserData(fromJson: jsonUser));
                    }
                    
                    completionBlock?(error: nil, list: friends);
                }
                else {
                    completionBlock?(error: response.result.error, list: friends);
                }
        }
    }
    
    func getAllFollowing(userId: String, completionBlock: UserArrayClosure?) {
        Alamofire.request(.GET, URLStringWithExtension("following/\(userId)"))
            .responseJSON { response in
                var friends : Array<UserData> = Array<UserData>();
                
                if let json = response.result.value {
                    
                    for jsonUser in json as! Array<Dictionary<String, AnyObject>> {
                        friends.append(UserData(fromJson: jsonUser));
                    }
                    
                    completionBlock?(error: nil, list: friends);
                }
                else {
                    completionBlock?(error: response.result.error, list: friends);
                }
        }
    }
    
    func getAllFollowers(userId: String, completionBlock: UserArrayClosure?) {
        Alamofire.request(.GET, URLStringWithExtension("followers/\(userId)"))
            .responseJSON { response in
                var friends : Array<UserData> = Array<UserData>();
                
                if let json = response.result.value {
                    
                    for jsonUser in json as! Array<Dictionary<String, AnyObject>> {
                        friends.append(UserData(fromJson: jsonUser));
                    }
                    
                    completionBlock?(error: nil, list: friends);
                }
                else {
                    completionBlock?(error: response.result.error, list: friends);
                }
        }
    }
    
    // func getAllPosts(completionBlock: PostArrayClosure);
    func getPost(postId: String, completionBlock: PostClosure?) {
        Alamofire.request(.GET, URLStringWithExtension("post/\(postId)"))
            .responseJSON { response in
                if let json = response.result.value {
                    completionBlock?(error: nil, post: Post(fromJson: json as! Dictionary<String, AnyObject>));
                }
                else {
                    completionBlock?(error: response.result.error, post: nil);
                }
        }
    }
    
    func getAllPostsFromUser(userId: String, completionBlock: PostArrayClosure?) {
        Alamofire.request(.GET, URLStringWithExtension("posts/user/\(userId)"))
            .responseJSON { response in
                var posts : Array<Post> = Array<Post>();
                
                if let json = response.result.value {
                    
                    for jsonPost in json as! Array<Dictionary<String, AnyObject>> {
                        posts.append(Post(fromJson: jsonPost));
                    }
                    
                    completionBlock?(error: nil, list: posts);
                }
                else {
                    completionBlock?(error: response.result.error, list: posts);
                }
        }
    }
    
    func getAllFollowingPosts(userId: String, completionBlock: PostArrayClosure?) {
        Alamofire.request(.GET, URLStringWithExtension("posts/following/\(userId)"))
            .responseJSON { response in
                var posts : Array<Post> = Array<Post>();
                
                if let json = response.result.value {
                    
                    for jsonPost in json as! Array<Dictionary<String, AnyObject>> {
                        posts.append(Post(fromJson: jsonPost));
                    }
                    
                    completionBlock?(error: nil, list: posts);
                }
                else {
                    completionBlock?(error: response.result.error, list: posts);
                }
        }
    }
    
    // POST
    func isUsernameAvailable(username: String, completionBlock: BooleanClosure?) {
        Alamofire.request(.POST, URLStringWithExtension("user/available"), parameters: ["username" : username], encoding: .JSON)
            .responseJSON { response in
                if let json = response.result.value {
                    completionBlock?(success: (json["available"] as String) as! Bool);
                }
                else {
                    completionBlock?(success: false);
                }
        }
    }
    
    func startFollowingUser(userId: String, userIdToFollow: String, completionBlock: BooleanClosure?) {
        let parameters = [ "followerUserId" : userId, "followingUserId" : userIdToFollow]
        Alamofire.request(.POST, URLStringWithExtension("follow"), parameters: parameters)
            .responseJSON { response in
                if let _ = response.result.value {
                    completionBlock?(success: true);
                }
                else {
                    completionBlock?(success: false);
                }
        }
    }
    
    func signUpUser(username: String, password: String, fullname: String, completionBlock: UserDataClosure?) {
        let parameters = ["username" : username, "password" : password, "fullname" : fullname]
        Alamofire.request(.POST, URLStringWithExtension("user/signup"), parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                if let json = response.result.value {
                    completionBlock?(error: nil, user: UserData(fromJson: json as! Dictionary<String, AnyObject>));
                }
                else {
                    completionBlock?(error: response.result.error, user: nil)
                }
        }
    }
    
    func signInUser(username: String, password: String, completionBlock: UserDataClosure?) {
        let parameters = ["username" : username, "password" : password]
        Alamofire.request(.POST, URLStringWithExtension("user/signin"), parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                if let json = response.result.value {
                    completionBlock?(error: nil, user: UserData(fromJson: json as! Dictionary<String, AnyObject>));
                }
                else {
                    completionBlock?(error: response.result.error, user: nil)
                }
        }
    }
    
    func createPost(userId: String, post: String, completionBlock: PostClosure?) {
        let parameters = ["userid" : userId, "post" : post]
        Alamofire.request(.POST, URLStringWithExtension("post"), parameters: parameters)
            .responseJSON { response in
                if let json = response.result.value {
                    completionBlock?(error: nil, post: Post(fromJson: json as! Dictionary<String, AnyObject>));
                }
                else {
                    completionBlock?(error: response.result.error, post: nil);
                }
        }
    }
    
    func reactToPost(userId: String, postId: String, reaction: String, completionBlock: ReactionClosure?) {
        let parameters = ["userid" : userId, "postid" : postId, "reaction" : reaction]
        Alamofire.request(.POST, URLStringWithExtension("reaction"), parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                if let json = response.result.value {
                    completionBlock?(error: nil, reaction: Reaction(fromJson: json as! Dictionary<String, AnyObject>));
                }
                else {
                    completionBlock?(error: response.result.error, reaction: nil);
                }
        }
    }
    
    // DELETE
    
    func stopFollowingUser(userId: String, userIdToStopFollowing: String, completionBlock: BooleanClosure?) {
        let parameters = [ "followerUserId" : userId, "followingUserId" : userIdToStopFollowing]
        Alamofire.request(.DELETE, URLStringWithExtension("follow"), parameters: parameters)
            .responseJSON { response in
                if let _ = response.result.value {
                    completionBlock?(success: true);
                }
                else {
                    completionBlock?(success: false);
                }
        }
    }
    
    // Utility
    
    func URLStringWithExtension(urlExtension: String) -> String {
        return "\(baseURL)/\(urlExtension)";
    }
    
    func verboseNetworkLog(response: Response<AnyObject, NSError>) {
        print(response.request)  // original URL request
        print(response.response) // URL response
        print(response.data)     // server data
        print(response.result)   // result of response serialization
    }
}
