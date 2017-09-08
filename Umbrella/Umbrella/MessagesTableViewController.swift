//
//  MessagesViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 09/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {
    
    var presenter : MessagesPresenterProtocol!
    var messages = [MessageEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.viewDidLoad()
    }
    
    func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(handleReturnHome))
        navigationItem.titleView = UIImageView(image: UIImage(named : "MessageIcon"))
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(named : "bkgChatView"), for: .default)
        
        tableView.backgroundView = UIImageView(image: UIImage(named : "bkgChatView"))
        tableView.register(UserMessageCell.self, forCellReuseIdentifier: "cellId")
    }
    
    func handleReturnHome() {
        dismiss(animated: true, completion: nil)
    }
}

extension MessagesTableViewController : MessagesViewProtocol {
    
    func showUserMessages(_ messages: [MessageEntity]){
        self.messages = messages
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
        
        UserInteractor.getUser(withId: id, completion: { (partner) in
            
            let chatController = ChatRouter.assembleModule()
            chatController.presenter.partner = partner
            self.present(chatController, animated: true, completion: nil)
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
}










