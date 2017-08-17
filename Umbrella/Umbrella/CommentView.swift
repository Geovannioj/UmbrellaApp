//
//  commentView.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 17/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class CommentView: UIView {

    let textView : UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sendCommentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enviar", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        setupView()
    }
    
    func setupView() {
        
        backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        
        addSubview(textView)
        addSubview(sendCommentButton)
        
        setupTextView()
        setupSendCommentButton()
    }
    
    func setupTextView() {
        
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        textView.rightAnchor.constraint(equalTo: sendCommentButton.leftAnchor, constant: -10).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
    }
    
    func setupSendCommentButton() {
        
        sendCommentButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        sendCommentButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sendCommentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sendCommentButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
