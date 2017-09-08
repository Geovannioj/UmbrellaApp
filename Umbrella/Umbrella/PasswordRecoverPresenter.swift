//
//  PasswordPresenter.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 02/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class PasswordRecoverPresenter : PasswordRecoverPresenterProtocol {
    
    weak var view : PasswordRecoverViewProtocol?
    var interactor : PasswordRecoverInteractorProtocol!
    var router : PasswordRecoverRouterProtocol!
    
    func handlePasswordRecover(email : String?) {
        
        if email == nil {
            
        } else if email!.isEmpty {
            
            view?.showFieldMessage(.email, message: "* campo obrigatório", isValid: false)
            
        } else if !Validation.isValidEmailAddress(emailAddressString: email!) {
            
            view?.showFieldMessage(.email, message: "e-mail inválido", isValid: false)
            
        } else {
            
            view?.indicatorView.startAnimating()
            interactor.sendPasswordResetEmail(email: email!)
        }
    }
    
    func handleReturn() {
        
        router.performLoginControler()
    }
}

extension PasswordRecoverPresenter : PasswordRecoverInteractorOutputProtocol {
    
    func completeSendPasswordResetEmail() {
        
        view?.indicatorView.stopAnimating()

        AlertPresenter().showAlert(viewController: view as! UIViewController, title: "Ótimo!", message: "Verifique se o e-mail chegou corretamente para você.", confirmButton: nil, cancelButton: "OK") {
            
            self.router.performLoginControler()
        }
    }
    
    func fetched(_ error : String, field : FieldEnum?) {
        
        view?.indicatorView.stopAnimating()
        
        if field != nil {
            
            view?.showFieldMessage(field!, message: error, isValid: false)
        } else if let viewController = view as? UIViewController {
            
            AlertPresenter().showAlert(viewController: viewController, title: "Alerta!!", message: error, confirmButton: nil, cancelButton: "Ok")
        }
    }
    
}
