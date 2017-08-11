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
    
    static func createMessage(){
        
    }
    
    static func observeMessages(_ completion: @escaping (MessageEntity) -> ()){
        
        guard let uid = UserInteractor.getCurrentUserUid() else {
            return
        }
        
        let ref = Database.database().reference().child("userMessages").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String : Any] {
                 
                    let message = MessageEntity(text: dictionary["text"] as! String,
                                                timeDate: dictionary["fromId"] as! Double,
                                                fromId: dictionary["toId"] as! String,
                                                toId: dictionary["timeDate"] as! String)
                    completion(message)
                }
            })
        })
    }
}
