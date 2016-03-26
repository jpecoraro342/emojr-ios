//
//  NetworkFacade.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 2/19/16.
//  Copyright © 2016 SplitStreamr. All rights reserved.
//

import Foundation

class NetworkFacade : NSObject {

    let dataAccessor : NetworkingAccessor;
    
    override init() {
        // TODO: pass data accessor and socket to use in the init method
        // dataAccessor = RestNetworkAccessor();
        dataAccessor = DummyNetworkAccessor();
        
        super.init();
    }
    
    func signInUser(username: String, password: String, completionBlock: UserDataClosure) {
        dataAccessor.signInUser(username, password: password, completionBlock: completionBlock);
    }

}


