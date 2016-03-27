//
//  Constants.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/25/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

// MARK: Closure Defines

typealias ErrorClosure = (error: NSError?) -> Void;
typealias BooleanClosure = (success: Bool) -> Void;
typealias UserDataClosure = (error: NSError?, user: UserData?) -> Void;
typealias UserArrayClosure = (error: NSError?, list: Array<UserData>?) -> Void;
typealias PostClosure = (error: NSError?, post: Post?) -> Void;
typealias PostArrayClosure = (error: NSError?, list: Array<Post>?) -> Void;
typealias ReactionClosure = (error: NSError?, reaction: Reaction?) -> Void;
typealias ReactionArrayClosure = (error: NSError?, list: Array<Reaction>?) -> Void;
typealias JsonClosure = (error: NSError?, jsonData: AnyObject?) -> Void;
typealias DataClosure = (error: NSError?, data: NSData?) -> Void;
typealias StringClosure = (error: NSError?, string: String?) -> Void;

// MARK: Color Scheme

// TODO: Redefine Color Scheme

let blueLight = UIColor(hexString: "6FE7DD");
let blue = UIColor(hexString: "3490DE");
let offWhite = UIColor(hexString: "fefefe");

// MARK: Segues

// MARK: Reuse Identifiers

// MARK:

let baseURL = "https://emojr.herokuapp.com/api";

let networkErrorDomain = "com.emojr.network";

// MARK: Debug

func isAllEmoji(string: String) -> Bool {
    let emojiSet = NSMutableCharacterSet(range: NSRange(location: 0x1F601, length: 0x4e))
    print(emojiSet)
    emojiSet.formUnionWithCharacterSet(NSCharacterSet(range: NSRange(location: 0x2702, length: 0xae)))
    print(emojiSet)
    emojiSet.formUnionWithCharacterSet(NSCharacterSet(range: NSRange(location: 0x1F680, length: 0x40)))
    print(emojiSet)
    emojiSet.formUnionWithCharacterSet(NSCharacterSet(range: NSRange(location: 0x24C2, length: 0x1cd8f)))
    print(emojiSet)
    emojiSet.formUnionWithCharacterSet(NSCharacterSet(range: NSRange(location: 0x1F600, length: 0x36)))
    print(emojiSet)
    emojiSet.formUnionWithCharacterSet(NSCharacterSet(range: NSRange(location: 0x1F681, length: 0x44)))
    print(emojiSet)
    emojiSet.formUnionWithCharacterSet(NSCharacterSet(range: NSRange(location: 0x1F30D, length: 0x25a)))
    print(emojiSet)
    
    let notEmojiSet = emojiSet.invertedSet
    print(notEmojiSet)
    let range = string.rangeOfCharacterFromSet(notEmojiSet)
    
    if let _ = range {
        return false
    } else {
        return true
    }
}

func randomStringWithLength (len : Int) -> NSString {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for (var i=0; i < len; i+=1){
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }
    
    return randomString
}

let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.locale = NSLocale.currentLocale()
    formatter.dateFormat = "HH:mm:ss.SSS"
    return formatter
}()

func debugLog(message: String) {
    dispatch_async(dispatch_get_main_queue(), {
        print("\(dateFormatter.stringFromDate(NSDate())) | \(message)");
    });
}
