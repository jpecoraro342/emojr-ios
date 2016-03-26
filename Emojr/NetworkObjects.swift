//
//  NetworkObjects.swift
//  SplitStreamr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

import Foundation

struct UserData: CustomStringConvertible {
    var id: String;
    var username: String;
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = fromJson["_id"] as! String;
        username = fromJson["username"] as! String;
    }
    
    var description: String {
        return "username: \(username) id: \(id)";
    }
}