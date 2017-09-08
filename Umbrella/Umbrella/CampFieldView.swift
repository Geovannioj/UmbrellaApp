//
//  CampFieldView.swift
//  TelasUmbrella
//
//  Created by Jonas de Castro Leitao on 06/08/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit

class CampFieldView: UIView {
    
    var campView: UIView = {
        let camp = UIView()
        camp.backgroundColor = UIColor.white
        camp.layer.borderColor = UIColor.lightGray.cgColor
        camp.layer.borderWidth = 1
        camp.layer.cornerRadius = 5
        camp.layer.masksToBounds = true
        camp.translatesAutoresizingMaskIntoConstraints = false
        return camp
    }()
    
    let textField : UITextField  = {
        let text = UITextField()
        text.placeholder = ""
        text.autocapitalizationType = .none
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.black
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let titleLabel : UILabel  = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImage : UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.isUserInteractionEnabled = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    var validated = false
    var id : Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()   
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func isValidImput(_ option : Bool) {

        validated = option
        campView.layer.borderColor = option ? UIColor.green.cgColor : UIColor.red.cgColor
        messageLabel.textColor = option ? UIColor.green : UIColor.red
    }
    
    func nextCamp() {
        
        guard let fromId = self.id else {
            self.textField.resignFirstResponder()
            return
        }
        
        if let camps = superview?.subviews.filter({$0 is CampFieldView}) {
         
            for camp in camps as! [CampFieldView] {
            
                if let toId = camp.id, toId - fromId == 1, !camp.validated {
                    
                    camp.textField.becomeFirstResponder()
                    return
                }
            }
        }
        
        self.textField.resignFirstResponder()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

}

extension CampFieldView {
    
    func setupView() {
        
        addSubview(campView)
        addSubview(iconImage)
        addSubview(textField)
        addSubview(titleLabel)
        addSubview(messageLabel)
        
        setupCampView()
        setupIconImage()
        setupTextField()
        setupTitleLabel()
        setupInvalidMessageLabel()
    }
    
    func setupCampView() {
        
        campView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        campView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        campView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        campView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor).isActive = true
    }
    
    func setupIconImage() {
        
        iconImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: campView.centerYAnchor).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupTextField() {
        
        textField.leftAnchor.constraint(equalTo: iconImage.rightAnchor, constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: campView.rightAnchor, constant: -10).isActive = true
        textField.centerYAnchor.constraint(equalTo: campView.centerYAnchor).isActive = true
    }
    
    func setupTitleLabel(){
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    func setupInvalidMessageLabel() {
        
        messageLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
