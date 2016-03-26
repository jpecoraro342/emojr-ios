//
//  NetworkObjects.swift
//  SplitStreamr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

import Foundation

struct UserData: CustomStringConvertible, Equatable {
    var id: String
    var username: String
    var fullname: String
    
    init(username: String, fullname: String) {
        self.username = username
        self.fullname = fullname
        self.id = randomStringWithLength(8) as String
    }
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = fromJson["_id"] as! String
        username = fromJson["username"] as! String
        fullname = fromJson["fullname"] as! String
    }
    
    var description: String {
        return "username: \(username) id: \(id)"
    }
}

func ==(lhs: UserData, rhs: UserData) -> Bool {
    return lhs.id == rhs.id
}

struct Post {
    var id: String;
    var userId: String;
    var post: String;
    var reactions: [Reaction];
    
    init(userId: String, post: String, reactions: [Reaction]) {
        self.userId = userId
        self.post = post
        self.reactions = reactions
        self.id = randomStringWithLength(8) as String
    }
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = fromJson["_id"] as! String
        userId = fromJson["userId"] as! String
        post = fromJson["post"] as! String
        
        // TODO: There's no way this will actually work right now
        reactions = fromJson["reactions"] as! [Reaction]
    }
    
    var description: String {
        return "post: \(post) id: \(id)"
    }
}

struct Reaction {
    var id: String;
    var user: UserData;
    var reaction: String;

    init(user: UserData, reaction: String) {
        self.user = user
        self.reaction = reaction
        self.id = randomStringWithLength(8) as String
    }
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = fromJson["_id"] as! String
        
        // TODO: This might not work
        user = UserData(fromJson: fromJson["user"] as! Dictionary<String, AnyObject>)
        reaction = fromJson["reaction"] as! String
    }
    
    var description: String {
        return "reaction: \(reaction) id: \(id)"
    }
}

