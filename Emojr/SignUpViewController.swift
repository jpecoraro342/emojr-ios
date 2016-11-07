//
//  SignUpViewController.swift
//  Emojr
//
//  Created by Joseph Pecoraro on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dupPasswordField: UITextField!
    
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var dupPasswordView: UIView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var fieldViewDict = Dictionary<UITextField, UIView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let username = UICKeyChainStore.stringForKey("com.currentuser.username", service: "com.emojr") {
//            usernameField.text = username
//            
//            if let password = UICKeyChainStore.stringForKey("com.currentuser.password", service: "com.emojr") {
//                passwordField.text = password
//            }
//        }
        
        styleViews()
        
        fieldViewDict[usernameField] = usernameView
        fieldViewDict[fullNameField] = fullNameView
        fieldViewDict[passwordField] = passwordView
        fieldViewDict[dupPasswordField] = dupPasswordView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            NetworkFacade.sharedInstance.signUpUser(usernameField.text!, password: passwordField.text!, fullname: fullNameField.text!) { (error, user) in
                if let e = error {
                    self.displayError(e.localizedDescription)
                } else if let data = user {
                    User.sharedInstance.configureWithUserData(data)
                    
                    UICKeyChainStore.setString(self.usernameField.text, forKey: "com.currentuser.username", service: "com.emojr")
                    UICKeyChainStore.setString(self.passwordField.text, forKey: "com.currentuser.password", service: "com.emojr")
                    
                    self.navigateToMainTab()
                }
            }
        } else {
            displayError(message)
        }
    }
    
    func navigateToMainTab() {
        let tabVC = LoginManager().getMainTab(true)
        self.navigationController?.present(tabVC, animated: true, completion: {
            if let window = UIApplication.shared.delegate?.window {
                window!.rootViewController = tabVC
            }
        })
    }
    
    func displayError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func validSignupForm() -> (Bool, String) {
        if let username = usernameField.text {
            if let password = passwordField.text {
                if let fullname = fullNameField.text {
                    if (username == "" || password == "" || fullname == "") {
                        return (false, "Please fill out all fields!")
                    }
                    else {
                        // TODO: plug in emoji validate
                        
                        if (passwordField.text != dupPasswordField.text) {
                            return (false, "Passwords must match!")
                        }
                        
                        return (true, "Success")
                    }
                } else {
                    return (false, "Please fill out all fields!")
                }
            } else {
                return (false, "Please fill out all fields!")
            }
        } else {
            return (false, "Please fill out all fields!")
        }
    }
    
    @IBAction func backgroundTapped(_ sender: AnyObject) {
        self.view.endEditing(true);
    }
    
    @IBAction func toLoginPressed(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: false)
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

