//
//  UserEntity.swift
//  Umbrella
//
//  Created by Bruno Chagas on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift

class UserEntity: Object {
    dynamic var id = ""
    dynamic var nickname = ""
    dynamic var email = ""
    dynamic var birthDate: Date? = nil
    dynamic var urlPhoto: String? = nil
    dynamic var idMinority: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toAnyObject() -> Any {
        let formatter = dateConverter()
        
        var birth: String? = nil
        if birthDate != nil {
            birth = formatter.string(from: birthDate!)
        }
        
        return [
            "nickname": nickname,
            "email": email,
            "birthDate": birth ?? "",
            "urlPhoto": urlPhoto ?? "",
            "idMinority": idMinority ?? ""
        ]
    }

    func dateConverter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
}


