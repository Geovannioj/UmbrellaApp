//
//  LoginViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 27/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var presenter : LoginPresenterProtocol!
    var indicatorView : NVActivityIndicatorView!
    @IBOutlet weak var inputs: LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundImage(named: "bkgLoginView")
        
        setupInputs()
        setupIndicator()
        dismissKayboardInTapGesture()
    }
        
    func handleLogin() {
        
        presenter.handleLogin(email: inputs.email.textField.text, password: inputs.password.textField.text)
    }
    
    func handleNewAccount() {
        
        presenter.handleNewAccount()
    }
    
    func handleForgotPassword() {

        presenter.handleForgotPassword()
    }
    
    func handleFacebookLogin() {
        
        presenter.handleFacebookLogin()
    }
    
    func setupInputs() {
        
        inputs.translatesAutoresizingMaskIntoConstraints = false
        inputs.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputs.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        inputs.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        inputs.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        inputs.email.textField.delegate = self
        inputs.password.textField.delegate = self
        
        inputs.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleReturn)))
        inputs.closeButton.isUserInteractionEnabled = true
        
        inputs.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        inputs.newAccountButton.addTarget(self, action: #selector(handleNewAccount), for: .touchUpInside)
        inputs.forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        inputs.facebookButton.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
    }
    
    func setupIndicator() {
        
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50), type: .lineSpinFadeLoader, color: .purple, padding: 1.0)
        view.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
}

enum FieldEnum : Int {
    case nickname
    case email
    case password
}

extension LoginViewController : LoginViewProtocol {
    
    func showFieldMessage(_ field : FieldEnum, message : String, isValid : Bool){
    
        switch field {
        case .email:
            inputs.email.isValidImput(isValid)
            inputs.email.messageLabel.text = message
            
        case .password:
            inputs.password.isValidImput(isValid)
            inputs.password.messageLabel.text = message
            
        default:
            break
        }
    }
}



