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

    weak var controller: TimelineViewController?
    
    var reacting = false
    
    var emojiSearchView = EmojiSearchView()
    
    class func instanceFromNib() -> EmoteView {
        return UINib(nibName: "EmoteView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmoteView
    }
    
    func configureWithController(_ controller: TimelineViewController) {
        self.controller = controller
        emojiField.delegate = self
        emojiField.autocorrectionType = .no
        configureEmojiKeyboard()
        styleViews()
    }
    
    func configureEmojiKeyboard() {
        emojiSearchView.linkTextfield(textfield: emojiField)
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
        if let post = emojiField.text?.emojiString, !post.isEmpty {
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
        return emojiSearchView.textFieldShouldReturn(_: textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fadeInFieldBar(textFieldBar)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        fadeOutFieldBar(textFieldBar)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if reacting && !string.isEmpty {
            if let text = textField.text, text.glyphCount > 0 && text.isSingleEmoji {
                return false
            }
        }
        
        return emojiSearchView.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}
