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
    
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        attemptLogin()
    }
    
    func attemptLogin() {
        loginManager.attemptLogin(activityIndicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
