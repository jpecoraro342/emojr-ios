//
//  NetworkObjects.swift
//  SplitStreamr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

import Foundation

struct UserData: CustomStringConvertible, Equatable {
    var id: String?
    var username: String?
    var created: Date?
    var lastmodified: Date?
    
    init(username: String) {
        self.username = username
        self.id = randomStringWithLength(8) as String
    }
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = String(describing: fromJson["pk_userid"] as? Int)
        username = fromJson["username"] as? String
    }
    
    var description: String {
        return "username: \(username) id: \(id)"
    }
}

func ==(lhs: UserData, rhs: UserData) -> Bool {
    return lhs.id == rhs.id
}

struct Post {
    var id: String?
    var user: UserData?
    var post: String?
    var reactions: [Reaction]
    var created: Date?
    var lastmodified: Date?
    
    init(user: UserData, post: String, reactions: [Reaction], created: Date) {
        self.user = user
        self.post = post
        self.reactions = reactions
        self.created = created
        self.id = randomStringWithLength(8) as String
    }
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = String(describing: fromJson["pk_postid"] as? Int)
        user = UserData(fromJson: fromJson)
        post = fromJson["post"] as? String
        created = dateFromString(fromJson["created"] as? String)
        if let reactionArray = fromJson["reactions"] as? [AnyObject] {
            reactions = jsonArrayToReactionArray(reactionArray)
        }
        else {
            reactions = [Reaction]()
        }
    }
    
    var description: String {
        return "post: \(post) id: \(id)"
    }
}

struct Reaction {
    var id: String?
    var user: UserData?
    var reaction: String?
    var created: Date?
    var lastmodified: Date?

    init(user: UserData, reaction: String) {
        self.user = user
        self.reaction = reaction
        self.id = randomStringWithLength(8) as String
    }
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = String(describing: fromJson["pk_reactionid"] as? Int)
        user = UserData(fromJson: fromJson)
        reaction = fromJson["reaction"] as? String
    }
    
    var description: String {
        return "reaction: \(reaction) id: \(id)"
    }
}

func jsonArrayToReactionArray(_ jsonArr: [AnyObject]) -> [Reaction] {
    var reactArray = [Reaction]()
    
    for jsonDict in jsonArr {
        reactArray.append(Reaction(fromJson: jsonDict as! Dictionary<String, AnyObject>))
    }
    
    return reactArray
}

func dateFromString(_ dateString: String?) -> Date? {
    if let dateString = dateString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: dateString)
    }
    
    return nil;
}

