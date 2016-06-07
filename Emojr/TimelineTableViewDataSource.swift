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
    func loadingCellDisplayed(cell: LoadingTableViewCell)
    func shouldShowLoadingCell() -> Bool
}

class TimelineTableViewDataSource: NSObject {
    var delegate: TimelineTableViewDelegate?
    var posts: [Post] = []
    
    func configureWithPosts(posts: [Post], delegate: TimelineTableViewDelegate?=nil) {
        self.posts = posts
        self.delegate = delegate
    }
    
    func addPosts(newPosts: [Post]) {
        self.posts.appendContentsOf(newPosts)
    }
    
    func sortPostsByDate() {
        posts.sortInPlace({$0.created!.isGreaterThanDate($1.created!)})
    }
    
    func insertPost(newPost: Post) {
        posts.insert(newPost, atIndex: 0)
    }
}

extension TimelineTableViewDataSource : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            delegate?.cellSelectedInTable(tableView, indexPath: indexPath)
        }
        else {
            // Tapped on refresh cell
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            let refreshCell = cell as! LoadingTableViewCell
            print("displaying refresh cell")
            
            delegate?.loadingCellDisplayed(refreshCell)
        }
    }
}

extension TimelineTableViewDataSource : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if delegate != nil {
            return delegate!.shouldShowLoadingCell() ? 2 : 1
        }
        else {
            return 1;
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 120 : 80;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? posts.count : 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            return getTimelineCellForRow(tableView, row: indexPath.row)
        }
        else {
            return tableView.dequeueReusableCellWithIdentifier(LoadingCellIdentifier, forIndexPath: indexPath) as! LoadingTableViewCell
        }
    }
    
    func getTimelineCellForRow(tableView: UITableView, row: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as! TimelineTableViewCell;
        
        let post = posts[row];
        
        cell.configureWithPost(post)
        
        return cell;
    }
}
