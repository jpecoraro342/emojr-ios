//
//  SignUpViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class SignUpViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dupPasswordField: UITextField!
    
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var dupPasswordView: UIView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var fieldViewDict = Dictionary<UITextField, UIView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleViews()
        
        fieldViewDict[usernameField] = usernameView
        fieldViewDict[emailField] = emailView
        fieldViewDict[passwordField] = passwordView
        fieldViewDict[dupPasswordField] = dupPasswordView
    }
    
    func styleViews() {
        styleViewWithShadow(signUpButton)
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
    
    @IBAction func signUp() {
        errorLabel.isHidden = true
        let (valid, message) = validSignupForm()
        
        if valid {
            SVProgressHUD.show()
            
            NetworkFacade.sharedInstance.signUpUser(usernameField.text!,
                                                    email: emailField.text!,
                                                    password: passwordField.text!,
                                                    completionBlock: { (errorString, userData) in
                
                if let errorMessage = errorString {
                    
                    self.displayError(errorMessage)
                    SVProgressHUD.dismiss()
                    
                } else if let userData = userData {
                    User.sharedInstance.configureWithUserData(userData)
                    
                    UICKeyChainStore.setString(self.emailField.text, forKey: "com.currentuser.email", service: "com.emojr")
                    UICKeyChainStore.setString(self.passwordField.text, forKey: "com.currentuser.password", service: "com.emojr")
                    
                    SVProgressHUD.dismiss()
                    
                    self.navigateToMainTab()
                }
            })
        } else {
            displayError(message)
            SVProgressHUD.dismiss()
        }
    }
    
    func navigateToMainTab() {
        let tabVC = LoginManager().getMainTab(true)
        if let window = UIApplication.shared.delegate?.window {
            window!.rootViewController = tabVC
        }
    }
    
    func displayError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func validSignupForm() -> (Bool, String) {
        if let username = usernameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            let dupPassword = dupPasswordField.text {
            
            if (username == "" || email == "" || password == "" || dupPassword == "") {
                return (false, "Please fill out all fields!")
            } else {
                // TODO: plug in emoji validate
                
                if (passwordField.text != dupPasswordField.text) {
                    return (false, "Passwords must match!")
                }
                
                return (true, "Success")
            }
        } else {
            return (false, "Please fill out all fields!")
        }
    }
    
    @IBAction func backgroundTapped(_ sender: AnyObject) {
        self.view.endEditing(true);
    }
    
    @IBAction func toLoginPressed(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fadeInFieldBar(fieldViewDict[textField]!)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        fadeOutFieldBar(fieldViewDict[textField]!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

extension SignUpViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

