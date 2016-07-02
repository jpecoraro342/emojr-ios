//
//  EmojiSearchViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 7/1/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

protocol EmojiSearchViewControllerDelegate {
    func didSelectEmoji(emoji: String);
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
        
        delegate = self
        
        view.backgroundColor = UIColor.whiteColor()
        
        layoutTestingTextField()
        layoutTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func layoutTableView() {
        view.addSubview(emojiTableView)
        
        emojiTableView.snp_makeConstraints { (make) in
            // make.top.equalTo(self.view)
            make.top.equalTo(self.targetTextfield!.snp_bottom)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        emojiTableView.delegate = self;
        emojiTableView.dataSource = self;
        emojiTableView.rowHeight = 60;
        emojiTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "EmojiListCell")
    }
    
    func layoutTestingTextField() {
        targetTextfield = UITextField()
        targetTextfield!.delegate = self
        
        view.addSubview(targetTextfield!)
        
        targetTextfield?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.view)
            make.height.equalTo(40)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        })
    }
    
    func updateEmojiSearchWithString(oldText : String, newText : String, changedText : String) -> String {
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        emojiTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let emoji = emojiList[indexPath.row]
        delegate?.didSelectEmoji(emoji)
    }
}

extension EmojiSearchViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emojiList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = emojiTableView.dequeueReusableCellWithIdentifier("EmojiListCell")!;
        
        let emoji = emojiList[indexPath.row]
        
        cell.textLabel?.text = "\(emoji) - \(emojiValidator.nameForEmoji(emoji)!)"
        
        return cell;
    }
}

extension EmojiSearchViewController : EmojiSearchViewControllerDelegate {
    func didSelectEmoji(emoji: String) {
        updateEmojiSearchWithString(targetTextfield!.text!, newText: "\(targetTextfield!.text!)\(emoji)", changedText: emoji)
    }
}

extension EmojiSearchViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("Current Text - \"\(textField.text!)\"")
        print("Replacement Text - \"\(string)\"")
        print("Range - \(range.location)-\(range.length)")
        
        let newText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        textField.text = updateEmojiSearchWithString(textField.text!, newText: newText, changedText: string)
        
        return false
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
}

extension EmojiSearchViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
