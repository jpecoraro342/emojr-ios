//
//  DataAccessor.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/25/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation

class DummyNetworkAccessor: NSObject, NetworkingAccessor {
    
    // GET
    
    // POST
    func signInUser(username: String, password: String, completionBlock: UserDataClosure) {
        
    }
    
    // Utility
    
    func URLStringWithExtension(urlExtension: String) -> String {
        return "\(baseURL)/\(urlExtension)";
    }
}
    