//
//  TitleView.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 16/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class NavigationView: UIView {

    let nameField : UILabel  = {
        let text = UILabel()
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.textColor = UIColor.purple
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let profileImage : UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "umbrella")
        icon.contentMode = .scaleAspectFill
        icon.isUserInteractionEnabled = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let backButton : UIButton = {
       let button = UIButton(type: .system)
        button.setImage(UIImage(named: "BackButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        self.backgroundColor = UIColor.clear
                
        addSubview(profileImage)
        addSubview(nameField)
        addSubview(backButton)
    
        setupProfileImage()
        setupTextField()
        setupBackButton()
    }
    
    func setupProfileImage() {
        
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 34).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    func setupTextField() {
        
        nameField.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 5).isActive = true
        nameField.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
    }
    
    func setupBackButton() {
        
        backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
    }

}
