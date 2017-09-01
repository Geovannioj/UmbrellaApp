//
//  LoginView.swift
//  TelasUmbrella
//
//  Created by Jonas de Castro Leitao on 05/08/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit
import FBSDKLoginKit

@IBDesignable
class LoginView: UIView {
    
    let email : CampFieldView = {
        let camp = CampFieldView()
        camp.id = 0
        camp.textField.placeholder = "Email"
        camp.iconImage.image = UIImage(named: "emailIcon")
        camp.textField.keyboardType = UIKeyboardType.emailAddress
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let password : CampFieldView = {
        let camp = CampFieldView()
        camp.id = 1
        camp.textField.placeholder = "Senha"
        camp.iconImage.image = UIImage(named: "passwordIcon")
        camp.textField.isSecureTextEntry = true
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    var loginButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Entrar", for: .normal)
        button.backgroundColor = UIColor(r: 52, g: 5, b: 82)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var forgotPasswordButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Esqueci a senha", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var newAccountButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Criar uma nova conta", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var facebookButton : FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        
        self.backgroundColor = UIColor.clear
        
        addSubview(email)
        addSubview(password)
        addSubview(loginButton)
        addSubview(forgotPasswordButton)
        addSubview(newAccountButton)
        addSubview(facebookButton)
        
        setupEmailField()
        setupPasswordField()
        setupLoginButton()
        setupForgotPasswordButton()
        setupNewAccountButton()
        setupFacebookButton()
    }
    
    func setupEmailField() {
        
        email.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        email.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        email.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        email.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        email.textField.delegate = self
    }
    
    func setupPasswordField() {
        
        password.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 20).isActive = true
        password.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        password.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        password.textField.delegate = self
    }
    
    func setupLoginButton() {
        
        loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupForgotPasswordButton() {
        
        forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40).isActive = true
        forgotPasswordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func setupNewAccountButton() {
        
        newAccountButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 20).isActive = true
        newAccountButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/4).isActive = true
        newAccountButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func setupFacebookButton() {
        
        facebookButton.topAnchor.constraint(equalTo: newAccountButton.bottomAnchor, constant: 20).isActive = true
        facebookButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        facebookButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 3/4).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
 
}

extension LoginView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
