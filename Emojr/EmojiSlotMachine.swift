//
//  EmojiSlotMachine.swift
//  Emojr
//
//  Created by James Risberg on 3/31/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import Foundation
import UIKit

class EmojiSlotMachine: UIView {
    let emojis: [String] = Emojis().allEmojis["Animals"]!
    
    var randomizeTimer: Timer?
    
    lazy var emojiStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        for _ in 0..<3 {
            stackView.addArrangedSubview(self.emojiLabel())
        }
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStackView()
        
        randomizeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(randomizeLabels), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupStackView()
    }
    
    deinit {
        randomizeTimer?.invalidate()
    }
    
    func setupStackView() {
        addSubview(emojiStackView)
        emojiStackView.constrainToEdges(of: self)
    }
    
    func emojiLabel() -> UILabel {
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = .systemFont(ofSize: 25.0)
        emojiLabel.textAlignment = .center
        
        randomize(label: emojiLabel)
        
        return emojiLabel
    }
    
    func randomize(label: UILabel) {
        let randomNumba = Int(arc4random_uniform(UInt32(emojis.count)))
        label.text = emojis[randomNumba]
    }
    
    func randomizeLabels() {
        for label in emojiStackView.arrangedSubviews {
            if let label = label as? UILabel {
                randomize(label: label)
            }
        }
    }
    
    func start() {
        randomizeTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                              target: self,
                                              selector: #selector(randomizeLabels),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    func stop() {
        randomizeTimer?.invalidate()
    }
}
