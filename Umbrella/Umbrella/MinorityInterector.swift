//
//  MinorityInterector.swift
//  Umbrella
//
//  Created by Bruno Chagas on 31/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

extension User {

    static func createMinority(minority: Minority) {
        let ref = Database.database().reference()
        
        let minorityRef = ref.child("minority").child(ref.childByAutoId().key)
        minorityRef.setValue(minority.toAnyObject())

    }
    
    // -TODO: testar
    static func getMinorities() -> [Minority]{
        let minorityRef = Database.database().reference().child("minority")
        var minorities = [Minority]()
        
        minorityRef.observe(.value, with: { (snapshot) in
            
            let minoritiesDic = snapshot.value as! [String : Any]
            let minority = Minority()
            minority.id = minoritiesDic["id"] as! String
            minority.type = minoritiesDic["type"] as! String
            minorities.append(minority)
        })
        
        return minorities
    }
    
    static func updateMinority(id: String, type: String) {
        let minorityRef = Database.database().reference().child("minority").child(id)
        let minority = Minority()
        minority.id = id
        minority.type = type
        minorityRef.updateChildValues(minority.toAnyObject() as! [AnyHashable : Any])
    }
    
    static func deleteMinority(idMinority: String) {
        let minorityRef = Database.database().reference().child("minority").child(idMinority)
        minorityRef.removeValue()
    }

}
