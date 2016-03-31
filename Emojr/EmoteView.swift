//
//  EmoteView.swift
//  Emojr
//
//  Created by James on 3/26/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class EmoteView: UIView {
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var emojiField: UITextField!
    @IBOutlet weak var emoteButton: UIButton!
    @IBOutlet weak var textFieldBar: UIView!

    var controller: TimelineViewController?
    
    var reacting = false
    
    class func instanceFromNib() -> EmoteView {
        return UINib(nibName: "EmoteView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! EmoteView
    }
    
    func configureWithController(controller: TimelineViewController) {
        self.controller = controller
        emojiField.delegate = self
        configureEmojiKeyboard()
        styleViews()
    }
    
    func configureEmojiKeyboard() {
        let keyboardFrame = CGRectMake(0, 0, self.frame.width, 500)
        let emojiKeyboard = AGEmojiKeyboardView(frame: keyboardFrame, dataSource: self)
        emojiKeyboard.autoresizingMask = .FlexibleHeight
        emojiKeyboard.delegate = self
        emojiKeyboard.backgroundColor = blue
        emojiKeyboard.segmentsBar.backgroundColor = UIColor.clearColor()
        emojiKeyboard.segmentsBar.tintColor = offWhite
        emojiKeyboard.segmentsBar.contentMode = .ScaleAspectFill
        emojiField.inputView = emojiKeyboard
    }
    
    func setButtonTitle(reacting: Bool) {
        self.reacting = reacting
        if !reacting {
            emoteButton.setTitle("Emote!", forState: .Normal)
        } else {
            emoteButton.setTitle("React!", forState: .Normal)
        }
    }
    
    func styleViews() {
        styleViewWithShadow(emoteButton)
    }
    
    func styleViewWithShadow(view: UIView) {
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        view.layer.shadowRadius = 1.0
        view.layer.cornerRadius = 4.0
    }
    
    @IBAction func exitButtonTouched() {
        emojiField.text = ""
        controller!.dismissPostForm()
    }
    
    @IBAction func emoteButtonTouched() {
        if let post = emojiField.text {
            emojiField.text = ""
            controller!.postFormReturnedPost(post)
        }
    }
    
    func fadeInFieldBar(bar: UIView) {
        UIView.animateWithDuration(0.3) {
            bar.backgroundColor = blueLight
        }
    }
    
    func fadeOutFieldBar(bar: UIView) {
        UIView.animateWithDuration(0.3) {
            bar.backgroundColor = offWhite
        }
    }
}

extension EmoteView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        fadeInFieldBar(textFieldBar)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        fadeOutFieldBar(textFieldBar)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension EmoteView: AGEmojiKeyboardViewDelegate {
    func emojiKeyBoardView(emojiKeyBoardView: AGEmojiKeyboardView!, didUseEmoji emoji: String!) {
        if reacting {
            let newLength = (emojiField.text?.characters.count)! + 1
            if newLength <= 1 {
                emojiField.text = emojiField.text?.stringByAppendingString(emoji)
            }
        } else {
            emojiField.text = emojiField.text?.stringByAppendingString(emoji)
        }
    }
    
    func emojiKeyBoardViewDidPressBackSpace(emojiKeyBoardView: AGEmojiKeyboardView!) {
        if var text = emojiField.text {
            if text != "" {
                text.removeAtIndex(text.endIndex.predecessor())
                emojiField.text = text
            }
        }
    }
}

extension EmoteView: AGEmojiKeyboardViewDataSource {
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
