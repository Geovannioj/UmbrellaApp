//
//  inputChatView.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 10/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class ChatInputView: UIView {

    var campView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()

    let textField : UITextField  = {
        let text = UITextField()
        text.placeholder = "Mensagem"
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.black
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let fileIcon : UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "FileIcon")
        icon.contentMode = .scaleAspectFill
        icon.isUserInteractionEnabled = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        self.backgroundColor = UIColor.white
        
        addSubview(campView)
        addSubview(fileIcon)
        addSubview(textField)
        

        setupCampView()
        setupFileIcon()
        setupTextField()
    }
    
    func setupCampView() {
        
        campView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        campView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        campView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        campView.leftAnchor.constraint(equalTo: fileIcon.rightAnchor, constant: 20).isActive = true
    }
    
    
    func setupTextField() {
        
        textField.centerYAnchor.constraint(equalTo: campView.centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: campView.leftAnchor, constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: campView.rightAnchor, constant: -10).isActive = true
    }
    
    func setupFileIcon() {
        
        fileIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        fileIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        fileIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        fileIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
}
