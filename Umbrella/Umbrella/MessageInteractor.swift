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

class MessagesInteractor : MessagesInteractorProtocol {
    
    weak var output : MessagesInteractorOutputProtocol!
    var userMesRef = Database.database().reference().child("user-messages")
    
    func observeMessages(){
        
        guard let userId = UserInteractor.getCurrentUserUid() else {
            self.output.fetched(NSError(domain: "no currrent user", code: 1, userInfo: nil))
            return
        }
        
        let ref = userMesRef.child(userId)
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
                        
                        self.output.fetched(message)
                    }
                })
            })
        })
    }

}
