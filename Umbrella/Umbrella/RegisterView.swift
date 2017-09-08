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
        let view = UIImageView()
        view.layer.contents = UIImage(named: "profileImageIcon")?.cgImage
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let changedImageButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("selecionar", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let username : CampFieldView = {
        let camp = CampFieldView()
        camp.id = 0
        camp.textField.autocapitalizationType = .sentences
        camp.titleLabel.text = "Username"
        camp.textField.placeholder = "Somente letras e números"
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let email : CampFieldView = {
        let camp = CampFieldView()
        camp.id = 1
        camp.titleLabel.text = "Email"
        camp.textField.placeholder = "Email válido"
        camp.textField.keyboardType = UIKeyboardType.emailAddress
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let password : CampFieldView = {
        let camp = CampFieldView()
        camp.id = 2
        camp.titleLabel.text = "Senha"
        camp.textField.placeholder = "Minimo de 6 caracteres"
        camp.textField.isSecureTextEntry = true
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 52, g: 5, b: 82)
        button.setTitle("Registrar", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        registerButton.layer.cornerRadius = 5
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
}

extension RegisterView {
    
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
        addSubview(changedImageButton)
        addSubview(username)
        addSubview(email)
        addSubview(password)
        addSubview(registerButton)
        
        setupCloseImageView()
        setupProfileImageView()
        setupChangedImageButton()
        setupUsernameField()
        setupEmailField()
        setupPasswordField()
        setupRegisterButton()
    }
    
    func setupCloseImageView() {
        
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor).isActive = true
    }
    
    func setupProfileImageView() {
        
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
    }
    
    func setupChangedImageButton() {
        
        changedImageButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        changedImageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        changedImageButton.widthAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        changedImageButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
    func setupUsernameField() {
        
        username.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        username.topAnchor.constraint(equalTo: changedImageButton.bottomAnchor, constant: 20).isActive = true
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
