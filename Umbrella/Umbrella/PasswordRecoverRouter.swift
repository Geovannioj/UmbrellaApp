//
//  PasswordRouter.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 02/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class PasswordRecoverRouter: PasswordRecoverRouterProtocol {
    
    weak var viewController : PasswordRecoverViewController?
    
    static func assembleModule() -> PasswordRecoverViewController {
        
        let storyBoard = UIStoryboard(name: "PasswordRecover", bundle: nil)
        let view = storyBoard.instantiateViewController(withIdentifier: "PasswordRecoverViewController") as! PasswordRecoverViewController
        let presenter = PasswordRecoverPresenter()
        let interactor = PasswordRecoverInteractor()
        let router = PasswordRecoverRouter()
        
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
