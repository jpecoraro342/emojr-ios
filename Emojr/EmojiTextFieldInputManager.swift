//
//  EmojiInput.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 7/2/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class EmojiTextFieldInputManager: NSObject {
    let emojiValidator = EmojiValidator()
    
    func updatedStringForEmojiField(_ oldText : String, newText : String, changedText : String) -> String {
        if emojiValidator.isEmoji(changedText) {
            return newText.emojiString
        }
        
        return newText
    }
    
    func emojiSearchString(_ text: String) -> String? {
        var stringWithNoEmoji = ""
        
        text.forEach { (c) in
            if !emojiValidator.isEmoji("\(c)") {
                stringWithNoEmoji.append(c)
            }
        }
        
        return stringWithNoEmoji == "" ? nil : stringWithNoEmoji
    }
}
