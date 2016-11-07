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
    var post: Post?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithPost(_ post: Post) {
        self.post = post
        usernameLabel.text = post.user!.username
        statusImageLabel.text = post.post
        timestampLabel.text = timeDisplayForTimestamp(post.created as Date? ?? Date())
        reactions = post.reactions
        configureReactions()
    }
    
    func configureReactions() {
        var reactionString = ""
        
        for reaction in reactions {
            reactionString += reaction.reaction!
        }
        
        reactionsLabel.text = reactionString
    }
    
    func addReaction(_ reaction: String) {
        if let currentString = reactionsLabel.text {
            var newReactionString = currentString
            newReactionString += reaction
            reactionsLabel.text = newReactionString
        } else {
            reactionsLabel.text = reaction
        }
    }
    
    func timeDisplayForTimestamp(_ date: Date) -> String {
        let past = Date().timeIntervalSince(date)
        
        let pastInt = Int(past)
        
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
