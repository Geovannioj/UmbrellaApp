//
//  UserEntity.swift
//  Umbrella
//
//  Created by Bruno Chagas on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id = ""
    dynamic var nickname = ""
    dynamic var email = ""
    dynamic var password = ""
    dynamic var age = 0
    dynamic var idPhoto: String? = nil
    dynamic var idMinority: String? = nil
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toAnyObject() -> Any {
        return [
            "nickname": nickname,
            "email": email,
            "age": age,
            "idPhoto": idPhoto as Any,
            "idMinority": idMinority as Any
        ]
    }

}


