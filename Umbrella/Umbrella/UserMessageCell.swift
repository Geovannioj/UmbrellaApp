//
//  UserMessageCell.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 09/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class UserMessageCell: UITableViewCell {

    var message : MessageEntity? {
        didSet {
            
            setupNameAndProfileImage()
            messageLabel.text = message?.text
            
            if let seconds = message?.timeDate{
                
                let timestamp = Date(timeIntervalSince1970: seconds)
                
                let date = DateFormatter()
                date.dateFormat = "hh:mm a"
                
                timeLabel.text = date.string(from: timestamp)
            }
        }
    }
    
    let profileImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "umbrella")
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameLabel : UITextField  = {
        let text = UITextField()
        text.placeholder = ""
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.purple
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let messageLabel : UITextField  = {
        let text = UITextField()
        text.placeholder = ""
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.lightGray
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style : UITableViewCellStyle, reuseIdentifier : String?){
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
                
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(messageLabel)
        addSubview(timeLabel)
        
        
        setupProfileImage()
        setupNameLabel()
        setupMessageLabel()
        setupTimeLabel()
    }
    
    fileprivate func setupNameAndProfileImage() {
        
        if let id = message?.chatPartenerId() {
            
            UserInteractor.getUser(withId: id, completion: {(user) in
            
                self.nameLabel.text = user.nickname
//                self.profileImageView.loadImageUsingCacheWithUrlString(user.urlPhoto)
            })
        }
    }
    
    func setupProfileImage() {
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3/4).isActive = true
        profileImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3/4).isActive = true
    }
    
    func setupNameLabel() {
        
        nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10).isActive = true
//        nameLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: 10).isActive = true
    }
    
    func setupMessageLabel() {
        
        messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
    }
    
    func setupTimeLabel() {
        
        timeLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) UserMessageCell has not been implemented")
    }
}

























