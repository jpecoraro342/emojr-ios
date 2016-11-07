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
        
        let set = NSMutableCharacterSet()
        set.formUnion(with: CharacterSet.alphanumerics)
        set.formUnion(with: CharacterSet.symbols)
        set.formUnion(with: CharacterSet.punctuationCharacters)
        set.formUnion(with: CharacterSet.whitespacesAndNewlines)
        
        for character in self.characters {
            let units = [unichar](String(character).utf16)
            for unit in units {
                if set.contains(UnicodeScalar(unit)) {
                    return false
                }
            }
        }
        
        return true
    }
}
