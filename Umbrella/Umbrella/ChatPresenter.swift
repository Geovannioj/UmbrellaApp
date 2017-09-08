//
//  ChatPresenter.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 24/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation

class ChatPresenter  : ChatPresenterProtocol {
   
    var partner : UserEntity!
    
    weak var view: ChatViewProtocol?
    var interactor : ChatInteractorProtocol!
    var router : ChatRouterProtocol!
    
    func viewDidLoad() {
        
        interactor.observeMessagesWith(partnerId: partner.id)
    }

    func send(message: String?){
        
        if message != nil, message!.characters.count > 0 {
            interactor.sendMessage(message!, toId: partner!.id)
        }
    }
}

extension ChatPresenter : ChatInteractorOutputProtocol {
    
    func fetched(_ message: MessageEntity) {
        view?.showNewMessage(message)
    }

    func fetched(_ error : Error) {
        // Tratar os erros e mandar para a viewController
        print(error)
    }
}
