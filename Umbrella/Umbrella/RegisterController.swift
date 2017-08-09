//
//  RegisterController.swift
//  TelasUmbrella
//
//  Created by Jonas de Castro Leitao on 06/08/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController, UserInteractorCompleteProtocol {
    
    @IBOutlet weak var inputs: RegisterView!
    weak var presenter : RegisterPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RegisterPresenter()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(handleReturn))
        view.backgroundImage(named: "bkgRegisterView")
        
        setupRegisterInputs()
    }
    
    func handleRegister(){
        
        UserInteractor.createUser(nickname: inputs.username.textField.text!,
                                  email: inputs.email.textField.text!,
                                  password: inputs.password.textField.text!,
                                  birthDate: nil,
                                  image: inputs.profileImage.image,
                                  idMinority: nil,
                                  handler: self)
    }
    
    func completeCreate(user: UserInfo?, error: Error?) {
         
        if error != nil, let errCode = AuthErrorCode(rawValue: error!._code) {
                
            switch errCode {
            case .invalidEmail:
                inputs.email.isValidImput(false)
                
            case .emailAlreadyInUse:
                
                let alert = UIAlertController(title: "Alert!!", message: "Email already in Use", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            default:
                
                let alert = UIAlertController(title: "Alert!!", message: "Error has occurred, please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        handleReturn()
    }
    
    func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupRegisterInputs() {
        
        inputs.translatesAutoresizingMaskIntoConstraints = false
        inputs.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputs.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3).isActive = true
        inputs.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        inputs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true

        
        inputs.email.textField.delegate = self
        inputs.username.textField.delegate = self
        inputs.password.textField.delegate = self
        
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
        
        textField.resignFirstResponder()
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






















