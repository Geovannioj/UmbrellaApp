//
//  ChatInteractor.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 24/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class ChatInteractor : ChatInteractorProtocol {
    
    weak var output : ChatInteractorOutputProtocol!
    
    let userMessagesRef = Database.database().reference().child("user-messages")
    let messagesRef = Database.database().reference().child("messages")
    
    func observeMessagesWith(partnerId : String) {
        
        guard let uid = UserInteractor.getCurrentUserUid() else {
            self.output.fetched(NSError(domain: "no currrent user", code: 1, userInfo: nil))
            return
        }
        
        let ref = userMessagesRef.child(uid).child(partnerId)
        
        ref.observe(DataEventType.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageRef = self.messagesRef.child(messageId)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String : Any] {
                    
                    let message = MessageEntity(text: dictionary["text"] as! String,
                                                timeDate: dictionary["timeDate"] as! Double,
                                                fromId: dictionary["fromId"] as! String,
                                                toId: dictionary["toId"] as! String)
                    
                    self.output.fetched(message)
                }
            })
        })
    }
    
    func sendMessage(_ text : String, toId : String){
        
        let fromId = UserInteractor.getCurrentUserUid()! //Tratar erro de usuario nao logado
        let values = ["text" : text,
                      "fromId" : fromId,
                      "toId" : toId,
                      "timeDate" : Int(Date().timeIntervalSince1970)] as [String : Any]
        
        let newRef = self.messagesRef.childByAutoId()
        
        newRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            if error != nil {
                self.output.fetched(error!) // Tratar Erros no interector ou presenter ?
                return
            }
            
            let fromIdRef = self.userMessagesRef.child(fromId).child(toId)
            let toIdRef = self.userMessagesRef.child(toId).child(fromId)
            let messageId = newRef.key
            
            fromIdRef.updateChildValues([messageId : 1])
            toIdRef.updateChildValues([messageId : 1])
        })
    }
}
