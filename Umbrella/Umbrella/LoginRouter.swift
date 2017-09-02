//
//  LoginRouter.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 29/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class LoginRouter : LoginRouterProtocol {
    
    weak var viewController : LoginViewController?
    
    static func assembleModule() -> LoginViewController {
        
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let view = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        let router = LoginRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func performMapControler() {
        
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func performNewAccountController() {
        
        let controller = RegisterRouter.assembleModule()
        viewController?.present(controller, animated: true, completion: nil)
    }
    
    func performForgotPassword() {
        
        let controller = PasswordRecoverRouter.assembleModule()
        viewController?.present(controller, animated: true, completion: nil)
    }
}
