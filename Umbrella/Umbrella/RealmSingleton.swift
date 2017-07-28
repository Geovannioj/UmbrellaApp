//
//  RealmSingleton.swift
//  Umbrella
//
//  Created by Bruno Chagas on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift

class AppRealm {
    
    static let instance:Realm = {
        do {
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {
                    }
            })
            Realm.Configuration.defaultConfiguration = config
            return try Realm()
            
        } catch let error as NSError {
            print(error.debugDescription)
            fatalError("Can't continue further, no Realm available")
        }
    }()
    
    private init() {}
}

