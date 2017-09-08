//
//  PasswordRecoverView.swift
//  Umbrella
//
//  Created by Bruno Chagas on 15/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

@IBDesignable
class PasswordRecoverView: UIView {
    
    let closeButton : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CloseIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(r: 74, g: 74, b: 74)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let email : CampFieldView = {
        let camp = CampFieldView()
        camp.textField.placeholder = "harveymilk@stonewall.com"
        camp.titleLabel.text = "Email Cadastrado"
        camp.textField.keyboardType = UIKeyboardType.emailAddress
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()

    var recoverButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Recuperar senha", for: .normal)
        button.backgroundColor = UIColor(r: 52, g: 5, b: 82)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
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
        addSubview(recoverButton)
        
        setupCloseImageView()
        setupEmailField()
        setupRecoverButton()
    }
    
    func setupCloseImageView() {
        
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupEmailField() {
        
        email.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        email.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50).isActive = true
        email.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true
        email.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }

    func setupRecoverButton() {
        
        recoverButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50).isActive = true
        recoverButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        recoverButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        recoverButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}
