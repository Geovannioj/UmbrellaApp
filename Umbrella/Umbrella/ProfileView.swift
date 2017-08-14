//
//  ProfileView.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 13/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

@IBDesignable
class ProfileView: UIView {

    let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImageIcon")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let username : CampFieldView = {
        let camp = CampFieldView()
        camp.titleLabel.text = "Username"
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let email : CampFieldView = {
        let camp = CampFieldView()
        camp.titleLabel.text = "Email"
        camp.textField.keyboardType = UIKeyboardType.emailAddress
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let password : CampFieldView = {
        let camp = CampFieldView()
        camp.titleLabel.text = "Senha"
        camp.textField.isSecureTextEntry = true
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let birthDate : CampFieldView = {
        let camp = CampFieldView()
        camp.titleLabel.text = "Data de nascimento"
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let minority : CampFieldView = {
        let camp = CampFieldView()
        camp.titleLabel.text = "Minoria"
        camp.textField.isSecureTextEntry = true
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
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
        
        addSubview(profileImage)
        addSubview(username)
        addSubview(email)
        addSubview(password)
        addSubview(birthDate)
        addSubview(minority)
        
        setupProfileImageView()
        setupUsernameField()
        setupEmailField()
        setupPasswordField()
        setupBirthDateField()
        setupMinorityField()
    }

    func setupProfileImageView() {
        
        profileImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    func setupUsernameField() {
        
        username.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15).isActive = true
        username.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        username.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        username.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func setupEmailField() {
        
        email.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 15).isActive = true
        email.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        email.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        email.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func setupPasswordField() {
        
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 15).isActive = true
        password.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        password.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        password.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func setupBirthDateField(){
        
        birthDate.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 15).isActive = true
        birthDate.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        birthDate.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        birthDate.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }

    func setupMinorityField(){
        
        minority.topAnchor.constraint(equalTo: birthDate.bottomAnchor, constant: 15).isActive = true
        minority.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        minority.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        minority.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }

}
