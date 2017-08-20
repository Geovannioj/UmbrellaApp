//
//  RegisterView.swift
//  TelasUmbrella
//
//  Created by Jonas de Castro Leitao on 06/08/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit

@IBDesignable
class RegisterView: UIView {
    
    let closeButton : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CloseIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(r: 74, g: 74, b: 74)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImageIcon")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let username : CampFieldView = {
        let camp = CampFieldView()
        camp.textField.placeholder = "Somente letras e números"
        camp.titleLabel.text = "Username"
        camp.invalidMessageLabel.text = "Ops! username não válido."
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let email : CampFieldView = {
        let camp = CampFieldView()
        camp.textField.placeholder = "Email válido"
        camp.titleLabel.text = "Email"
        camp.invalidMessageLabel.text = "Ops! email não válido."
        camp.textField.keyboardType = UIKeyboardType.emailAddress
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let password : CampFieldView = {
        let camp = CampFieldView()
        camp.textField.placeholder = "Minimo de 6 caracteres"
        camp.titleLabel.text = "Senha"
        camp.invalidMessageLabel.text = "Ops! senha não válido."
        camp.textField.isSecureTextEntry = true
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 52, g: 5, b: 82)
        button.setTitle("Registrar", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
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
        addSubview(profileImage)
        addSubview(username)
        addSubview(email)
        addSubview(password)
        addSubview(registerButton)
        
        setupCloseImageView()
        setupProfileImageView()
        setupUsernameField()
        setupEmailField()
        setupPasswordField()
        setupRegisterButton()
    }
    
    func setupCloseImageView() {
        
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupProfileImageView() {
        
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    func setupUsernameField() {
        
        username.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        username.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        username.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true
        username.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func setupEmailField() {
        
        email.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        email.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 20).isActive = true
        email.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true
        email.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func setupPasswordField() {
     
        password.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 20).isActive = true
        password.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true
        password.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }

    func setupRegisterButton() {
        
        registerButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}






