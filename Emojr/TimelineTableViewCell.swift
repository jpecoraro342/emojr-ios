//
//  TimelineTableViewCell.swift
//  Emojr
//
//  Created by James on 3/26/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusImageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var reactionsLabel: UILabel!
    
    var reactions: [Reaction] = []

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithPost(post: Post) {
        usernameLabel.text = post.user.username
        statusImageLabel.text = post.post
        timestampLabel.text = timeDisplayForTimestamp(post.created)
        reactions = post.reactions
        configureReactions()
    }
    
    func configureReactions() {
        var reactionString = ""
        
        for reaction in reactions {
            reactionString += reaction.reaction
        }
        
        reactionsLabel.text = reactionString
    }
    
    func timeDisplayForTimestamp(date: NSDate) -> String {
        let past = NSDate().timeIntervalSinceDate(date)
        
        print(date)
        
        let pastInt = Int(past)
        
        print(pastInt)
        
        if pastInt < 60 {
            return "\(pastInt)s"
        } else if pastInt < 3600 {
            let minutes = pastInt / 60
            return "\(minutes)m"
        } else if pastInt < 86400 {
            let hours = pastInt / 3600
            return "\(hours)h"
        } else if pastInt < 604800 {
            let days = pastInt / 86400
            return "\(days)d"
        } else {
            let weeks = pastInt / 604800
            return "\(weeks)w"
        }
    }
}
