//
//  ChatCollectionViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 10/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class ChatCollectionViewController: UICollectionViewController {
    
    var partner : UserEntity!
    
    var messages = [MessageEntity]()
    let inputChatView = InputChatView()
    let navigation = NavigationView()
    var collectionBottomAnchor : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if partner == nil {
            return // Notificar usuarios
        }
        
        setupNavigation()
        setupController()
        setupObservers()
        observeMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        inputAccessoryView?.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    func observeMessages() {
        
        MessageInterector.observeMessagesWith(partnerId: partner.id, { (message) in
            
            self.messages.append(message)
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        })
    }
    
    func handleKeyboardNotification(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        collectionBottomAnchor?.constant = notification.name == Notification.Name.UIKeyboardWillShow ? -keyboardFrame!.height : 0
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        }, completion : { _ in
            self.scrollToLastItem()
        })
    }
    
    func scrollToLastItem(){
        
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    func dismissKeyboard(){
        inputChatView.textField.resignFirstResponder()
    }
    
    func handleTapFileIcon() {
        
    }
    
    func handleTouchBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension ChatCollectionViewController {
    
    func setupController(){
        view.backgroundColor = UIColor.white
        view.backgroundImage(named: "bkgChatView")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: navigation.bottomAnchor).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionBottomAnchor = collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        collectionBottomAnchor?.isActive = true
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
    }
    
    override var inputAccessoryView: UIView? {
        get {
            
            inputChatView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            inputChatView.textField.delegate = self
            inputChatView.textField.returnKeyType = .send
            inputChatView.fileIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapFileIcon)))
            
            
            
            return inputChatView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setupNavigation(){
        
        view.addSubview(navigation)
        
        navigation.translatesAutoresizingMaskIntoConstraints = false
        navigation.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigation.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigation.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigation.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        navigation.backButton.addTarget(self, action: #selector(handleTouchBackButton), for: .touchUpInside)
        
        setupNameAndPhotoPartner()
    }
    
    func setupNameAndPhotoPartner() {
        
        UserInteractor.getUser(withId: partner.id, completion: {(user) in
            
            if let url = user.urlPhoto {
                
                self.navigation.profileImage.loadCacheImage(url)
                self.navigation.nameField.text = self.partner.nickname
            }
        })
    }
    
    func setupObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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

        cell.bubbleWidthAnchor?.constant = msg.text.estimateFrame(width: self.view.frame.size.width - 100, sizeFont: 16).width + 32
        
        msg.fromId == partner.id ? cell.setupStyleForPartner() : cell.setupStyleForUser()
    }
}

extension ChatCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = messages[indexPath.row].text.estimateFrame(width: self.view.frame.size.width - 100, sizeFont: 16).height + 25
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

extension ChatCollectionViewController : UITextFieldDelegate {
    
    func handleSend(){
        
        if let message = inputChatView.textField.text, message.characters.count > 0 {
            
            MessageInterector.sendMessage(message, toId: partner!.id)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        handleSend()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}



















