//
//  EmojrTests.swift
//  EmojrTests
//
//  Created by Joseph Pecoraro on 7/1/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import XCTest

class EmojiValidationTests: XCTestCase {
    
    var emojiValidator: EmojiValidator?;
    
    override func setUp() {
        super.setUp()
        
        emojiValidator = EmojiValidator();
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCanDetermineStringIsEmoji() {
        XCTAssertTrue(emojiValidator!.isEmoji("😇"))
        XCTAssertTrue(emojiValidator!.isEmoji("🇳🇫"))
        XCTAssertTrue(emojiValidator!.isEmoji("📳"))
        XCTAssertTrue(emojiValidator!.isEmoji("🕰"))
        XCTAssertTrue(emojiValidator!.isEmoji("🕝"))
        XCTAssertTrue(emojiValidator!.isEmoji("❤️"))
    }
    
    
    func testCanFindColoredEmoji() {
        XCTAssertTrue(emojiValidator!.isEmoji("👧🏽"))
    }
    
    func testCanFindMultiPeopleEmoji() {
        XCTAssertTrue(emojiValidator!.isEmoji("👨‍👩‍👧‍👦"))
    }
    
    func testCanDetermineStringIsNotEmoji() {
        XCTAssertFalse(emojiValidator!.isEmoji("non emoji"))
        XCTAssertFalse(emojiValidator!.isEmoji(""))
    }
    
    func testCanFindEmojiForString() {
        
    }
    
    func testCanFindMultipleEmojisFromStringPrefix() {
        let arrows = ["⏩", "↖", "➡️", "⤵", "⬅️", "⏪", "🔚", "↘", "⬇️", "◀", "↔️", "🏹", "🔜", "🔛", "🔽", "🔼", "⤴️", "➡", "💘", "⤵️", "↪", "⤴", "↘️", "🔃", "⏯", "↩", "⏭", "⬆️", "⬆", "🔀", "⬅", "▶", "🔙", "🔂", "⬇", "↕", "↙", "↩️", "🔄", "⏮", "📩", "↕️", "🔁", "↗️", "↪️", "⏫", "↖️", "↗", "⏬", "📲", "↙️", "🔝", "↔"]
        let emojiSearchArrows = emojiValidator!.emojisForNameStartingWith("arrow")
        
        XCTAssertEqual(arrows, emojiSearchArrows)
    }
    
    func testNoEmojisForString() {
        XCTAssertEqual(0, emojiValidator!.emojisForNameStartingWith("ugly").count)
    }
    
    func testCanFindComplexEmoji() {
        
    }
    
}
