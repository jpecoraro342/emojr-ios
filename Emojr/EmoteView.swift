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

    var controller: TimelineViewController?;
    
    class func instanceFromNib() -> EmoteView {
        return UINib(nibName: "EmoteView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! EmoteView
    }
    
    func configureWithController(controller: TimelineViewController) {
        self.controller = controller
        emojiField.delegate = self
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
}

extension EmoteView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
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
