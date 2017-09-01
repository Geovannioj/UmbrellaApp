//
//  MessagesPresenter.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 09/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class MessagesPresenter : MessagesPresenterProtocol {
    
    weak var view : MessagesViewProtocol?
    
    var interactor : MessagesInteractorProtocol!
    var router : MessagesRouterProtocol!
    
    var messages = [MessageEntity]()
    var userMessages = [String : MessageEntity]()
    var timer : Timer?
    
    func viewDidLoad() {
        
        interactor.observeMessages()
    }
    
    func handleReloadTable() {
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            
            self.messages = Array(self.userMessages.values)
            self.messages.sort(by: { (message1, message2) -> Bool in
                
                return message1.timeDate > message2.timeDate
            })
            
            self.view?.showUserMessages(self.messages)
        })
    }
    
}

extension MessagesPresenter : MessagesInteractorOutputProtocol {
    
    func fetched(_ message : MessageEntity) {
        
        if let id = message.chatPartenerId() {
            userMessages[id] = message
            handleReloadTable()
        }
    }
    
    func fetched(_ error : Error) {
        //Tratar erros de servidor
    }
}
