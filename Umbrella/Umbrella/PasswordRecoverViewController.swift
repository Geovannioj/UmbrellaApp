//
//  PasswordRecoverViewController.swift
//  Umbrella
//
//  Created by Bruno Chagas on 15/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class PasswordRecoverViewController: UIViewController, InteractorCompleteProtocol {

    @IBOutlet weak var inputs: PasswordRecoverView!
    let alert: AlertPresenter = AlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleReturn))
        view.backgroundImage(named: "bkgRegisterView")
        
        setupPasswordRecoverInputs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleRecovery() {
        let email = inputs.email.textField.text
        if ((email?.isEmpty)!) || !Validation.isValidEmailAddress(emailAddressString: email!) {
            alert.showAlert(viewController: self, title: "Ei!", message: "Coloque um e-mail valido para que possamos fazer a verificação.", confirmButton: nil, cancelButton: "OK")
            
        }
        else {
            UserInteractor.sendPasswordResetEmail(email: email!, handler: self)
            self.alert.showAlert(viewController: self, title: "Ótimo!", message: "Verifique se o e-mail chegou corretamente para você.", confirmButton: nil, cancelButton: "OK")
        }
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

    func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PasswordRecoverViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
