//
//  ChatContract.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 24/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

protocol ChatViewProtocol : class {
    var presenter : ChatPresenterProtocol! {get set}
    
    func showNewMessage(_ message: MessageEntity)
}

protocol ChatPresenterProtocol : class {
    var partner : UserEntity! {get set}

    weak var view : ChatViewProtocol? { get set }
    var interactor : ChatInteractorProtocol! {get set}
    var router : ChatRouterProtocol! {get set}
    
    func viewDidLoad()
    func send(message: String?)
}

protocol ChatInteractorProtocol : class {
    weak var output : ChatInteractorOutputProtocol! {get set}
    
    func observeMessagesWith(partnerId : String)
    func sendMessage(_ text : String, toId : String)
}

protocol ChatInteractorOutputProtocol : class {
    func fetched(_ message : MessageEntity)
    func fetched(_ error : Error)
}

protocol ChatRouterProtocol {
    
    weak var viewController : ChatCollectionViewController? {get set}
}
