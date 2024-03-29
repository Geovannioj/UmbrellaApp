//
//  LoginContract.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 29/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import NVActivityIndicatorView

protocol LoginViewProtocol : class {
    
    var presenter : LoginPresenterProtocol! {get set}
    var indicatorView : NVActivityIndicatorView! {get set}
    
    func showFieldMessage(_ field : FieldEnum, message : String, isValid : Bool)
}

protocol LoginPresenterProtocol : class {
    
    weak var view : LoginViewProtocol? { get set }
    var interactor : LoginInteractorProtocol! {get set}
    var router : LoginRouterProtocol! {get set}
    
    func handleLogin(email : String?, password : String?)
    func handleNewAccount()
    func handleForgotPassword()
    func handleFacebookLogin()
}

protocol LoginInteractorProtocol : class {
    
    weak var output : LoginInteractorOutputProtocol! {get set}

    func connectUserOnline(email: String, password: String)
    func connectFacebookUser(accessToken : String, completion: @escaping (_ id : String) -> ())
    func createDatabaseUser( _ user : UserEntity)
    func checkUserExists(id : String, completion: @escaping (_ exist : Bool) -> ())
    func sendEmailVerification()
}

protocol LoginInteractorOutputProtocol : class {
    
    func completeLogin( isVerified : Bool )
    func fetched(_ error : String, field : FieldEnum?)
}

protocol LoginRouterProtocol : class {
    
    weak var viewController : LoginViewController? {get set}
    
    func performMapControler()
    func performNewAccountController()
    func performForgotPassword()
}
