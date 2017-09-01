//
//  MessageContract.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 25/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

protocol MessagesViewProtocol : class {
    var presenter : MessagesPresenterProtocol! {get set}
    
    func showUserMessages(_ messages: [MessageEntity])
}

protocol MessagesPresenterProtocol : class {
    weak var view : MessagesViewProtocol? {get set}
    var interactor : MessagesInteractorProtocol! {get set}
    var router : MessagesRouterProtocol! {get set}

    
    func viewDidLoad()
}

protocol MessagesInteractorProtocol : class {
    weak var output : MessagesInteractorOutputProtocol! {get set}
    
    func observeMessages()
}

protocol MessagesInteractorOutputProtocol : class {
    func fetched(_ message : MessageEntity)
    func fetched(_ error : Error)
}

protocol MessagesRouterProtocol {
    
    weak var viewController : UITableViewController? {get set}
    
}
