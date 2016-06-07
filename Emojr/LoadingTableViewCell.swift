//
//  LoadingTableViewCell.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 5/22/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func isRefreshing() -> Bool {
        return activityIndicator.isAnimating()
    }
    
    func startRefreshAnimation() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func stopRefreshAnimation() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
}