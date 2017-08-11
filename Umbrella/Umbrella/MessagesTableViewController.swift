//
//  MessagesViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 09/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {
    
    var userMessages = [String : MessageEntity]()
    var messages = [MessageEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(handleReturnHome))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(handleEditCells))
        
        messages.append(MessageEntity(text: "mensagem1", timeDate: 10, fromId: "fromId", toId: "toId"))
        messages.append(MessageEntity(text: "mensagem2", timeDate: 11, fromId: "fromId", toId: "toId"))
        messages.append(MessageEntity(text: "mensagem3", timeDate: 12, fromId: "fromId", toId: "toId"))
        
        tableView.register(UserMessageCell.self, forCellReuseIdentifier: "cellId")
    }

    func obseverUserMessages() {
        
        MessageInterector.observeMessages({ (message) in

            if let id = message.chatPartenerId() {
                
                self.userMessages[id] = message
                self.messages = Array(self.userMessages.values)
                
                self.messages.sort(by: { (message1, message2) -> Bool in
                    
                    return message1.timeDate > message2.timeDate
                })
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    func handleReturnHome() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleEditCells() {
        //Editar celulas
        //Remover celulas
    }
}

extension MessagesTableViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserMessageCell
        cell.message = messages[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        
        guard let id = message.chatPartenerId() else {
            return // Retorna erro de id para o usuario
        }
        
//        UserInteractor.getUser(withId: id, completion: { (user) in
            
            // ChatLogController
            let chatController = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
//            chatController.user = UserEntity()
            self.navigationController?.pushViewController(chatController, animated: true)
            // Presenter for user
//        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}










