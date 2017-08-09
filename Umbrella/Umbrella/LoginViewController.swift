//
//  LoginViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 27/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UserInteractorCompleteProtocol {
    
    @IBOutlet weak var inputs: LoginView!
    weak var presenter : LoginPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        presenter = LoginPresenter()
        view.backgroundImage(named: "bkgLoginView")
        setupInputs()
    }
    
    func handleLogin() {
        
        guard let email = inputs.email.textField.text,
              let password = inputs.password.textField.text else {
    
            return
        }
        
        UserInteractor.connectUser(email: email, password: password, handler: self)
    }
    
    func completeLogin(user : UserInfo?, error : Error?) {
        
        if error != nil, let errCode = AuthErrorCode(rawValue: error!._code) {
            
            switch errCode {
            case .invalidEmail:
                inputs.email.isValidImput(false)
                
            case .wrongPassword:
                inputs.password.isValidImput(false)
                
            default:
                
                let alert = UIAlertController(title: "Alert!!", message: "Error has occurred, please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        // Mudar para tela inicial
    }

    func handleNewAccount() {

        performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    
    func handleForgotPassword() {
        
        // Ajudar usuario a recuperar a senha
    }
    
    func handleFacebookLogin() {
        
        // Logar com o facebook
    }
    
    func setupInputs() {
        
        inputs.translatesAutoresizingMaskIntoConstraints = false
        inputs.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputs.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3).isActive = true
        inputs.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -80).isActive = true
        inputs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        inputs.email.textField.delegate = self
        inputs.password.textField.delegate = self
        
        inputs.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        inputs.newAccountButton.addTarget(self, action: #selector(handleNewAccount), for: .touchUpInside)
        inputs.forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        inputs.facebookButton.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

