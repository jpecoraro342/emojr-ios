//
//  DummyRequestPerformer.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/25/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation
import Swish
import Result

public struct DummyRequestPerformer: RequestPerformer {
    private let session: NSURLSession
    
    public init(session: NSURLSession = NSURLSession.sharedSession()) {
        self.session = session
    }
}

public extension DummyRequestPerformer {
    func performRequest(request: NSURLRequest, completionHandler: Result<HTTPResponse, NSError> -> Void) -> NSURLSessionDataTask {
    
        return NSURLSessionDataTask();
    }
}

