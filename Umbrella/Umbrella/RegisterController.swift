//
//  RegisterController.swift
//  TelasUmbrella
//
//  Created by Jonas de Castro Leitao on 06/08/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController, InteractorCompleteProtocol {
    
    @IBOutlet weak var inputs: RegisterView!
    weak var presenter : RegisterPresenter?
    let alert: AlertPresenter = AlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RegisterPresenter()
        
        dismissKayboardInTapGesture()
        view.backgroundImage(named: "bkgRegisterView")
        
        setupRegisterInputs()
    }
    
    func handleRegister(){
        
        UserInteractor.createUser(nickname: inputs.username.textField.text!,
                                  email: inputs.email.textField.text!,
                                  password: inputs.password.textField.text!,
                                  birthDate: nil,
                                  idMinority: nil,
                                  image: inputs.profileImage.image!,
                                  handler: self)
        
    }
    
    func completeCreate(user: UserInfo?, error: Error?) {
         
        if error != nil, let errCode = AuthErrorCode(rawValue: error!._code) {
                
            switch errCode {
            case .invalidEmail:
                inputs.email.isValidImput(false)
                
            case .emailAlreadyInUse:
                
                alert.showAlert(viewController: self, title: "Alerta!!", message: "Este e-mail já está sendo usado.", confirmButton: nil, cancelButton: "OK")
                
            case .weakPassword:
                
                alert.showAlert(viewController: self, title: "Alerta!!", message: "Cadastre uma senha de pelo menos 6 caracteres.", confirmButton: nil, cancelButton: "OK")
                
            default:
                
                alert.showAlert(viewController: self, title: "Alerta!!", message: "Ocorreu um erro, por favor tente novamente mais tarde.", confirmButton: nil, cancelButton: "OK")
            }
            return
        }
        else {
            UserInteractor.connectUserOnline(email: inputs.email.textField.text!, password: inputs.password.textField.text!, handler: self)
            UserInteractor.sendEmailVerification(handler: self)
            handleReturn()
        }
        
    }
    
    func completeLogin(user: UserInfo?, error: Error?) {
        
        
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
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if selectedImage != nil {
            
            inputs.profileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}






















