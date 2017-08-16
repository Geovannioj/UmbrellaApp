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
    
    let email : CampFieldView = {
        let camp = CampFieldView()
        camp.textField.placeholder = "harveymilk@stonewall.com"
        camp.titleLabel.text = "Email Cadastrado"
        camp.invalidMessageLabel.text = "Ops! Email invalido"
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
        
        addSubview(email)
        addSubview(recoverButton)
        
        setupEmailField()
        setupRecoverButton()
    }
    
    func setupEmailField() {
        
        email.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        email.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        email.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        email.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }

    func setupRecoverButton() {
        
        recoverButton.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 90).isActive = true
        recoverButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        recoverButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 3/4).isActive = true
        recoverButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}
