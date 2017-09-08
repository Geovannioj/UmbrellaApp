//
//  PasswordRecoverViewController.swift
//  Umbrella
//
//  Created by Bruno Chagas on 15/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class PasswordRecoverViewController: UIViewController {

    @IBOutlet weak var inputs: PasswordRecoverView!
    var presenter : PasswordRecoverPresenterProtocol!
    var indicatorView : NVActivityIndicatorView!
    
    let alert: AlertPresenter = AlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundImage(named: "bkgRegisterView")
        
        dismissKayboardInTapGesture()
        setupIndicator()
        setupPasswordRecoverInputs()
    }

    func handleRecovery() {
        
        presenter.handlePasswordRecover(email: inputs.email.textField.text)
    }
        
    func handleReturn() {

        presenter.handleReturn()
    }
    
    func setupPasswordRecoverInputs() {
        
        inputs.translatesAutoresizingMaskIntoConstraints = false
        inputs.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inputs.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        inputs.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        inputs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        inputs.email.textField.delegate = self
       
        inputs.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleReturn)))
        inputs.closeButton.isUserInteractionEnabled = true
        
        inputs.recoverButton.addTarget(self, action: #selector(handleRecovery), for: .touchUpInside)
    }

    func setupIndicator() {
        
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50), type: .lineSpinFadeLoader, color: .purple, padding: 1.0)
        view.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}

extension PasswordRecoverViewController : PasswordRecoverViewProtocol {
    
    func showFieldMessage(_ field : FieldEnum, message : String, isValid : Bool) {
        
        switch field {
        case .email:
            inputs.email.isValidImput(isValid)
            inputs.email.messageLabel.text = message
        default : break
        }
    }
    
}

extension PasswordRecoverViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
