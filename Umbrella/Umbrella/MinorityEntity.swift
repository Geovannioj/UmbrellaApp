//
//  MinorityEntity.swift
//  Umbrella
//
//  Created by Bruno Chagas on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation

class MinorityEntity {
    var id = ""
    var type = ""
    
    func toAnyObject() -> Any {
        return [
            "type": type
        ]
    }

}

