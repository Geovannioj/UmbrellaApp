//
//  RegisterPresenter.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 07/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class RegisterPresenter : NSObject, RegisterPresenterProtocol {
    
    weak var view : RegisterViewProtocol?
    var interactor : RegisterInteractorProtocol!
    var router : RegisterRouterProtocol!
    
    func createUser(nickname: String?, email : String?, password: String?, image : UIImage?) {
        
        var valid = true
        
        isValidField(nickname, field: .nickname, check: &valid)
        isValidField(email, field: .email, check: &valid)
        isValidField(password, field: .password, check: &valid)
        
        if valid {
         
            view?.indicatorView.startAnimating()
            interactor.createUser(nickname: nickname!, email: email!, password: password!, image: image)
        }
    }
    
    func isValidField(_ text : String?, field : FieldEnum, check : inout Bool) {
        
        if  text == nil { // TRATAR
            check = false
        }
        
        if text!.isEmpty {
            
            view?.showFieldMessage(field, message: "* campo obrigatório", isValid: false)
            check = false
        }
    }
    
    func validateField(_ field : FieldEnum, input : String?) {
        
        if input == nil || input!.isEmpty {
            return
        }
        
        switch field {
        case .nickname:
            
            if input!.characters.count >= 3 {
                view?.showFieldMessage(field, message: "Nickname válido", isValid: true)
            } else {
                view?.showFieldMessage(field, message: "Nickname precisa ter no minimo 3 caracteres", isValid: false)
            }
        case .email:
            
            if Validation.isValidEmailAddress(emailAddressString: input!) {
            
                view?.showFieldMessage(field, message: "Email válido", isValid: true)
            } else {
                view?.showFieldMessage(field, message: "Email inválido", isValid: false)
            }
            
        case .password: // Proteção da senha // Mostrar senha
            
            if input!.characters.count >= 6 {
                view?.showFieldMessage(field, message: "Senha válida", isValid: true)
            } else {
                view?.showFieldMessage(field, message: "Senha precisa ter no minimo 6 caracteres", isValid: false)
            }
        }
    }
    
    func handleSelectProfileImage() {
        
        ImagePickerRouter().showSelectOptions(view as! UIViewController, presenter: self)
    }
    
    func handleReturn() {

        router.performLoginControler()
    }
}

extension RegisterPresenter : RegisterInteractorOutputProtocol {
    
    func completeCreate() {
        
        view?.indicatorView.stopAnimating()
        
        interactor.sendEmailVerification()
        handleReturn()
    }
    
    func fetched(_ error : String, field : FieldEnum?){
        
        view?.indicatorView.stopAnimating()
        
        if field != nil {
            
            view?.showFieldMessage(field!, message: error, isValid: false)
        } else if let viewController = view as? UIViewController {
            
            AlertPresenter().showAlert(viewController: viewController, title: "Alerta!!", message: error, confirmButton: nil, cancelButton: "Ok")
        }
    }
}

extension RegisterPresenter : ImagePickerRouterProtocol {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
           
            view?.changedProfileImage(editedImage)
        
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            view?.changedProfileImage(originalImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        picker.dismiss(animated: true, completion: nil)
    }
    
    func removePicture() {
        view?.changedProfileImage(nil)
    }
    
}
