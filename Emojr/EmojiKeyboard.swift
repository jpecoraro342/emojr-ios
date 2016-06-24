//
//  EmojiKeyboard.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/9/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

protocol EmojiKeyboardDelegate {
    func emojiKeyBoarDidUseEmoji(emojiKeyBoard: EmojiKeyboard, emoji: String)
    func emojiKeyBoardDidPressBackSpace(emojiKeyBoard: EmojiKeyboard)
}

class EmojiKeyboard: NSObject {
    
    var keyboardView: AGEmojiKeyboardView?
    var delegate: EmojiKeyboardDelegate?
    
    override init() {
        super.init()
        
        keyboardView = getEmojiKeyboard()
    }
    
    func getKeyboardView() -> AGEmojiKeyboardView {
        return keyboardView!
    }
    
    private func getEmojiKeyboard() -> AGEmojiKeyboardView {
        let keyboardWidth = UIScreen.mainScreen().bounds.size.width
        let keyboardHeight: CGFloat = 500.0
        
        let keyboardFrame = CGRectMake(0, 0, keyboardWidth, keyboardHeight)
        let emojiKeyboard = AGEmojiKeyboardView(frame: keyboardFrame, dataSource: self)
        emojiKeyboard.autoresizingMask = .FlexibleHeight
        emojiKeyboard.delegate = self
        emojiKeyboard.backgroundColor = blue
        emojiKeyboard.segmentsBar.backgroundColor = UIColor.clearColor()
        emojiKeyboard.segmentsBar.tintColor = offWhite
        emojiKeyboard.segmentsBar.contentMode = .ScaleAspectFill
        
        return emojiKeyboard
    }
}

extension EmojiKeyboard : AGEmojiKeyboardViewDelegate {
    func emojiKeyBoardView(emojiKeyBoardView: AGEmojiKeyboardView!, didUseEmoji emoji: String!) {
        delegate?.emojiKeyBoarDidUseEmoji(self, emoji: emoji)
    }
    
    func emojiKeyBoardViewDidPressBackSpace(emojiKeyBoardView: AGEmojiKeyboardView!) {
        delegate?.emojiKeyBoardDidPressBackSpace(self)
    }
}

extension EmojiKeyboard : AGEmojiKeyboardViewDataSource {
    func emojiKeyboardView(emojiKeyboardView: AGEmojiKeyboardView!, imageForSelectedCategory category: AGEmojiKeyboardViewCategoryImage) -> UIImage! {
        return emojiKeyboardImages[category.rawValue]
    }
    
    func emojiKeyboardView(emojiKeyboardView: AGEmojiKeyboardView!, imageForNonSelectedCategory category: AGEmojiKeyboardViewCategoryImage) -> UIImage! {
        return emojiKeyboardImages[category.rawValue]
    }
    
    func backSpaceButtonImageForEmojiKeyboardView(emojiKeyboardView: AGEmojiKeyboardView!) -> UIImage! {
        return UIImage(named: "backspace")
    }
}
