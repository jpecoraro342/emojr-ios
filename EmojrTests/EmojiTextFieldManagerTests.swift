//
//  EmojiTextFieldManagerTests.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 7/2/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import XCTest

class EmojiTextFieldManagerTests: XCTestCase {
    let emojiFieldManager = EmojiTextFieldInputManager()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLetterInputShouldAddLetterWithValidEmojiSearchString() {
        let startString = ""
        let newString = "a"
        let replacementString = "a"
        
        let finalString = emojiFieldManager.updatedStringForEmojiField(startString, newText: newString, changedText: replacementString)
        let searchString = emojiFieldManager.emojiSearchString(newString)
        
        XCTAssertEqual("a", finalString)
        XCTAssertEqual("a", searchString!)
    }
    
    func testAdditionalLetterInputShouldContinueWithValidEmojiSearchString() {
        let startString = "a"
        let newString = "ar"
        let replacementString = "r"
        
        let finalString = emojiFieldManager.updatedStringForEmojiField(startString, newText: newString, changedText: replacementString)
        let searchString = emojiFieldManager.emojiSearchString(newString)
        
        XCTAssertEqual("ar", finalString)
        XCTAssertEqual("ar", searchString!)
    }
    
    func testAddingLetterAfterEmojiShouldAddLetter() {
        let startString = "😄"
        let newString = "😄s"
        let replacementString = "s"
        
        let finalString = emojiFieldManager.updatedStringForEmojiField(startString, newText: newString, changedText: replacementString)
        let searchString = emojiFieldManager.emojiSearchString(newString)
        
        XCTAssertEqual("😄s", finalString)
        XCTAssertEqual("s", searchString!)
    }
    
    func testAddingLetterAfterEmojiWIthMultipleCharsShouldAddLetter() {
        let startString = "🇨🇻"
        let newString = "🇨🇻s"
        let replacementString = "s"
        
        let finalString = emojiFieldManager.updatedStringForEmojiField(startString, newText: newString, changedText: replacementString)
        let searchString = emojiFieldManager.emojiSearchString(newString)
        
        XCTAssertEqual("🇨🇻s", finalString)
        XCTAssertEqual("s", searchString!)
    }
    
    func testEmojiInputShouldAddEmoji() {
        let startString = ""
        let newString = "😄"
        let replacementString = "😄"
        
        let finalString = emojiFieldManager.updatedStringForEmojiField(startString, newText: newString, changedText: replacementString)
        let searchString = emojiFieldManager.emojiSearchString(newString)
        
        XCTAssertEqual("😄", finalString)
        XCTAssertNil(searchString)
    }
    
    func testEmojiInputShouldAddEmojiAndClearAllNonEmojiChars() {
        let startString = "test"
        let newString = "test😄"
        let replacementString = "😄"
        
        let finalString = emojiFieldManager.updatedStringForEmojiField(startString, newText: newString, changedText: replacementString)
        let searchString = emojiFieldManager.emojiSearchString(replacementString)
        
        XCTAssertEqual("😄", finalString)
        XCTAssertNil(searchString)
    }
    
    func testBackspaceShouldRemoveLastCharacterIfNonEmoji() {
        let startString = "this"
        let newString = "thi"
        let replacementString = ""
        
        let finalString = emojiFieldManager.updatedStringForEmojiField(startString, newText: newString, changedText: replacementString)
        let searchString = emojiFieldManager.emojiSearchString(newString)
        
        XCTAssertEqual("thi", finalString)
        XCTAssertEqual("thi", searchString)
    }
    
    func testBackspaceShouldRemoveLastCharacterIfEmoji() {
        let startString = "this"
        let newString = "thi"
        let replacementString = ""
        
        let finalString = emojiFieldManager.updatedStringForEmojiField(startString, newText: newString, changedText: replacementString)
        let searchString = emojiFieldManager.emojiSearchString(newString)
        
        XCTAssertEqual("thi", finalString)
        XCTAssertEqual("thi", searchString)
    }

    func testBackspaceShouldRemoveLastCharacterIfMultiEmoji() {
        let startString = "🇨🇻🇧🇷"
        let newString = "🇨🇻"
        let replacementString = ""
        
        let finalString = emojiFieldManager.updatedStringForEmojiField(startString, newText: newString, changedText: replacementString)
        let searchString = emojiFieldManager.emojiSearchString(newString)
        
        XCTAssertEqual("🇨🇻", finalString)
        XCTAssertNil(searchString)
    }
}
