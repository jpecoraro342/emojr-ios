//
//  NoDataView.swift
//  Emojr
//
//  Created by James on 11/13/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation

class NoDataView: UIView {
    @IBOutlet weak var messageLabel: UILabel!
    
    class func instanceFromNib(message: String) -> NoDataView {
        let view = UINib(nibName: "NoDataView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoDataView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.messageLabel.text = message
        
        return view
    }
}
