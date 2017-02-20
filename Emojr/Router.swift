//
//  Router.swift
//  Emojr
//
//  Created by James on 11/12/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "https://" + NetworkConstants.HostName
    
    // - GET
    
        // User
        case AllUsers(searchString: String?)
        case Following(userID: String)
        case Followers(userID: String)
        
        // Posts
        case Post(postID: String)
        case DiscoverPosts(lastCreatedDate: Date?)
        case UserPosts(userID: String, lastCreatedDate: Date?)
        case FollowingPosts(userID: String, lastCreatedDate: Date?)
    
    // - POST
    
        case UsernameAvailable(username: String)
        case FollowUser(userID: String, userIDToFollow: String)
        case SignUp(username: String, password: String)
        case SignIn(username: String, password: String)
        case CreatePost(userID: String, text: String)
        case ReactToPost(userID: String, postID: String, text: String)
    
    // - DELETE
    
        case UnfollowUser(userID: String, userIDToUnfollow: String)
    
    
    var shouldAuthenticate: Bool {
        switch self {
        default:
            return false
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .AllUsers, .Following, .Followers, .Post, .DiscoverPosts, .UserPosts, .FollowingPosts:
            return .get
        case .UsernameAvailable, .FollowUser, .SignUp, .SignIn, .CreatePost, .ReactToPost:
            return .post
        case .UnfollowUser:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .AllUsers:
            return "/users"
        case .Following(let userID):
            return "/following/\(userID)"
        case .Followers(let userID):
            return "/followers/\(userID)"
        case .Post(let postID):
            return "/post/\(postID)"
        case .DiscoverPosts(let lastCreatedDate):
            if lastCreatedDate != nil {
                let dateString = String(describing: lastCreatedDate!.timeIntervalSince1970)
                return "/posts/discover?fromDate=\(dateString)"
            } else {
                return "/posts/discover"
            }
        case .UserPosts(let userID, let lastCreatedDate):
            if lastCreatedDate != nil {
                let dateString = String(describing: lastCreatedDate!.timeIntervalSince1970)
                return "/posts/user/\(userID)?fromDate=\(dateString)"
            } else {
                return "/posts/user/\(userID)"
            }
        case .FollowingPosts(let userID, let lastCreatedDate):
            if lastCreatedDate != nil {
                let dateString = String(describing: lastCreatedDate!.timeIntervalSince1970)
                return "/posts/following/\(userID)?fromDate=\(dateString)"
            } else {
                return "/posts/following/\(userID)"
            }
        case .UsernameAvailable:
            return "/user/available"
        case .FollowUser:
            return "/follow"
        case .SignUp:
            return "/user/signup"
        case .SignIn:
            return "/user/signin"
        case .CreatePost:
            return "/post"
        case .ReactToPost:
            return "/reaction"
        case .UnfollowUser:
            return "/follow"
        }
    }
    
    var parameters: [String : String]? {
        var params = [String : String]()
        
        switch self {
        case .AllUsers(let searchString):
            if let searchString = searchString {
                params["searchString"] = searchString
            }
        
        case .FollowUser(let userID, let userIDToFollow):
            params["followerUserId"] = userID
            params["followingUserId"] = userIDToFollow
            
        case .SignUp(let username, let password):
            params["username"] = username
            params["password"] = password
            
        case .SignIn(let username, let password):
            params["username"] = username
            params["password"] = password
            
        case .CreatePost(let userID, let text):
            params["userid"] = userID
            params["post"] = text
            
        case .ReactToPost(let userID, let postID, let text):
            params["userid"] = userID
            params["postid"] = postID
            params["reaction"] = text
            
        case .UnfollowUser(let userID, let userIDToUnfollow):
            params["followerUserId"] = userID
            params["followingUserId"] = userIDToUnfollow
        default:
            return nil
        }
        
        return params
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        urlRequest = try JSONEncoding.default.encode(urlRequest, with: self.parameters)
//        if self.shouldAuthenticate {
//            let (signature, dateString) = RequestAuth.signatureForRequest(urlRequest: urlRequest)
//            urlRequest.addValue(signature, forHTTPHeaderField: "Signature")
//            urlRequest.addValue(dateString, forHTTPHeaderField: "Timestamp")
//        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
}
