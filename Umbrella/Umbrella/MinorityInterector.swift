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

class MinorityInteractor {

    static func createMinority(minority: String) {
        let ref = Database.database().reference()
        let mino = Minority()
        mino.id = ref.childByAutoId().key
        mino.type = minority
        
        let minorityRef = ref.child("minority").child(mino.id)
        minorityRef.setValue(mino.toAnyObject())
    }
    
    static func getMinorities(completion: @escaping ([Minority]) -> ()){
        let minorityRef = Database.database().reference().child("minority")
        var minorities = [Minority]()
        
        minorityRef.observe(.value, with: { (snapshot) in
            if snapshot.value is NSNull {
                print("Minority not found")
                return
            }
                    
            for child in snapshot.children {
                let minority = Minority()
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String : AnyObject]
                
                minority.id = dict["id"] as! String
                minority.type = dict["type"] as! String
                minorities.append(minority)
            }
            completion(minorities)
        })
    }
    
    static func getMinority(withType type: String, completion: @escaping (Minority) -> ()){
        let minorityRef = Database.database().reference().child("minority")
        
        minorityRef.observe(.childAdded, with: { (snapshot: DataSnapshot) in
            
            let dict = snapshot.value as! [String : Any]
            if (dict["type"] as? String) != nil && (dict["type"] as! String) == type {
                
                let minority = Minority()
                
                minority.id = dict["id"] as! String
                minority.type = dict["type"] as! String
                
                completion(minority)
            }
        })
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