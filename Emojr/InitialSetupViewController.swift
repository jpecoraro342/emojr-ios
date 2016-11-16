//
//  InitialSetupViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 6/8/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class InitialSetupViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        attemptLogin()
    }
    
    func attemptLogin() {
        LoginManager().attemptLogin(activityIndicator)
    }
}
