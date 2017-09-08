//
//  RegisterContract.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 30/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import NVActivityIndicatorView

protocol RegisterViewProtocol : class {
    
    var presenter : RegisterPresenterProtocol! {get set}
    var indicatorView : NVActivityIndicatorView! {get set}
    
    func changedProfileImage( _ image : UIImage?)
    func showFieldMessage(_ field : FieldEnum, message : String, isValid : Bool)
}

protocol RegisterPresenterProtocol : class {
    
    weak var view : RegisterViewProtocol? {get set}
    var interactor : RegisterInteractorProtocol! {get set}
    var router : RegisterRouterProtocol! {get set}
    
    func createUser(nickname: String?, email : String?, password: String?, image : UIImage?)
    func validateField(_ field : FieldEnum, input : String?)
    func handleSelectProfileImage()
    func handleReturn()
}

protocol RegisterInteractorProtocol : class {
    
    weak var output : RegisterInteractorOutputProtocol! {get set}
    
    func createUser(nickname: String, email: String, password: String, image: UIImage?)
    func sendEmailVerification()
}

protocol RegisterInteractorOutputProtocol : class {
    
    func completeCreate()
    func fetched(_ error : String, field : FieldEnum?)
}

protocol RegisterRouterProtocol : class {
    
    weak var viewController : RegisterViewController? {get set}
    
    func performLoginControler()
}
