//
//  String+Emoji.swift
//  Emojr
//
//  Created by James on 3/30/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension String {
    
    func isAllEmoji() -> Bool {
        var set = CharacterSet.alphanumerics
        set.formUnion(CharacterSet.alphanumerics)
        set.formUnion(CharacterSet.symbols)
        set.formUnion(CharacterSet.punctuationCharacters)
        set.formUnion(CharacterSet.whitespacesAndNewlines)
        
        for character in self.characters {
            let units = [unichar](String(character).utf16)
            for unit in units {
                if let scalar = UnicodeScalar(unit) {
                    if set.contains(scalar) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
}
