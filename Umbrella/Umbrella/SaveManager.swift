//
//  SaveManager.swift
//  Umbrella
//
//  Created by Bruno Chagas on 03/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift

class SaveManager {
    
    static let instance = SaveManager()
    
    static let realm : Realm = {
        
        do {
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in

            })
            
            print(Realm.Configuration.defaultConfiguration)
            Realm.Configuration.defaultConfiguration = config
            return try Realm()
            
        } catch let error as NSError {
            print(error.debugDescription)
            fatalError("Can't continue further, no Realm available")
        }
    }()
    
    private init() {}
    
    func create(_ object : Object) {
        
        try! SaveManager.realm.write {
            SaveManager.realm.add(object)
        }
        
    }
    
    func delete() {
        
    }
}

