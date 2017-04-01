//
//  EmojiKeyboard.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/9/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

protocol EmojiKeyboardDelegate: class {
    func emojiKeyBoarDidUseEmoji(_ emojiKeyBoard: EmojiKeyboard, emoji: String)
    func emojiKeyBoardDidPressBackSpace(_ emojiKeyBoard: EmojiKeyboard)
}

class EmojiKeyboard: NSObject {
    
    var keyboardView: AGEmojiKeyboardView?
    weak var delegate: EmojiKeyboardDelegate?
    
    let emojiKeyboardImages: [UIImage] = [UIImage(named: "recentCategory")!,
                                          UIImage(named: "smileysCategory")!,
                                          UIImage(named: "animalsCategory")!,
                                          UIImage(named: "foodCategory")!,
                                          UIImage(named: "activityCategory")!,
                                          UIImage(named: "travelCategory")!,
                                          UIImage(named: "objectsCategory")!,
                                          UIImage(named: "symbolsCategory")!,
                                          UIImage(named: "flagsCategory")!]
    
    override init() {
        super.init()
        
        keyboardView = getEmojiKeyboard()
    }
    
    func getKeyboardView() -> AGEmojiKeyboardView {
        return keyboardView!
    }
    
    fileprivate func getEmojiKeyboard() -> AGEmojiKeyboardView {
        let keyboardWidth = UIScreen.main.bounds.size.width
        let keyboardHeight: CGFloat = 500.0
        let keyboardFrame = CGRect(x: 0, y: 0, width: keyboardWidth, height: keyboardHeight)
        let emojiKeyboard = AGEmojiKeyboardView(frame: keyboardFrame, dataSource: self)
        emojiKeyboard?.autoresizingMask = .flexibleHeight
        emojiKeyboard?.delegate = self
        emojiKeyboard?.backgroundColor = blue
        emojiKeyboard?.segmentsBar.backgroundColor = UIColor.clear
        emojiKeyboard?.segmentsBar.tintColor = offWhite
        emojiKeyboard?.segmentsBar.contentMode = .scaleAspectFill
        
        return emojiKeyboard!
    }
}

extension EmojiKeyboard : AGEmojiKeyboardViewDelegate {
    func emojiKeyBoardView(_ emojiKeyBoardView: AGEmojiKeyboardView!, didUseEmoji emoji: String!) {
        delegate?.emojiKeyBoarDidUseEmoji(self, emoji: emoji)
    }
    
    func emojiKeyBoardViewDidPressBackSpace(_ emojiKeyBoardView: AGEmojiKeyboardView!) {
        delegate?.emojiKeyBoardDidPressBackSpace(self)
    }
}

extension EmojiKeyboard : AGEmojiKeyboardViewDataSource {
    func emojiKeyboardView(_ emojiKeyboardView: AGEmojiKeyboardView!, imageForSelectedCategory category: AGEmojiKeyboardViewCategoryImage) -> UIImage! {
        return emojiKeyboardImages[category.rawValue]
    }
    
    func emojiKeyboardView(_ emojiKeyboardView: AGEmojiKeyboardView!, imageForNonSelectedCategory category: AGEmojiKeyboardViewCategoryImage) -> UIImage! {
        return emojiKeyboardImages[category.rawValue]
    }
    
    func backSpaceButtonImage(for emojiKeyboardView: AGEmojiKeyboardView!) -> UIImage! {
        return UIImage(named: "backspace")
    }
}
