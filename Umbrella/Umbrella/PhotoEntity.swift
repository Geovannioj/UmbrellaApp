//
//  PhotoEntity.swift
//  Umbrella
//
//  Created by Bruno Chagas on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift

class Photo: Object {
    dynamic var id = ""
    dynamic var url = ""
    dynamic var image: Data?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    func toAnyObject() -> Any {
//        return [
//            "id": id,
//            "url": url
//        ]
//    }
    
}
