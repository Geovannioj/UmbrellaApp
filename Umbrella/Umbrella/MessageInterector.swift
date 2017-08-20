//
//  MessageInterector.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 09/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class MessageInterector {
    
    static func createChat(withId toId : String) {
        
        let fromId = UserInteractor.getCurrentUserUid()!
        
        let userMesRef = Database.database().reference().child("user-messages")
        userMesRef.child(fromId).child(toId)
        userMesRef.child(toId).child(fromId)
    }
    
    static func sendMessage(_ text : String, toId : String){
        
        let fromId = UserInteractor.getCurrentUserUid()!
        let values = ["text" : text,
                      "fromId" : fromId,
                      "toId" : toId,
                      "timeDate" : Int(Date().timeIntervalSince1970)] as [String : Any]
        
        let newRef = Database.database().reference().child("messages").childByAutoId()
        
        newRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            if error != nil {
                // tratar erros 
                return
            }
            
            let userMesRef = Database.database().reference().child("user-messages")
            let fromIdRef = userMesRef.child(fromId).child(toId)
            let toIdRef = userMesRef.child(toId).child(fromId)
            let messageId = newRef.key
            
            fromIdRef.updateChildValues([messageId : 1])
            toIdRef.updateChildValues([messageId : 1])
        })
        
    }
    
    static func observeMessages(_ completion: @escaping (MessageEntity) -> ()){
        
        guard let uid = UserInteractor.getCurrentUserUid() else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let partnerId = snapshot.key
            let partnerRef = ref.child(partnerId)
            
            partnerRef.observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                let messageRef = Database.database().reference().child("messages").child(messageId)
                
                messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String : Any] {
                        
                        let message = MessageEntity(text: dictionary["text"] as! String,
                                                    timeDate: dictionary["timeDate"] as! Double,
                                                    fromId: dictionary["fromId"] as! String,
                                                    toId: dictionary["toId"] as! String)
                        completion(message)
                    }
                })
            })
        })
    }
    
    static func observeMessagesWith(partnerId : String,_ completion: @escaping (MessageEntity) -> ()){
        
        guard let uid = UserInteractor.getCurrentUserUid() else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid).child(partnerId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String : Any] {
                 
                    let message = MessageEntity(text: dictionary["text"] as! String,
                                                timeDate: dictionary["timeDate"] as! Double,
                                                fromId: dictionary["fromId"] as! String,
                                                toId: dictionary["toId"] as! String)
                    completion(message)
                }
            })
        })
    }
    
}
