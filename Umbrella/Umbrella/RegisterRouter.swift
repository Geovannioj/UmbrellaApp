//
//  RegisterRouter.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 30/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class RegisterRouter: RegisterRouterProtocol {
    
    weak var viewController : RegisterViewController?

    static func assembleModule() -> RegisterViewController {
        
        let storyBoard = UIStoryboard(name: "Register", bundle: nil)
        let view = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        let presenter = RegisterPresenter()
        let interactor = RegisterInteractor()
        let router = RegisterRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
 
    func performLoginControler() {
        
        viewController?.dismiss(animated: true, completion: nil)
    }
    
}
