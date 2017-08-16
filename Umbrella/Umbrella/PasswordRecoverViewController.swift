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

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleReturn))
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
        inputs.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputs.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        inputs.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3).isActive = true
        inputs.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        inputs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
        inputs.email.textField.delegate = self
       
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
