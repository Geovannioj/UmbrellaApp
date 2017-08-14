//
//  ChatCollectionViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 10/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class ChatCollectionViewController: UICollectionViewController {
    
    var partner  : UserEntity? {
        didSet {
            observeMessages()
        }
    }
    
    var messages = [MessageEntity]()
    let inputChatView = InputChatView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupInputView()
    }
    
    func observeMessages() {
        
        guard let partnerId = partner?.id else {
            return
        }
        
        MessageInterector.observeMessagesWith(partnerId: partnerId, { (message) in
            
            self.messages.append(message)
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        })
    }
    
    func setupCollectionView(){
        
        view?.backgroundColor = UIColor(patternImage: UIImage(named: "bkgChatView")!)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    func setupInputView() {
        
        view.addSubview(inputChatView)
        
        inputChatView.translatesAutoresizingMaskIntoConstraints = false
        inputChatView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        inputChatView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inputChatView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        inputChatView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        inputChatView.textField.delegate = self
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

        setupCell(cell, withMessage: message)
        
        return cell
    }
    
    func setupCell(_ cell : ChatCollectionViewCell, withMessage msg : MessageEntity) {
        
        let isCurrentUser = msg.fromId == UserInteractor.getCurrentUserUid()
        
        cell.bubbleWidthAnchor?.constant = msg.text.estimateFrame(width: view.frame.size.width - 100, sizeFont: 16).width + 32
        cell.bubbleRightAnchor?.isActive = isCurrentUser ? true : false
        cell.bubbleLeftAnchor?.isActive = isCurrentUser ? false : true
        cell.textView.textColor = isCurrentUser ? UIColor.white : UIColor.black
        cell.bubbleView.backgroundColor = isCurrentUser ? UIColor.blue : UIColor.white
    }
}

extension ChatCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = messages[indexPath.row].text.estimateFrame(width: collectionView.frame.width - 100, sizeFont: 16).height + 20
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }
}

extension ChatCollectionViewController : UITextFieldDelegate {
    
    func handleSend(){
        
        if let message = inputChatView.textField.text {
            MessageInterector.sendMessage(message, toId: partner!.id)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        handleSend()
        
        return true
    }
}



















