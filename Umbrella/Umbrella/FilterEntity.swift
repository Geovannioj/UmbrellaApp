//
//  FilterEntity.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 30/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation

class FilterEntity {
    var id = ""
    var type = ""
    
    func toAnyObject() -> Any {
        return [
            "type": type
        ]
    }
    
}
