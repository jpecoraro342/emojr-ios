//
//  EmojiValidator.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/24/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation

class EmojiValidator : NSObject {
    let emojiOneFilesPath = Bundle.main.path(forResource: "emoji", ofType: "json")!
    let emojiNameKeysFilePath = Bundle.main.path(forResource: "emoji-name-keys", ofType: "json")!
    let emojiEmojiKeysFilePath = Bundle.main.path(forResource: "emoji-emoji-keys", ofType: "json")!
    let complexEmojiFilePath = Bundle.main.path(forResource: "emoji-complex", ofType: "json")!
    
    var emojiOne : [String:Any]? = nil
    var emojiWithEmojiKeys : [String:String]? = nil
    var emojiWithNameKeys : [String:String]? = nil
    var complexEmoji: [String:[String]]? = nil
    
    override init() {
        super.init()
        emojiOne = loadJsonAtPath(emojiOneFilesPath) as? [String:Any]
        emojiWithEmojiKeys = loadJsonAtPath(emojiEmojiKeysFilePath) as? [String:String]
        emojiWithNameKeys = loadJsonAtPath(emojiNameKeysFilePath) as? [String:String]
        complexEmoji = loadJsonAtPath(complexEmojiFilePath) as? [String:[String]]
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
            log.debug("Error loading file at path: \(path)")
        }
        
        return Dictionary<String, String>() as AnyObject
    }
    
    func isEmoji(_ emoji: String) -> Bool {
        return emoji.isSingleEmoji
        // return emojiWithEmojiKeys?[emoji] != nil
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
            let words = emojiName.components(separatedBy: ":")
            
            let nameWords = words[0].components(separatedBy: " ")
            var nameMatched = false
            
            for word in nameWords {
                if word.hasPrefix(name) {
                    nameMatched = true
                    emojis.append(emoji)
                    break
                }
            }
            
            if words.count > 1 && !nameMatched {
                let keywords = words[1].components(separatedBy: " ")
                
                for word in keywords {
                    if word.hasPrefix(name) {
                        emojis.append(emoji)
                        break
                    }
                }
            }
        }
        
        return emojis
    }
}
