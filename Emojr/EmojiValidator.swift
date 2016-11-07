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
    
    func loadEmojiDictAtPath(_ path: String) -> Dictionary<String, String> {
        do {
            let rawEmojiData = try? Data(contentsOf: URL(fileURLWithPath: path))
            
            if let data = rawEmojiData {
                let emojiDict = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, String>
                
                return emojiDict
            }
        }
        catch {
            print("Error loading emoji file at path: \(path)")
        }
        
        return [String:String]()
    }
    
    func loadJsonAtPath(_ path: String) -> AnyObject {
        do {
            let rawData = try? Data(contentsOf: URL(fileURLWithPath: path))
            
            if let data = rawData {
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                
                return jsonObj as AnyObject
            }
        }
        catch {
            print("Error loading file at path: \(path)")
        }
        
        return Dictionary<String, String>() as AnyObject
    }
    
    func isEmoji(_ emoji: String) -> Bool {
        return emojiWithEmojiKeys?[emoji] != nil
    }
    
    func emojiForName(_ name: String) -> String? {
        return emojiWithNameKeys?[name]
    }
    
    func nameForEmoji(_ emoji: String) -> String? {
        return emojiWithEmojiKeys?[emoji]
    }
    
    func emojisForNameStartingWith(_ name: String) -> [String] {
        var emojis = [String]()
        
        guard let emojiDict = emojiWithNameKeys
            else { return emojis }
        
        for (emojiName, emoji) in emojiDict {
            if emojiName.contains(name.lowercased()) {
                emojis.append(emoji)
            }
        }
        
        return emojis
    }
}
