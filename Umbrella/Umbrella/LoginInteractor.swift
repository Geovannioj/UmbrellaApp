//
//  LoginInteractor.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 29/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Firebase

class LoginInteractor : LoginInteractorProtocol {
    
    weak var output : LoginInteractorOutputProtocol!
    
    /**
     Connects an user to the firebase
     - parameter email: user's email
     - parameter password: user's password
     */
    func connectUserOnline(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                self.dealWithError(error)
                return
            }
            
            if let currentUser = user {
            
                self.output.completeLogin(isVerified: currentUser.isEmailVerified)
            } else {
                
                self.dealWithError(NSError(domain: "", code: AuthErrorCode.sessionExpired.rawValue, userInfo: nil))
            }
        })
    }
    
    func connectFacebookUser(accessToken : String, completion: @escaping (_ id : String) -> ()){
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            
            if error != nil {
                self.dealWithError(error)
                return
            }
            
            if let id = user?.uid {
                completion(id)
            }
        })
    }
    
    func createDatabaseUser( _ user : UserEntity) {
        
        let userRef = Database.database().reference().child("user").child(user.id)
        userRef.setValue(user.toAnyObject())

        self.output.completeLogin(isVerified: true)
    }
    
    func checkUserExists(id : String, completion: @escaping (_ exist : Bool) -> ()){
        
        Database.database().reference().child("user").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            completion(snapshot.hasChildren())
        })
    }
    
    // -TODO: Write a formal email verification on firebase options and test this method
    /**
     Sends an email verification to the user's email
     - parameter handler: deals with errors
     */
    func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if error != nil {
                
                self.dealWithError(error)
            }
        })
    }
    
    func dealWithError(_ error : Error!) {
        
        if let errCode = AuthErrorCode(rawValue: error._code) {
            
            switch errCode {
            case .invalidEmail:
                output.fetched("Email inválido", field: .email)
            
            case .wrongPassword:
                output.fetched("Senha inválida", field: .password)

            case .userNotFound:
                output.fetched("Usuario não cadastrado", field: .email)
                
            case .operationNotAllowed:
                output.fetched("Conta não ativada. Verifique em sua caixa de entrada se você recebeu algum e-mail nosso", field: nil)
                
            case .networkError:
                output.fetched("Verifique sua conexão com a internet", field: nil)

            case .userDisabled:
                output.fetched("Essa conta de usuário está desativada", field: nil)
    
            case .invalidUserToken, .userTokenExpired:
                output.fetched("Sessão expirada", field: nil)

            default:
                output.fetched("Ocorreu um erro, por favor tente novamente mais tarde", field: nil)
            }
        }
    }
}
