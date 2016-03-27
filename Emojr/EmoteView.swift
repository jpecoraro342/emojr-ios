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

    var controller: TimelineViewController?;
    
    class func instanceFromNib() -> EmoteView {
        return UINib(nibName: "EmoteView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! EmoteView
    }
    
    func configureWithController(controller: TimelineViewController) {
        self.controller = controller
        emojiField.delegate = self
        styleViews()
    }
    
    func setButtonTitle(reacting: Bool) {
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
        // TODO: Check if new string is an emoji
        
        var newTextLength = string.characters.count
        
        if let count = textField.text?.characters.count {
            newTextLength += count
        }
        
        if newTextLength <= 1 {
            return true
        }
        return false
    }
}
