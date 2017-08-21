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
    
    let username : UILabel = {
        let view = UILabel()
        view.text = "Username"
        view.textColor = UIColor(r: 74, g: 3, b: 103)
        view.font = UIFont.systemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let alterarFotoButton : UIButton = {
        let button = UIButton()
        button.setTitle("Alterar Foto", for: .normal)
        button.setTitleColor(UIColor(r: 170, g: 10, b: 234), for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
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
        
        addSubview(profileImage)
        addSubview(username)
        addSubview(alterarFotoButton)
        
        setupProfileImageView()
        setupUsername()
        setupAlterarFotoButton()
//        setupNameLineStack()
//        setupLabelsStack()
    }
    
    func setupProfileImageView() {
        
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    func setupUsername() {
        username.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        username.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        //username.widthAnchor.constraint(equalToConstant: 90).isActive = true
        //username.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
    }
    
    func setupAlterarFotoButton() {
        alterarFotoButton.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 5).isActive = true
        alterarFotoButton.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        //alterarFotoButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        //alterarFotoButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
    }
    
    
//    func setupNameLineStack() {
//        
//        let stackView = UIStackView(arrangedSubviews: [username, lineView])
//        stackView.axis = .vertical
//        stackView.spacing = 10
//        stackView.distribution = .fillProportionally
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        addSubview(stackView)
//        
//        stackView.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 5).isActive = true
//        stackView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 30).isActive = true
//        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
//        
//        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//    }
//    
//    func setupLabelsStack(){
//        
//        let stackView = UIStackView(arrangedSubviews: [email, password, birthDate, minority])
//        stackView.axis = .vertical
//        stackView.spacing = 50
//        stackView.distribution = .fillProportionally
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        addSubview(stackView)
//        
//        stackView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 10).isActive = true
//        stackView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 50).isActive = true
//    }
    
}

