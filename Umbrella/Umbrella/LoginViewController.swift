//
//  LoginViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 27/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class LoginViewController: UIViewController, InteractorCompleteProtocol {
    
    @IBOutlet weak var inputs: LoginView!
    let alert: AlertPresenter = AlertPresenter()
    var indicatorView : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundImage(named: "bkgLoginView")
        
        setupInputs()
        setupIndicator()
        dismissKayboardInTapGesture()
    }
        
    func handleLogin() {
        
        guard let email = inputs.email.textField.text,
              let password = inputs.password.textField.text else {
            return
        }
        indicatorView.startAnimating()

        inputs.email.isValidImput(true)
        inputs.password.isValidImput(true)
        
        UserInteractor.connectUserOnline(email: email, password: password, handler: self)
    }
    
    func completeLogin(user : UserInfo?, error : Error?) {
        
        indicatorView.stopAnimating()
        
        if error != nil, let errCode = AuthErrorCode(rawValue: error!._code) {
            
            switch errCode {
            case .invalidEmail:
                inputs.email.isValidImput(false)
                
            case .wrongPassword:
                inputs.password.isValidImput(false)
                
            case .userDisabled:
                alert.showAlert(viewController: self, title: "Alerta!!", message: "Essa conta de usuário está desativada.", confirmButton: nil, cancelButton: "OK")
                
            default:
                alert.showAlert(viewController: self, title: "Alerta!!", message: "Ocorreu um erro, por favor tente novamente mais tarde.", confirmButton: nil, cancelButton: "OK")
            }
            return
        }
        else{
            if (Auth.auth().currentUser?.isEmailVerified)! {
                performSegue(withIdentifier: "mapSegue", sender: nil)
            }
            else {
                alert.showAlert(viewController: self, title: "Alerta!!", message: "Verifique sua conta antes de fazer o login. Deseja que enviemos outro e-mail de verificação?", confirmButton: "Sim", cancelButton: "Não", onAffirmation: {
                    UserInteractor.sendEmailVerification(handler: self)
                })
            }
        }
    }

    func handleNewAccount() {

        performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    
    func handleForgotPassword() {

        performSegue(withIdentifier: "passwordRecoverSegue", sender: nil)
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
    
    func setupIndicator() {
        
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50), type: .lineSpinFadeLoader, color: .purple, padding: 1.0)
        view.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

