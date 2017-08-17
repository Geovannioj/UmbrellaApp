//
//  ChatCollectionViewCell.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 10/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    let textView : UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = UIColor.clear
        view.isEditable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bubbleView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "BubbleImage")?.withRenderingMode(.alwaysTemplate)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    var bubbleRightAnchor : NSLayoutConstraint?
    var bubbleLeftAnchor : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        addSubview(bubbleView)
        addSubview(textView)
        
        setupBubbleView()
        setupTextView()
    }
    
    func setupStyleForUser(){
        
        bubbleRightAnchor?.isActive = true
        bubbleLeftAnchor?.isActive = false
        bubbleView.transform = CGAffineTransform(scaleX: 1, y: 1)
        bubbleView.tintColor = UIColor(r: 80, g: 62, b: 86)
        textView.textColor =  UIColor.white
    }
    
    func setupStyleForPartner(){
        
        bubbleRightAnchor?.isActive = false
        bubbleLeftAnchor?.isActive = true
        bubbleView.transform = CGAffineTransform(scaleX: -1, y: 1)
        bubbleView.tintColor = UIColor.white
        textView.textColor =  UIColor.black
    }
    
    func setupBubbleView() {
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        bubbleRightAnchor?.isActive = true
        
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)

        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func setupTextView() {

        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -10).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
