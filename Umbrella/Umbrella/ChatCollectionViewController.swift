//
//  ChatCollectionViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 10/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class ChatCollectionViewController: UICollectionViewController {

    //CurrentUser is talking to:
    var messages = [MessageEntity]()
    
    var presenter : ChatPresenterProtocol!
    let chatInputView = ChatInputView()
    let navigation = NavigationView()
    var collectionBottomAnchor : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        
        setupNavigation()
        setupController()
        setupObservers()
    }
    
    /**
     Remove inputAccessoryView
     Remove Observers
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        inputAccessoryView?.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Handle when keyboard Will Show and Will Hide, for changed collection Bottom Anchor constant.
     - parameters:
        - notification: Keyboard Notification
     */
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
    
    /** Scroll CollectionView to last item in messages array */
    func scrollToLastItem(){
        
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    /** Dismiss keyboard when touch in screen */
    override func dismissKeyboard(){
        super.dismissKeyboard()
        chatInputView.textField.resignFirstResponder()
    }
    
    /** Dismiss controller when touch back button */
    func handleTouchBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension ChatCollectionViewController : ChatViewProtocol {
    
    /**
     Append new message in array, and reload data of collection view.
     - parameter message: Message entity
     */
    func showNewMessage(_ message: MessageEntity) {

        messages.append(message)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

extension ChatCollectionViewController {
    
    /**
     Setup view: color, background, and add dimiss keyboard gesture.
     Setup collectionView: Anchors, register cells, background and properties.
     */
    func setupController(){
        view.backgroundColor = UIColor.white
        view.backgroundImage(named: "bkgChatView")
        dismissKayboardInTapGesture()
                
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: navigation.bottomAnchor).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionBottomAnchor = collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        collectionBottomAnchor?.isActive = true
        
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    /**
     Setup input of chat: textField, and buttons.
     InputAccessoryView: The custom input accessory locked on keyboard to display when the receiver becomes the first responder.
     */
    override var inputAccessoryView: UIView? {
        get {
            chatInputView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            chatInputView.textField.delegate = self
            chatInputView.textField.returnKeyType = .send

            return chatInputView
        }
    }
    
    /** Actived inputAccessoryView */
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    /** Setup navigation view anchors, and add backbutton target */
    func setupNavigation(){
        
        view.addSubview(navigation)
        
        navigation.translatesAutoresizingMaskIntoConstraints = false
        navigation.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigation.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigation.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigation.heightAnchor.constraint(equalToConstant: 90).isActive = true

        navigation.backButton.addTarget(self, action: #selector(handleTouchBackButton), for: .touchUpInside)
        
        setupNameAndPhotoPartner()
    }
    
    /** Setup name and photo of partner in navigation view */
    func setupNameAndPhotoPartner() {
        
        UserInteractor.getUser(withId: presenter.partner.id, completion: {(user) in
            
            if let url = user.urlPhoto {
                self.navigation.profileImage.loadCacheImage(url)
                self.navigation.nameField.text = self.presenter.partner.nickname
            }
        })
    }
    
    /**
     Setup observers:
        - Keyboard will show
        - Keyboard will hide
     */
    func setupObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}

extension ChatCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatCollectionViewCell

        return setupCell(cell, message: messages[indexPath.item])
    }
    
    /**
     Setup cells of collectionView:
        - Message
        - Width anchor cell, for estimated frame of message text.
        - Cell sytle for user or partner.
     */
    func setupCell(_ cell : ChatCollectionViewCell, message : MessageEntity) -> ChatCollectionViewCell {

        cell.textView.text = message.text
        cell.bubbleWidthAnchor?.constant = message.text.estimateFrame(width: self.view.frame.size.width - 100, sizeFont: 16).width + 32
        
        message.fromId == presenter.partner.id ? cell.setupStyleForPartner() : cell.setupStyleForUser()
        
        return cell
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
        presenter.send(message: chatInputView.textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        handleSend()
        textField.text?.removeAll()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
