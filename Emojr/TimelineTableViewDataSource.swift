//
//  TimelineTableViewDataSource.swift
//  Emojr
//
//  Created by James on 4/6/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

protocol TimelineTableViewDelegate {
    func cellSelectedInTable(tableView: UITableView, indexPath: NSIndexPath)
}

class TimelineTableViewDataSource: NSObject {
    var delegate: TimelineTableViewDelegate?
    var posts: [Post] = []
    
    func configureWithPosts(posts: [Post], delegate: TimelineTableViewDelegate) {
        self.posts = posts
        sortPostsByDate()
        self.delegate = delegate
    }
    
    func sortPostsByDate() {
        posts.sortInPlace({$0.created!.isGreaterThanDate($1.created!)})
    }
}

extension TimelineTableViewDataSource : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.cellSelectedInTable(tableView, indexPath: indexPath)
    }
}

extension TimelineTableViewDataSource : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as! TimelineTableViewCell;
        
        let post = posts[indexPath.row];
        
        cell.configureWithPost(post)
        
        return cell;
    }
}
