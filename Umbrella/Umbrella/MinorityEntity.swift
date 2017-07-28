//
//  MinorityEntity.swift
//  Umbrella
//
//  Created by Bruno Chagas on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift

class Minority: Object {
    dynamic var id = 1
    dynamic var type = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

enum MinorityTypes: Int {
    case Gay = 0
    case Lesbian = 1
    case Transgender = 2
    case Bisexual = 3
    // ...
}
