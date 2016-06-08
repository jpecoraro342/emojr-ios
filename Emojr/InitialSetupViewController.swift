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
        
        attemptLogin()
    }
    
    func attemptLogin() {
        if User.sharedInstance.manuallyLoggedOut {
            skipLogin()
        }
        
        guard let username = UICKeyChainStore.stringForKey("com.currentuser.username", service: "com.emojr")
            else { skipLogin(); return; }
        
        guard let password = UICKeyChainStore.stringForKey("com.currentuser.password", service: "com.emojr")
            else { skipLogin(); return; }
        
        login(username, password: password)
    }
    
    func login(username: String, password: String) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        NetworkFacade.sharedInstance.signInUser(username, password: password) { (error, user) in
            if let _ = error {
                self.skipLogin()
            } else if let data = user {
                User.sharedInstance.configureWithUserData(data)
                
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
                
                self.performSegueWithIdentifier(InitialSetupToMainTab, sender: self)
            }
        }
    }
    
    func skipLogin() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
