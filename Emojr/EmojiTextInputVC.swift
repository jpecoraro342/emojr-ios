//
//  EmojiTextInputVC.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 4/17/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import UIKit

class EmojiTextInputVC: EmojiSearchViewController {
    let inputTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(inputTextField)
        
        let margins = view.layoutMarginsGuide
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 30)
        
        
        inputTextField.delegate = self
        targetTextfield = inputTextField
        
        delegate = self
        
        emojiTableView.topAnchor.constraint(equalTo: inputTextField.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inputTextField.becomeFirstResponder()
    }
}
