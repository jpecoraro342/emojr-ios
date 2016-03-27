//
//  LoginViewController.swift
//  Emojr
//
//  Created by James on 3/26/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func styleViews() {
        styleViewWithShadow(signInButton)
    }
    
    func styleViewWithShadow(view: UIView) {
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        view.layer.shadowRadius = 1.0
        view.layer.cornerRadius = 4.0
    }
    
    func fadeInFieldBar(bar: UIView) {
        UIView.animateWithDuration(0.3) { 
            bar.backgroundColor = blueLight
        }
    }
    
    func fadeOutFieldBar(bar: UIView) {
        UIView.animateWithDuration(0.3) {
            bar.backgroundColor = offWhite
        }
    }
    
    @IBAction func signIn() {
        errorLabel.hidden = true
        let (valid, message) = validLoginForm()
        
        if valid {
            NetworkFacade.sharedInstance.signInUser(usernameField.text!, password: passwordField.text!) { (error, user) in
                if let e = error {
                    self.displayError(e.localizedDescription)
                } else if let data = user {
                    User.sharedInstance.configureWithUserData(data)
                    self.performSegueWithIdentifier("login", sender: self)
                }
            }
        } else {
            displayError(message)
        }
    }
    
    func displayError(message: String) {
        errorLabel.text = message
        errorLabel.hidden = false
    }
    
    @IBAction func signUp() {
        
    }
    
    func validLoginForm() -> (Bool, String) {
        if let username = usernameField.text {
            if let password = passwordField.text {
                if (username == "" || password == "") {
                    return (false, "Please fill out both fields!")
                }
            } else {
                return (false, "Please fill out both fields!")
            }
        } else {
            return (false, "Please fill out both fields!")
        }
        
        return (true, "Success")
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isEqual(usernameField) {
            fadeInFieldBar(usernameView)
        } else {
            fadeInFieldBar(passwordView)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.isEqual(usernameField) {
            fadeOutFieldBar(usernameView)
        } else {
            fadeOutFieldBar(passwordView)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
