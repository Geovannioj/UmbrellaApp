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
            detailTextLabel?.text = "blzblzblz"//message?.text
            
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
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style : UITableViewCellStyle, reuseIdentifier : String?){
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImage)
        addSubview(timeLabel)
        
        setupProfileImage()
        setupTextLabel()
        setupDetailLabel()
        setupTimeLabel()
    }
    
    fileprivate func setupNameAndProfileImage() {
        
        if let id = message?.chatPartenerId() {
            
//            UserInteractor.getUser(withId: id, completion: {(user) in
            
                self.textLabel?.text = "Jonas de Castro"//user.nickname
//                self.profileImageView.loadImageUsingCacheWithUrlString(user.urlPhoto)
//            })
        }
    }
    
    func setupProfileImage() {
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupTextLabel() {
        
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        textLabel?.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 5).isActive = true
    }
    
    func setupDetailLabel() {
        
        detailTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        detailTextLabel?.topAnchor.constraint(equalTo: textLabel!.bottomAnchor, constant: 5).isActive = true
        detailTextLabel?.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 5).isActive = true
    }
    
    func setupTimeLabel() {
        
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) UserMessageCell has not been implemented")
    }
}

























