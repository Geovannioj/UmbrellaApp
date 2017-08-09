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
    
    dynamic var text = ""
    dynamic var timeDate : NSNumber? = nil
    dynamic var fromId = ""
    dynamic var toId = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toAnyObject() -> Any {
        
        return [
            "text": text,
            "timeDate": timeDate ?? NSNumber(value: 0.0),
            "fromId": fromId,
            "toId": toId,
        ]
    }
    
    func chatPartenerId() -> String? {
        return fromId == UserInteractor.getCurrentUserUid() ? toId : fromId
    }
}
