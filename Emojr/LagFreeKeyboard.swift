//
//  LagFreeKeyboard.swift
//  Emojr
//
//  Created by James on 5/4/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import UIKit

struct KeyboardCacher {
    static var hasAlreadyCachedKeyboard: Bool = false
    
    static func cacheKeyboard(onNextRunloop: Bool, customInputView: UIView? = nil) {
        if (!KeyboardCacher.hasAlreadyCachedKeyboard)
        {
            KeyboardCacher.hasAlreadyCachedKeyboard = true
            
            if (onNextRunloop) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    KeyboardCacher.cacheKeyboard(customInputView: customInputView)
                }
            } else {
                KeyboardCacher.cacheKeyboard(customInputView: customInputView)
            }
        }
    }
    
    private static func cacheKeyboard(customInputView: UIView? = nil) {
        let field = UITextField()
        
        UIApplication.shared.keyWindow?.addSubview(field)
        
        field.becomeFirstResponder()
        field.resignFirstResponder()
        
        if let customView = customInputView {
            field.inputView = customView
            field.becomeFirstResponder()
            field.resignFirstResponder()
        }
        
        field.removeFromSuperview()
    }
}
