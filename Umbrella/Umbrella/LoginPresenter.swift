//
//  LoginPresenter.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 07/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginPresenter : NSObject, LoginPresenterProtocol {
    
    weak var view : LoginViewProtocol?
    var interactor : LoginInteractorProtocol!
    var router : LoginRouterProtocol!
        
    func handleLogin(email : String?, password : String?) {
        
        var valid = true
        
        isValidField(email, field: .email, check: &valid)
        isValidField(password, field: .password, check: &valid)
        
        if valid {
            
            view?.indicatorView.startAnimating()
            interactor.connectUserOnline(email: email!, password: password!)
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
    
    func handleNewAccount() {
        
        router.performNewAccountController()
    }
    
    func handleForgotPassword() {
        
        router.performForgotPassword()
    }
}

extension LoginPresenter {
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            return
        }
        
        view?.indicatorView.startAnimating()
        connectFacebookUser()
    }
    
    func connectFacebookUser() {
        
        guard let access = FBSDKAccessToken.current().tokenString else {
            return
        }
        
        self.interactor.connectFacebookUser(accessToken: access, completion: { (id) in
            
            self.interactor.checkUserExists(id: id, completion: { (exist) in
                
                if !exist {
                    self.createFacebookUser(id)
                } else {
                    self.completeLogin(isVerified: true)
                }
            })
        })
    }
    
    func createFacebookUser(_ id : String) {
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "name, email, age_range, picture, gender"]).start { (connection, result, err) in
            
            if err != nil {
                return
            }
            
            if let dictionary = result as? [String : Any] {
                
                let user = UserEntity()
                
                user.id = id
                user.nickname = dictionary["name"] as! String
                user.email = dictionary["email"] as! String
                
                if let picture = dictionary["picture"] as? Dictionary<String,Any> {
                    if let data = picture["data"] as? Dictionary<String,Any> {
                        if let pictureUrl = data["url"] as? String {
                            user.urlPhoto = pictureUrl
                        }
                    }
                }
                
                self.interactor.createDatabaseUser(user)
            }
            
            FBSDKLoginManager().logOut()
        }
    }
}

extension LoginPresenter : LoginInteractorOutputProtocol {
    
    func completeLogin( isVerified : Bool ) {
        
        view?.indicatorView.stopAnimating()
        
        if isVerified {
            
            router.performMapControler()
            
        } else {
            
            AlertPresenter().showAlert(viewController: view as! UIViewController,
                            title: "Alerta!!",
                            message: "Verifique sua conta antes de fazer o login. Deseja que enviemos outro e-mail de verificação?",
                            confirmButton: "Sim",
                            cancelButton: "Não", onAffirmation: {
                    
                    self.interactor.sendEmailVerification()
            })
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







