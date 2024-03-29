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
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.purple
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let profileImage : UIImageView = {
        let icon = UIImageView()
        icon.layer.contents = UIImage(named: "profileImageIcon")?.cgImage
        icon.clipsToBounds = true
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
    
    let bottomLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.purple
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(bottomLine)
    
        setupProfileImage()
        setupTextField()
        setupBackButton()
        setupBottomLine()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    func setupProfileImage() {
        
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupTextField() {
        
        nameField.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 3).isActive = true
        nameField.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
    }
    
    func setupBackButton() {
        
        backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30)
        backButton.widthAnchor.constraint(equalToConstant: 30)
    }
    
    func setupBottomLine() {
        
        bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

}
