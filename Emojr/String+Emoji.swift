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
        set.formUnionWithCharacterSet(NSCharacterSet.alphanumericCharacterSet())
        set.formUnionWithCharacterSet(NSCharacterSet.symbolCharacterSet())
        set.formUnionWithCharacterSet(NSCharacterSet.punctuationCharacterSet())
        set.formUnionWithCharacterSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        for character in self.characters {
            let units = [unichar](String(character).utf16)
            for unit in units {
                if set.characterIsMember(unit) {
                    return false
                }
            }
        }
        
        return true
    }
}