//
//  EmojiSearchViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 7/1/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

protocol EmojiSearchViewControllerDelegate {
    func didSelectEmoji(_ emoji: String);
}

class EmojiSearchViewController: UIViewController {
    var emojiTableView = UITableView()
    var emojiValidator = EmojiValidator()
    var emojiList = [String]()
    
    var delegate : EmojiSearchViewControllerDelegate?
    var targetTextfield : UITextField?
    var emojiTextManager = EmojiTextFieldInputManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func layoutTableView() {
        view.addSubview(emojiTableView)
        
        emojiTableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        emojiTableView.delegate = self;
        emojiTableView.dataSource = self;
        emojiTableView.rowHeight = 60;
        emojiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmojiListCell")
    }
    
    func updateEmojiSearchWithString(_ oldText : String, newText : String, changedText : String) -> String {
        let updatedTextFieldValue = emojiTextManager.updatedStringForEmojiField(oldText, newText: newText, changedText: changedText)
        let searchString = emojiTextManager.emojiSearchString(updatedTextFieldValue)
        
        if let searchValue = searchString {
            emojiList = emojiValidator.emojisForNameStartingWith(searchValue)
            self.emojiTableView.reloadData()
        }
        
        targetTextfield?.text = updatedTextFieldValue
        
        return updatedTextFieldValue;
    }
}

extension EmojiSearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        emojiTableView.deselectRow(at: indexPath, animated: true)
        let emoji = emojiList[indexPath.row]
        delegate?.didSelectEmoji(emoji)
    }
}

extension EmojiSearchViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emojiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = emojiTableView.dequeueReusableCell(withIdentifier: "EmojiListCell")!;
        
        let emoji = emojiList[indexPath.row]
        
        cell.textLabel?.text = "\(emoji) - \(emojiValidator.nameForEmoji(emoji)!)"
        
        return cell;
    }
}

extension EmojiSearchViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("Current Text - \"\(textField.text!)\"")
//        print("Replacement Text - \"\(string)\"")
//        print("Range - \(range.location)-\(range.length)")
        
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        textField.text = updateEmojiSearchWithString(textField.text!, newText: newText, changedText: string)
        
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension EmojiSearchViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
