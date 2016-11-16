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
    
    var emojiKeyboard = EmojiKeyboard()
    
    class func instanceFromNib() -> EmoteView {
        return UINib(nibName: "EmoteView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmoteView
    }
    
    func configureWithController(_ controller: TimelineViewController) {
        self.controller = controller
        emojiField.delegate = self
        configureEmojiKeyboard()
        styleViews()
    }
    
    func configureEmojiKeyboard() {
        emojiField.inputView = emojiKeyboard.getKeyboardView()
        emojiKeyboard.delegate = self
    }
    
    func setButtonTitle(_ reacting: Bool) {
        self.reacting = reacting
        if !reacting {
            emoteButton.setTitle("Emote!", for: UIControlState())
        } else {
            emoteButton.setTitle("React!", for: UIControlState())
        }
    }
    
    func styleViews() {
        styleViewWithShadow(emoteButton)
    }
    
    func styleViewWithShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
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
    
    func fadeInFieldBar(_ bar: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            bar.backgroundColor = blueLight
        }) 
    }
    
    func fadeOutFieldBar(_ bar: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            bar.backgroundColor = offWhite
        }) 
    }
}

extension EmoteView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fadeInFieldBar(textFieldBar)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        fadeOutFieldBar(textFieldBar)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension EmoteView: EmojiKeyboardDelegate {
    func emojiKeyBoarDidUseEmoji(_ emojiKeyBoard: EmojiKeyboard, emoji: String) {
        if reacting {
            let newLength = (emojiField.text?.characters.count)! + 1
            if newLength <= 1 {
                emojiField.text = (emojiField.text ?? "") + emoji
            }
        } else {
            emojiField.text = (emojiField.text ?? "") + emoji
        }
    }
    
    func emojiKeyBoardDidPressBackSpace(_ emojiKeyBoard: EmojiKeyboard) {
        if var text = emojiField.text {
            if text != "" {
                text.remove(at: text.characters.index(before: text.endIndex))
                emojiField.text = text
            }
        }
    }
}
