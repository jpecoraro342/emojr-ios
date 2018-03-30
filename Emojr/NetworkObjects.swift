//
//  NetworkObjects.swift
//  SplitStreamr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserData: CustomStringConvertible, Equatable {
    var id: String?
    var username: String?
    var created: Date?
    
    init(username: String, id: String) {
        self.username = username
        self.id = id
    }
    
    init?(fromJson: Dictionary<String, AnyObject>) {
        guard let userID = fromJson["pk_userid"] as? Int else { return nil }
        
        id = String(describing: userID)
        username = fromJson["username"] as? String
    }
    
    var description: String {
        return "username: \(username ?? "nil") id: \(id ?? "nil")"
    }
}

func ==(lhs: UserData, rhs: UserData) -> Bool {
    return lhs.id == rhs.id
}

struct Post {
    var key: String?
    var user: UserData?
    var post: String?
    var reactions: [Reaction]
    var created: Date?
    
    init(key: String?, user: UserData?, post: String?, reactions: [Reaction], created: String?) {
        self.user = user
        self.post = post
        self.reactions = reactions
        self.created = dateFromString(created)
        self.key = key
    }
    
    init?(fromJson: Dictionary<String, AnyObject>) {
        guard let postID = fromJson["pk_postid"] as? Int else { return nil }
        key = String(describing: postID)
        
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
        return "post: \(post ?? "nil") id: \(key ?? "nil")"
    }
}

struct Reaction {
    var id: String?
    var userID: String?
    var reaction: String?
    var created: Date?

    init(id: String?, userID: String?, reaction: String?, created: Date? = nil) {
        self.userID = userID
        self.reaction = reaction
        self.id = id
        self.created = created
    }
    
    init(fromJson: Dictionary<String, AnyObject>) {
        id = String(describing: fromJson["pk_reactionid"] as? Int)
        userID = UserData(fromJson: fromJson)?.id
        reaction = fromJson["reaction"] as? String
    }
    
    var description: String {
        return "reaction: \(reaction ?? "nil") id: \(id ?? "nil")"
    }
}

func reactions(from snapshots: [DataSnapshot]) -> [Reaction] {
    var reactions: [Reaction] = []
    
    for snapshot in snapshots {
        if let reactionData = snapshot.value as? [String: AnyObject],
            let reactionText = reactionData["text"] as? String,
            let userID = reactionData["userID"] as? String {
            
            let reaction = Reaction(id: snapshot.key,
                                    userID: userID,
                                    reaction: reactionText)
            
            reactions.append(reaction)
        }
    }
    
    return reactions
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

