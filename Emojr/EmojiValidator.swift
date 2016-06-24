//
//  EmojiValidator.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/24/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation

class EmojiValidator : NSObject {
    
    var emojiWithEmojiKeys : [String:String]? = nil
    var emojiWithNameKeys : [String:String]? = nil
    var complexEmoji: [String:[String]]? = nil
    
    override init() {
        super.init()
        
        emojiWithEmojiKeys = loadEmojiDictAtPath(emojiEmojiKeysFilePath)
        emojiWithNameKeys = loadEmojiDictAtPath(emojiNameKeysFilePath)
        complexEmoji = loadJsonAtPath(complexEmojiFilePath) as? Dictionary<String, Array<String>>
    }
    
    func loadEmojiDictAtPath(path: String) -> Dictionary<String, String> {
        do {
            let rawEmojiData = NSData(contentsOfURL: NSURL(fileURLWithPath: path))
            
            if let data = rawEmojiData {
                let emojiDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! Dictionary<String, String>
                
                return emojiDict
            }
        }
        catch {
            print("Error loading emoji file at path: \(path)")
        }
        
        return [String:String]()
    }
    
    func loadJsonAtPath(path: String) -> AnyObject {
        do {
            let rawData = NSData(contentsOfURL: NSURL(fileURLWithPath: path))
            
            if let data = rawData {
                let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                
                return jsonObj
            }
        }
        catch {
            print("Error loading file at path: \(path)")
        }
        
        return Dictionary<String, String>()
    }
    
    func isEmoji(emoji: String) -> Bool {
        return emojiWithEmojiKeys?[emoji] != nil
    }
    
    func emojiForName(name: String) -> String? {
        return emojiWithNameKeys?[name]
    }
    
    func emojisForNameStartingWith(name: String) -> [String] {
        var emojis = [String]()
        
        guard let emojiDict = emojiWithNameKeys
            else { return emojis }
        
        for (emojiName, emoji) in emojiDict {
            if emojiName.containsString(name) {
                emojis.append(emoji)
            }
        }
        
        return emojis
    }
}

func emojiValidatorTest() {
    let validator = EmojiValidator()
    
    print("😇 \(validator.isEmoji("😇"))")
    print("🇳🇫 \(validator.isEmoji("🇳🇫"))")
    print("📳 \(validator.isEmoji("📳"))")
    print("🕰 \(validator.isEmoji("🕰"))")
    print("tes \(validator.isEmoji("tes"))")
    
    print("scissors \(validator.emojiForName("scissors"))")
    
    print("Arrow test: \(validator.emojisForNameStartingWith("arrow"))")
}