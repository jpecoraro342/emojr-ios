//
//  TimelineTableViewDataSource.swift
//  Emojr
//
//  Created by James on 4/6/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit
import Alamofire

protocol TimelineTableViewDelegate {
    func cellSelectedInTable(_ tableView: UITableView, indexPath: IndexPath)
    func loadingCellDisplayed(_ cell: LoadingTableViewCell)
    func shouldShowLoadingCell() -> Bool
    func dataSourceGotData(dataChanged: Bool)
}

class TimelineTableViewDataSource: NSObject {
    let networkFacade = NetworkFacade()
    var delegate: TimelineTableViewDelegate?
    private(set) var posts: [Post] = []
    
    private var loading = false
    var endOfData = false
    var lastEvaluatedKey: String?
    
    var type: Timeline
    
    init(with type: Timeline) {
        self.type = type
    }
    
    func getFirstPage() {
        lastEvaluatedKey = nil
        getPosts(shouldRefresh: true)
    }
    
    func getNextPage() {
        getPosts(shouldRefresh: false)
    }
    
    func getPosts(shouldRefresh: Bool) {
        // TODO: Move to a new way of determining which type of posts to grab. Send user id and Bool for following or user's?
        if !loading {
            loading = true
            
            let completionHandler: (Error?, [Post]?) -> Void = { error, posts in
                guard let newPosts = posts else {
                    self.loading = false
                    
                    self.delegate?.dataSourceGotData(dataChanged: false)
                    
                    return
                }
                
                if error == nil {
                    
                    if shouldRefresh {
                        self.posts = newPosts
                    } else {
                        self.addPosts(newPosts)
                    }
                    
                    if newPosts.count < 100 {
                        self.endOfData = true
                    } else {
                        self.endOfData = false
                    }
                    
                    self.lastEvaluatedKey = self.posts.last?.key
                    self.loading = false
                    
                    self.delegate?.dataSourceGotData(dataChanged: true)
                } else {
                    self.loading = false
                    
                    self.delegate?.dataSourceGotData(dataChanged: false)
                }
            }
            
            if !endOfData || shouldRefresh {
                switch type {
                case .home:
                    networkFacade.getAllFollowingPosts(User.sharedInstance.id!,
                                                       lastEvaluatedKey: lastEvaluatedKey,
                                                       completionBlock: completionHandler)
                case .discover:
                    networkFacade.getDiscoverPosts(lastEvaluatedKey: lastEvaluatedKey,
                                                   completionBlock: completionHandler)
                case .user(let user):
                    if let userID = user?.id {
                        networkFacade.getAllPostsFromUser(userID,
                                                          lastEvaluatedKey: lastEvaluatedKey,
                                                          completionBlock: completionHandler)
                    }
                }
            }
        }
    }
    
    func addPosts(_ newPosts: [Post]) {
        self.posts.append(contentsOf: newPosts)
    }
    
    func insertPost(_ newPost: Post) {
        posts.insert(newPost, at: 0)
    }
}

extension TimelineTableViewDataSource : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            delegate?.cellSelectedInTable(tableView, indexPath: indexPath)
        }
        else {
            // Tapped on refresh cell
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            let refreshCell = cell as! LoadingTableViewCell
            print("displaying refresh cell")
            
            delegate?.loadingCellDisplayed(refreshCell)
        }
    }
}

extension TimelineTableViewDataSource : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return endOfData ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 120 : 80;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? posts.count : 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            return getTimelineCellForRow(tableView, row: indexPath.row)
        }
        else {
            return tableView.dequeueReusableCell(withIdentifier: LoadingCellIdentifier, for: indexPath) as! LoadingTableViewCell
        }
    }
    
    func getTimelineCellForRow(_ tableView: UITableView, row: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell") as! TimelineTableViewCell;
        
        let post = posts[row];
        
        cell.configureWithPost(post)
        
        return cell;
    }
}
