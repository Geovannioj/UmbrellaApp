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
    
    let closeButton : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CloseIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let email : CampFieldView = {
        let camp = CampFieldView()
        camp.id = 0
        camp.textField.font = UIFont(name: ".SFUIText-Light", size: 14)
        camp.textField.placeholder = "Email"
        camp.iconImage.image = UIImage(named: "emailIcon")
        camp.textField.keyboardType = UIKeyboardType.emailAddress
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let password : CampFieldView = {
        let camp = CampFieldView()
        camp.id = 1
        camp.textField.font = UIFont(name: ".SFUIText-Light", size: 14)
        camp.textField.placeholder = "Senha"
        camp.iconImage.image = UIImage(named: "passwordIcon")
        camp.textField.isSecureTextEntry = true
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    var loginButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: ".SFUIDisplay", size: 16)
        button.setTitle("Entrar", for: .normal)
        button.backgroundColor = UmbrellaColors.darkPurple.color
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var forgotPasswordButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        button.setTitle("Esqueci a senha", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var newAccountButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        button.setTitle("Criar uma nova conta", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var facebookButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Entrar com Facebook", for: .normal)
        button.backgroundColor = UIColor(r: 0, g: 124, b: 204)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
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
        
        addSubview(closeButton)
        addSubview(email)
        addSubview(password)
        addSubview(loginButton)
        addSubview(forgotPasswordButton)
        addSubview(newAccountButton)
        addSubview(facebookButton)
        
        setupCloseImageView()
        setupEmailField()
        setupPasswordField()
        setupLoginButton()
        setupForgotPasswordButton()
        setupNewAccountButton()
        setupFacebookButton()
    }
    
    func setupCloseImageView() {
        
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor).isActive = true
    }
    
    func setupEmailField() {
        
        email.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        email.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -70).isActive = true
        email.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true
        email.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        email.textField.delegate = self
    }
    
    func setupPasswordField() {
        
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10).isActive = true
        password.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        password.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true
        password.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        password.textField.delegate = self
    }
    
    func setupLoginButton() {
        
        loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupForgotPasswordButton() {
        
        forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40).isActive = true
        forgotPasswordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func setupNewAccountButton() {
        
        newAccountButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 20).isActive = true
        newAccountButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func setupFacebookButton() {
        
        facebookButton.topAnchor.constraint(equalTo: newAccountButton.bottomAnchor, constant: 30).isActive = true
        facebookButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        facebookButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 3/5).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
 
}

extension LoginView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
