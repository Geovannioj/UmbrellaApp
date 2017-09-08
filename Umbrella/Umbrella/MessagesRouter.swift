//
//  MessagesRouter.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 28/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class MessagesRouter : MessagesRouterProtocol {
    
    weak var viewController: UITableViewController?
    
    static func assembleModule() -> UIViewController {
        
        let view = MessagesTableViewController()
        let presenter = MessagesPresenter()
        let interactor = MessagesInteractor()
        let router = MessagesRouter()
    
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        
        router.viewController = view
        
        return UINavigationController(rootViewController: view)
    }
    
    
}
