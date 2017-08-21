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
        let view = UIImageView()
        view.layer.contents = UIImage(named: "profileImageIcon")?.cgImage
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        let button = UIButton(type: .system)
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
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
    }
    
    func setupAlterarFotoButton() {
        alterarFotoButton.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 5).isActive = true
        alterarFotoButton.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
    }    
}

