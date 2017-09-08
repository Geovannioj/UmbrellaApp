//
//  ChatRouter.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 28/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class ChatRouter : ChatRouterProtocol {
    
    weak var viewController : ChatCollectionViewController?

    static func assembleModule() -> ChatCollectionViewController {
        
        let view = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let presenter = ChatPresenter()
        let interactor = ChatInteractor()
        let router = ChatRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        
        router.viewController = view
        
        return view
    }
    
}
