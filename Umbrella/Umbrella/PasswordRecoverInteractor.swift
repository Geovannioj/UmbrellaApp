//
//  PasswordInteractor.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 02/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import Firebase

class PasswordRecoverInteractor : PasswordRecoverInteractorProtocol {
    
    weak var output : PasswordRecoverInteractorOutputProtocol!
    
    /**
     Sends an email with a link to change the current user's password.
     - parameter handler: deals with errors
     */
    func sendPasswordResetEmail(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            
            if error != nil {
                self.dealWithError(error)
                return
            }
            
            self.output.completeSendPasswordResetEmail()
        })
    }

    func dealWithError(_ error : Error!) {
        
        if let errCode = AuthErrorCode(rawValue: error._code) {
            
            switch errCode {
            case .invalidEmail:
                output.fetched("Email inválido", field: .email)
                
            case .userNotFound:
                output.fetched("Email não cadastrado", field: .email)
                
            case .networkError:
                output.fetched("Verifique sua conexão com a internet", field: nil)
                
            case .invalidUserToken, .userTokenExpired:
                output.fetched("Sessão expirada", field: nil)
                
            default:
                output.fetched("Ocorreu um erro, tente novamente mais tarde", field: nil)
            }
        }
    }
}
