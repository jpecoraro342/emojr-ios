//
//  Constants.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/25/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

// MARK: Closure Defines

typealias ErrorClosure = (_ error: Error?) -> Void;
typealias BooleanClosure = (_ success: Bool) -> Void;
typealias UserDataClosure = (_ errorString: String?, _ user: UserData?) -> Void;
typealias UserArrayClosure = (_ error: Error?, _ list: [UserData]?) -> Void;
typealias PostClosure = (_ error: Error?, _ post: Post?) -> Void;
typealias PostArrayClosure = (_ error: Error?, _ list: [Post]?) -> Void;
typealias ReactionClosure = (_ error: Error?, _ reaction: Reaction?) -> Void;
typealias ReactionArrayClosure = (_ error: NSError?, _ list: [Reaction]?) -> Void;
typealias JsonClosure = (_ error: Error?, _ jsonData: AnyObject?) -> Void;
typealias DataClosure = (_ error: Error?, _ data: Data?) -> Void;
typealias StringClosure = (_ error: Error?, _ string: String?) -> Void;
typealias VoidClosure = () -> Void

// MARK: Color Scheme

// TODO: Redefine Color Scheme

let blueLight = UIColor(hexString: "75F6EB")
let blue = UIColor(hexString: "3490DE")
let offWhite = UIColor(hexString: "fefefe")
let offBlack = UIColor(hexString: "#404040")

// Keychain Keys

let serviceKey = "com.emojr"
let emailKey = "com.currentuser.email"
let passwordKey = "com.currentuser.password"

// MARK: Segue Identifiers

let LoginToSignup = "LoginToSignup"
let LoginNavToMainTab = "LoginNavToMainTab"
let AccountToUserTimeline = "AccountToUserTimeline"
let InitialSetupToMainTab = "InitialSetupToMainTab"


// MARK: Storyboard IDs

let InitialSetupVCIdentifier = "InitialSetup"
let LoginTabVCIdentifier = "LoginTab"
let LoginVCIdentifier = "LoginViewController"
let LoginNavVCIdentifier = "LoginNavViewController"
let SignUpVCIdentifier = "SignUpViewController"
let UserTimelineVCIdentifier = "UserTimelineViewController"
let AccountVCIdentifier = "AccountViewController"

// MARK: Reuse Identifiers

let TimelineCellIdentifier = "TimelineCell"
let LoadingCellIdentifier = "loadingCell"
let UserCellIdentifier = "UserCell"

// MARK:

let baseURL = "https://emojr.herokuapp.com/api";

let networkErrorDomain = "com.emojr.network";

// MARK: Debug

func randomStringWithLength (_ len : Int) -> NSString {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for _ in 0 ..< len {
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    
    return randomString
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateFormat = "HH:mm:ss.SSS"
    return formatter
}()

func debugLog(_ message: String) {
    DispatchQueue.main.async(execute: {
        log.debug("\(dateFormatter.string(from: Date())) | \(message)");
    });
}
