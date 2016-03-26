//
//  NetworkRequests.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/25/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Swish

let baseUrl = "localhost:3000/api"

func baseRequest(url: String, method: RequestMethod, parameters: String?) -> NSURLRequest {
    let url = NSURL(string: url)!
    let request = NSMutableURLRequest(URL: url)
    
    request.HTTPMethod = method.rawValue
    
    if let params = parameters {
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
    }
    
    return request
}

struct UserSignInRequest: Request {
    typealias ResponseObject = NetworkUser
    
    let username: String
    let password: String
    
    func build() -> NSURLRequest {
        let endpoint = "\(baseUrl)/user/signin"
        let params = "username=\(username)&password=\(password)"
        
        return baseRequest(endpoint, method: .POST, parameters: params)
    }
}

struct UserSignUpRequest: Request {
    typealias ResponseObject = NetworkUser
    
    let username: String
    let password: String
    
    func build() -> NSURLRequest {
        let endpoint = "\(baseUrl)/user/signup"
        let params = "username=\(username)&password=\(password)"
        
        return baseRequest(endpoint, method: .POST, parameters: params)
    }
}

struct FollowingRequest: Request {
    typealias ResponseObject = NetworkUser
    
    let username: String
    
    func build() -> NSURLRequest {
        let endpoint = "\(baseUrl)/following/\(username)"
        
        return baseRequest(endpoint, method: .GET, parameters: nil)
    }
}

