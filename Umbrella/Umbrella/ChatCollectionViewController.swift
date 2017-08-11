//
//  ChatCollectionViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 10/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class ChatCollectionViewController: UICollectionViewController {
    
    var user  : UserEntity?
    var messages = [MessageEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(MessageEntity(text: "mensagem1", timeDate: 10, fromId: "fromId", toId: "toId"))
        messages.append(MessageEntity(text: "mensagem2", timeDate: 11, fromId: "fromId", toId: "toId"))
        messages.append(MessageEntity(text: "mensagem3", timeDate: 12, fromId: "fromId", toId: "toId"))
        
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 60, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
        setupInputView()
    }
    
    func setupInputView() {
        
        let inputChatView = InputChatView()
        
        view.addSubview(inputChatView)
        
        inputChatView.translatesAutoresizingMaskIntoConstraints = false
        inputChatView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        inputChatView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inputChatView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        inputChatView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        inputChatView.fileIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapFileIcon)))
    }
    
    func handleTapFileIcon() {
        
    }
}

extension ChatCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatCollectionViewCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text

//        setupCell(cell, withMessage: message)
        
        return cell
    }
    
    func setupCell(_ cell : ChatCollectionViewCell, withMessage msg : MessageEntity) {
        
        if msg.fromId == UserInteractor.getCurrentUserUid() {
            
            cell.textView.textColor = UIColor.white
            cell.bubbleView.backgroundColor = UIColor.blue
        } else {
            
            cell.textView.textColor = UIColor.black
            cell.bubbleView.backgroundColor = UIColor.white
        }
    }
    
}


extension ChatCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = messages[indexPath.item].text.estimateFrame(width: collectionView.frame.width, sizeFont: 16).height + 20
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
}

extension ChatCollectionViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
}



















