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
    dynamic var id = 1
    dynamic var nickname = ""
    dynamic var email = ""
    dynamic var password = ""
    dynamic var age = 0
    dynamic var photo: Photo?
    dynamic var minority: Minority?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}


