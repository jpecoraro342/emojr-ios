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
typealias UserDataClosure = (error: NSError?, song: UserData?) -> Void;
typealias UserArrayClosure = (error: NSError?, list: Array<UserData>?) -> Void;
typealias JsonClosure = (error: NSError?, jsonData: AnyObject?) -> Void;
typealias DataClosure = (error: NSError?, data: NSData?) -> Void;
typealias StringClosure = (error: NSError?, string: String?) -> Void;

// MARK: Color Scheme

// TODO: Redefine Color Scheme

let blueLight1 = UIColor(hexString: "65a5d1");
let blueLight2 = UIColor(hexString: "3e94d1");
let blue1 = UIColor(hexString: "0a64a4");
let blueDark1 = UIColor(hexString: "24577b");
let blueDark2 = UIColor(hexString: "03406a");
let transparentOrange = UIColor(hexString: "bfec6b0e");
let orange = UIColor(hexString: "ec6b0e");

let offWhiteColor = UIColor(hexString: "fefefe");

let buttonNormalColor = blue1;
let buttonHighlightedColor = blueDark2;

let shadowColor = blueLight1;
let navigationBarColor = blue1;

// MARK: Segues

// MARK: Reuse Identifiers

// MARK:

let baseURL = "http://localhost:3000/api";

let networkErrorDomain = "com.emojr.network";

// MARK: Debug

func debugLog(message: String) {
    dispatch_async(dispatch_get_main_queue(), {
        print(message);
    });
}
