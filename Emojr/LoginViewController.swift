//
//  LoginViewController.swift
//  Emojr
//
//  Created by James on 3/26/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let email = UICKeyChainStore.string(forKey: "com.currentuser.email", service: "com.emojr") {
            emailField.text = email
            
            if let password = UICKeyChainStore.string(forKey: "com.currentuser.password", service: "com.emojr") {
                passwordField.text = password
            }
        }
    }
    
    func styleViews() {
        styleViewWithShadow(signInButton)
    }
    
    func styleViewWithShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowRadius = 1.0
        view.layer.cornerRadius = 4.0
    }
    
    func fadeInFieldBar(_ bar: UIView) {
        UIView.animate(withDuration: 0.3, animations: { 
            bar.backgroundColor = blueLight
        }) 
    }
    
    func fadeOutFieldBar(_ bar: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            bar.backgroundColor = offWhite
        }) 
    }
    
    func disableUI() {
        signInButton.isEnabled = false
        signUpButton.isEnabled = false
        SVProgressHUD.show()
    }
    
    func enableUI() {
        signInButton.isEnabled = true
        signUpButton.isEnabled = true
        SVProgressHUD.dismiss()
    }
    
    @IBAction func signIn() {        
        errorLabel.isHidden = true
        let (valid, message) = validLoginForm()
        
        if valid {
            disableUI()
            LoginManager().login(emailField.text!, password: passwordField.text!) { (errorString, data) in
                if let errorString = errorString {
                    self.enableUI()
                    self.displayError(errorString)
                } else if let _ = data {
                    self.enableUI()
                    self.navigateToMainTab()
                }
            }
        } else {
            self.enableUI()
            displayError(message)
        }
    }
    
    func displayError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func navigateToMainTab() {
        let tabVC = LoginManager().getMainTab(true)
        if let window = UIApplication.shared.delegate?.window {
            window!.rootViewController = tabVC
            window?.makeKeyAndVisible()
        }
    }
    
    @IBAction func signUp() {
        UICKeyChainStore.setString(self.emailField.text, forKey: "com.currentuser.email", service: "com.emojr")
        UICKeyChainStore.setString(self.passwordField.text, forKey: "com.currentuser.password", service: "com.emojr")
        self.performSegue(withIdentifier: LoginToSignup, sender: self)
    }
    
    func validLoginForm() -> (Bool, String) {
        if let username = emailField.text, let password = passwordField.text {
            if (username == "" || password == "") {
                return (false, "Please fill out both fields!")
            } else {
                return (true, "Success")
            }
        } else {
            return (false, "Please fill out both fields!")
        }
    }
    
    @IBAction func backgroundTapped(_ sender: AnyObject) {
        self.view.endEditing(true);
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === emailField {
            fadeInFieldBar(emailView)
        } else {
            fadeInFieldBar(passwordView)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === emailField {
            fadeOutFieldBar(emailView)
        } else {
            fadeOutFieldBar(passwordView)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

extension LoginViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
