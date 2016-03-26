//
//  NetworkModels.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/25/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Swish
import Argo
import Curry

struct Reaction: Decodable {
    let id: String
    let emoji: String
    let userId: String
    
    static func decode(j: JSON) -> Decoded<Reaction> {
        return curry(Reaction.init)
            <^> j <| "id"
            <*> j <| "emoji"
            <*> j <| "userId"
    }
}


struct NetworkUser: Decodable {
    let id: String
    let username: String
    
    static func decode(j: JSON) -> Decoded<NetworkUser> {
        return curry(NetworkUser.init)
            <^> j <| "id"
            <*> j <| "username"
    }
}

struct Following: Decodable {
    let followingUsers: [NetworkUser]
    
    static func decode(j: JSON) -> Decoded<NetworkUser> {
        return curry(NetworkUser.init)
            <^> j <| "id"
            <*> j <| "username"
    }
}
