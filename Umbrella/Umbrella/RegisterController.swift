//
//  RegisterController.swift
//  TelasUmbrella
//
//  Created by Jonas de Castro Leitao on 06/08/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class RegisterController: UIViewController, InteractorCompleteProtocol {
    
    @IBOutlet weak var inputs: RegisterView!
    weak var presenter : RegisterPresenter?
    let alert: AlertPresenter = AlertPresenter()
    var indicatorView : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RegisterPresenter()
        
        dismissKayboardInTapGesture()
        view.backgroundImage(named: "bkgRegisterView")
        
        setupIndicator()
        setupRegisterInputs()
    }
    
    func handleRegister(){
        
        indicatorView.startAnimating()
        UserInteractor.createUser(nickname: inputs.username.textField.text!,
                                  email: inputs.email.textField.text!,
                                  password: inputs.password.textField.text!,
                                  image: inputs.profileImage.image,
                                  handler: self)
        
    }
    
    func completeCreate(user: UserInfo?, error: Error?) {
        
        indicatorView.stopAnimating()
        
        if error != nil, let errCode = AuthErrorCode(rawValue: error!._code) {
                
            switch errCode {
            case .userNotFound:
                alert.showAlert(viewController: self, title: "Alerta!!", message: "Usuario não cadastrado", confirmButton: nil, cancelButton: "OK")

            case .invalidEmail:
                inputs.email.isValidImput(false)
                
            case .emailAlreadyInUse:
                
                alert.showAlert(viewController: self, title: "Alerta!!", message: "Este e-mail já está sendo usado.", confirmButton: nil, cancelButton: "OK")
                
            case .weakPassword:
                
                alert.showAlert(viewController: self, title: "Alerta!!", message: "A senha deve possuir pelo menos 6 caracteres.", confirmButton: nil, cancelButton: "OK")
                
            default:
                
                alert.showAlert(viewController: self, title: "Alerta!!", message: "Ocorreu um erro, por favor tente novamente mais tarde.", confirmButton: nil, cancelButton: "OK")
            }
            return
        } else {
            
            UserInteractor.connectUserOnline(email: inputs.email.textField.text!, password: inputs.password.textField.text!, handler: self)
            UserInteractor.sendEmailVerification(handler: self)
            handleReturn()
        }
    }
    
    func completeLogin(user: UserInfo?, error: Error?) {
        // Tratar erros
    }
    
    func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupRegisterInputs() {
        
        inputs.translatesAutoresizingMaskIntoConstraints = false
        inputs.translatesAutoresizingMaskIntoConstraints = false
        inputs.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inputs.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        inputs.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        inputs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        inputs.email.textField.delegate = self
        inputs.username.textField.delegate = self
        inputs.password.textField.delegate = self
        
        inputs.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleReturn)))
        inputs.closeButton.isUserInteractionEnabled = true
        
        inputs.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        inputs.profileImage.isUserInteractionEnabled = true
        
        inputs.registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        inputs.registerButton.isEnabled = false
    }
    
    func setupIndicator() {
        
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50), type: .lineSpinFadeLoader, color: .purple, padding: 1.0)
        view.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
}

extension RegisterController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case inputs.username.textField:
            
            inputs.username.isValidImput(!(textField.text == ""))
        case inputs.email.textField:
            
            inputs.email.isValidImput(!(textField.text == ""))
        case inputs.password.textField:
            
            if textField.text != nil {
                inputs.password.isValidImput(textField.text!.characters.count >= 6)
            } else {
                inputs.password.isValidImput(false)
            }
        default:
            break
        }
        
        if inputs.username.validated && inputs.email.validated && inputs.password.validated {
            inputs.registerButton.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.superview is CampFieldView {
            (textField.superview as! CampFieldView).nextCamp()
        }
        
        return true
    }
}


extension RegisterController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImage() {
        
        let chooseAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        chooseAction.addAction(UIAlertAction(title: "Tirar Foto", style: .default, handler:{_ in
            self.handlePresentPicker(type: .camera)
        }))
        
        chooseAction.addAction(UIAlertAction(title: "Escolher Foto", style: .default, handler:{_ in
            self.handlePresentPicker(type: .photoLibrary)
        }))
        
        chooseAction.addAction(UIAlertAction(title: "Remover Foto", style: .destructive, handler:{_ in
            self.inputs.profileImage.image = nil
        }))
        
        chooseAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(chooseAction, animated: true, completion: nil)
    }
    
    func handlePresentPicker(type : UIImagePickerControllerSourceType) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(type) {
            picker.sourceType = type
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            inputs.profileImage.image = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            inputs.profileImage.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}






















