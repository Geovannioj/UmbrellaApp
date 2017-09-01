//
//  RegisterController.swift
//  TelasUmbrella
//
//  Created by Jonas de Castro Leitao on 06/08/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var inputs: RegisterView!
    var presenter : RegisterPresenterProtocol!
    var indicatorView : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundImage(named: "bkgRegisterView")
        
        setupIndicator()
        setupRegisterInputs()
        dismissKayboardInTapGesture()
    }
    
    func handleRegister(){
        
        presenter.createUser(nickname: inputs.username.textField.text, email: inputs.email.textField.text, password: inputs.password.textField.text, image: inputs.profileImage.image)
    }
    
    func handleReturn() {
        
        presenter.handleReturn()
    }
    
    func handleSelectProfileImage() {
        
        presenter.handleSelectProfileImage()
    }
    
    func setupRegisterInputs() {
        
        inputs.translatesAutoresizingMaskIntoConstraints = false
        inputs.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inputs.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        inputs.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        inputs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        inputs.registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        inputs.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        inputs.profileImage.isUserInteractionEnabled = true
        
        inputs.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleReturn)))
        inputs.closeButton.isUserInteractionEnabled = true
        
        inputs.email.textField.delegate = self
        inputs.username.textField.delegate = self
        inputs.password.textField.delegate = self
    }
    
    func setupIndicator() {
        
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50), type: .lineSpinFadeLoader, color: .purple, padding: 1.0)
        view.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
}

extension RegisterViewController : RegisterViewProtocol {
    
    func changedProfileImage( _ image : UIImage?) {
        
        inputs.profileImage.image = image
    }
    
    func showFieldMessage(_ field : FieldEnum, message : String, isValid : Bool) {
        
        switch field {
        case .nickname:
            inputs.username.isValidImput(isValid)
            inputs.username.messageLabel.text = message
            
        case .email:
            inputs.email.isValidImput(isValid)
            inputs.email.messageLabel.text = message
            
        case .password:
            inputs.password.isValidImput(isValid)
            inputs.password.messageLabel.text = message
        }
    }
    
}

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
                
        switch textField {
        case inputs.username.textField:

            presenter.validateField(.nickname, input: textField.text)
        case inputs.email.textField:
            
            presenter.validateField(.email, input: textField.text)
        case inputs.password.textField:
            
            presenter.validateField(.password, input: textField.text)
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.superview is CampFieldView {
            (textField.superview as! CampFieldView).nextCamp()
        }
        
        return true
    }
}





















