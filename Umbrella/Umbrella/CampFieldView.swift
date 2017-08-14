//
//  CampFieldView.swift
//  TelasUmbrella
//
//  Created by Jonas de Castro Leitao on 06/08/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit

class CampFieldView: UIView {
    
    let campView: UIView = {
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
    
    let invalidMessageLabel : UILabel = {
        let label = UILabel()
        label.text = "Ops!"
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.red
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
        invalidMessageLabel.isHidden = option
        campView.layer.borderColor = option ? UIColor.lightGray.cgColor : UIColor.red.cgColor
    }
    
    func setupView() {
        
        addSubview(campView)
        addSubview(iconImage)
        addSubview(textField)
        addSubview(titleLabel)
        addSubview(invalidMessageLabel)
        
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
        campView.bottomAnchor.constraint(equalTo: invalidMessageLabel.topAnchor).isActive = true
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
        
        invalidMessageLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        invalidMessageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

}
