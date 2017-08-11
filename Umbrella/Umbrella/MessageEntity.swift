//
//  MessageEntity.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 09/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import RealmSwift

class MessageEntity : Object {
    
    dynamic var id = ""
    dynamic var text = ""
    dynamic var timeDate : Double = 0
    dynamic var fromId = ""
    dynamic var toId = ""
    
    convenience init(text: String, timeDate: Double, fromId : String, toId : String) {
        self.init()
        
        self.text = text
        self.timeDate = timeDate
        self.fromId = fromId
        self.toId = toId
    }
    
    func toAnyObject() -> Any {
        
        return [
            "text": text,
            "timeDate": timeDate,
            "fromId": fromId,
            "toId": toId,
        ]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func chatPartenerId() -> String? {
        return fromId == UserInteractor.getCurrentUserUid() ? toId : fromId
    }
}
