//
//  EmojiSearchView.swift
//  Emojr
//
//  Created by James Risberg on 4/22/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import UIKit

class EmojiSearchView: UIView {
    
    fileprivate var emojiValidator = EmojiValidator()
    fileprivate var emojiList = [String]()
    fileprivate var emojiTextManager = EmojiTextFieldInputManager()
    
    fileprivate var targetTextField: UITextField?
    
    lazy fileprivate var emojiCollectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let view = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        
        view.backgroundColor = UIColor(hexString: "CBCCD1")
        
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCollectionCell")
        
        return view
    }()
    
    fileprivate let noDataLabel = UILabel()
    lazy fileprivate var noDataView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "CBCCD1")
        
        self.noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        self.noDataLabel.textAlignment = .center
        view.addSubview(self.noDataLabel)
        self.noDataLabel.constrainToEdges(of: view)

        return view
    }()
    
    override init(frame: CGRect) {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(emojiCollectionView)
        emojiCollectionView.constrainToEdges(of: self)
        
        addNoDataView(with: "Start typing to search for emoji 🔍")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func linkTextfield(textfield: UITextField) {
        targetTextField = textfield
        textfield.inputAccessoryView = self
    }
    
    private func addNoDataView(with string: String) {
        noDataView.frame = bounds
        noDataLabel.text = string
        addSubview(noDataView)
    }
    
    func updateEmojiSearchWithString(_ oldText : String, newText : String, changedText : String) -> String {
        let updatedTextFieldValue = emojiTextManager.updatedStringForEmojiField(oldText, newText: newText, changedText: changedText)
        let searchString = emojiTextManager.emojiSearchString(updatedTextFieldValue)
        
        if let searchValue = searchString {
            emojiList = emojiValidator.emojisForNameStartingWith(searchValue)
            
            if emojiList.count == 0 {
                addNoDataView(with: "No emoji match this search 🚫")
            } else {
                noDataView.removeFromSuperview()
            }
            
            emojiCollectionView.reloadData()
        } else {
            addNoDataView(with: "Start typing to search for emoji 🔍")
        }
                
        return updatedTextFieldValue;
    }

}

// MARK: - UITextFieldDelegate

extension EmojiSearchView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        textField.text = updateEmojiSearchWithString(textField.text!, newText: newText, changedText: string)
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.emojiString
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension EmojiSearchView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = emojiList[indexPath.item]
        
        let oldText = targetTextField?.text ?? ""
        targetTextField?.text = updateEmojiSearchWithString(oldText, newText: oldText + emoji, changedText: emoji)
    }
}

// MARK: - UICollectionViewDataSource

extension EmojiSearchView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.emojiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionCell",
                                                      for: indexPath)
        
        let emoji = emojiList[indexPath.item]
        
        if cell.contentView.subviews.count > 0 {
            if let label = cell.contentView.subviews[0] as? UILabel {
                label.text = emoji
            }
        } else {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = emoji
            label.font = UIFont.systemFont(ofSize: 40)
            label.adjustsFontSizeToFitWidth = true

            cell.contentView.addSubview(label)
            label.constrainToEdges(of: cell.contentView)
        }
        
        return cell
    }
}
