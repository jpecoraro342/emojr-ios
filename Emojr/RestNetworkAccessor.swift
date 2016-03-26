//
//  RestNetworkAccessor.swift
//  SplitStreamr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

import Foundation
import Alamofire

class RestNetworkAccessor: NSObject { // , NetworkingAccessor {
    
    // GET
    func getFollowing(userId: String, completionBlock: UserArrayClosure) {
        Alamofire.request(.GET, URLStringWithExtension("following/\(userId)"))
            .responseJSON { response in
                // DEBUG: print(response.request)  // original URL request
                // DEBUG: print(response.response) // URL response
                // DEBUG: print(response.data)     // server data
                // DEBUG: print(response.result)   // result of response serialization
                
                var friends : Array<UserData> = Array<UserData>();
                
                if let json = response.result.value {
                    
                    for jsonUser in json as! Array<Dictionary<String, AnyObject>> {
                        friends.append(UserData(fromJson: jsonUser));
                    }
                    
                    completionBlock(error: nil, list: friends);
                }
                else {
                    completionBlock(error: response.result.error, list: friends);
                }
        }
    }
    
    
    // POST
    func signInUser(username: String, password: String, completionBlock: UserDataClosure) {
    }
    
    // Utility
    
    func URLStringWithExtension(urlExtension: String) -> String {
        return "\(baseURL)/\(urlExtension)";
    }
    
}
