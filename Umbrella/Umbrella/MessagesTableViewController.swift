//
//  MessagesViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 09/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController{
    
    var userMessages = [String : MessageEntity]()
    var messages = [MessageEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(handleReturnHome))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(handleEditCells))
        
        tableView.register(UserMessageCell.self, forCellReuseIdentifier: "cellId")
        
        obseverUserMessages()
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        tableView.reloadData()
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
            return // Retornar erro de id para o usuario
        }
        
        UserInteractor.getUser(withId: id, completion: { (partener) in
            
            let chatController = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
            chatController.partner = partener
            self.navigationController?.pushViewController(chatController, animated: true)
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}










