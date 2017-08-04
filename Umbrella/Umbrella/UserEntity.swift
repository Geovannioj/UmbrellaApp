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
    dynamic var birthDate: Date? = nil
    dynamic var idPhoto: String? = nil
    dynamic var idMinority: String? = nil
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toAnyObject() -> Any {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var birth: String? = nil
        if birthDate != nil {
            birth = formatter.string(from: birthDate!)
        }
        
        return [
            "nickname": nickname,
            "email": email,
            "birthDate": birth as Any,
            "idPhoto": idPhoto as Any,
            "idMinority": idMinority as Any
        ]
    }

}


