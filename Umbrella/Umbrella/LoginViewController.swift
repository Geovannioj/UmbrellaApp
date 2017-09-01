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

class LoginViewController: UIViewController {
    
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

    }
    
    func setupInputs() {
        
        inputs.translatesAutoresizingMaskIntoConstraints = false
        inputs.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputs.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3).isActive = true
        inputs.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -80).isActive = true
        inputs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        inputs.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        inputs.newAccountButton.addTarget(self, action: #selector(handleNewAccount), for: .touchUpInside)
        inputs.forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        
        inputs.facebookButton.readPermissions = ["email", "public_profile"]
        inputs.facebookButton.delegate = presenter
    }
    
    func setupIndicator() {
        
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50), type: .lineSpinFadeLoader, color: .purple, padding: 1.0)
        view.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
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



