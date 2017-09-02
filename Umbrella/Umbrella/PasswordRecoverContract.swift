//
//  PassRecoverContract.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 02/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol PasswordRecoverViewProtocol : class {
    
    var presenter : PasswordRecoverPresenterProtocol! {get set}
    var indicatorView : NVActivityIndicatorView! {get set}
    
    func showFieldMessage(_ field : FieldEnum, message : String, isValid : Bool)
}

protocol PasswordRecoverPresenterProtocol : class {
    
    weak var view : PasswordRecoverViewProtocol? {get set}
    var interactor : PasswordRecoverInteractorProtocol! {get set}
    var router : PasswordRecoverRouterProtocol! {get set}
    
    func handlePasswordRecover(email : String?)
    func handleReturn()
}

protocol PasswordRecoverInteractorProtocol : class {
    
    weak var output : PasswordRecoverInteractorOutputProtocol! {get set}
    
    func sendPasswordResetEmail(email: String)
}

protocol PasswordRecoverInteractorOutputProtocol : class {
    
    func completeSendPasswordResetEmail()
    func fetched(_ error : String, field : FieldEnum?)
}

protocol PasswordRecoverRouterProtocol : class {
    
    weak var viewController : PasswordRecoverViewController? {get set}
    
    func performLoginControler()
}




