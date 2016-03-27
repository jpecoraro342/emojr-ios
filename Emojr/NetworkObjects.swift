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
    var fullname: String?
    
    init(username: String, fullname: String?) {
        self.username = username
        self.fullname = fullname
        self.id = randomStringWithLength(8) as String
    }
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = fromJson["_id"] as! String
        username = fromJson["username"] as! String
        fullname = fromJson["fullname"] as? String
    }
    
    var description: String {
        return "username: \(username) id: \(id)"
    }
}

func ==(lhs: UserData, rhs: UserData) -> Bool {
    return lhs.id == rhs.id
}

struct Post {
    var id: String
    var user: UserData
    var post: String
    var reactions: [Reaction]
    var created: NSDate
    
    init(user: UserData, post: String, reactions: [Reaction], created: NSDate) {
        self.user = user
        self.post = post
        self.reactions = reactions
        self.created = created
        self.id = randomStringWithLength(8) as String
    }
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = fromJson["_id"] as! String
        user = UserData(fromJson: fromJson["user"] as! Dictionary<String, AnyObject>)
        post = fromJson["post"] as! String
        created = fromJson["created"] as! NSDate
        
        reactions = jsonArrayToReactionArray(fromJson["reactions"] as! [Dictionary<String, AnyObject>])
    }
    
    var description: String {
        return "post: \(post) id: \(id)"
    }
}

struct Reaction {
    var id: String;
    var username: String;
    var reaction: String;

    init(username: String, reaction: String) {
        self.username = username
        self.reaction = reaction
        self.id = randomStringWithLength(8) as String
    }
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = fromJson["_id"] as! String
        username = fromJson["username"] as! String
        reaction = fromJson["reaction"] as! String
    }
    
    var description: String {
        return "reaction: \(reaction) id: \(id)"
    }
}

func jsonArrayToReactionArray(jsonArr: [Dictionary<String, AnyObject>]) -> [Reaction] {
    var reactArray = [Reaction]()
    
    for jsonDict in jsonArr {
        reactArray.append(Reaction(fromJson: jsonDict))
    }
    
    return reactArray
}

