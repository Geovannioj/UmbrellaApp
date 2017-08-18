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
        let mino = MinorityEntity()
        mino.id = ref.childByAutoId().key
        mino.type = minority
        
        let minorityRef = ref.child("minority").child(mino.id)
        minorityRef.setValue(mino.toAnyObject())
        
    }
    
    static func getMinorities(completion: @escaping ([MinorityEntity]) -> ()){
        let minorityRef = Database.database().reference().child("minority")
        var minorities: [MinorityEntity] = []
        
        minorityRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                print("Minority not found")
                return
            }
                    
            for child in snapshot.children {
                let minority = MinorityEntity()
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String : AnyObject]
                
                minority.id = snap.key
                minority.type = dict["type"] as! String
                minorities.append(minority)
            }
            print(minorities)
            completion(minorities)
        })
    }
    
    static func getMinority(withType type: String, completion: @escaping (MinorityEntity) -> ()){
        let minorityRef = Database.database().reference().child("minority")
        
        minorityRef.observeSingleEvent(of: .childAdded, with: { (snapshot: DataSnapshot) in
            
            let dict = snapshot.value as! [String : Any]
            if (dict["type"] as? String) != nil && (dict["type"] as! String) == type {
                
                let minority = MinorityEntity()
                
                minority.id = snapshot.key
                minority.type = dict["type"] as! String
                
                completion(minority)
            }
        })
    }
    
    static func getMinority(withId id: String, completion: @escaping (MinorityEntity) -> ()){
        let minorityRef = Database.database().reference().child("minority").child(id)
        
        minorityRef.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            
            let dict = snapshot.value as! [String : Any]
            let minority = MinorityEntity()
            
            minority.id = id
            minority.type = dict["type"] as! String
                
            completion(minority)
        })
    }
    
    static func updateMinority(id: String, type: String) {
        let minorityRef = Database.database().reference().child("minority").child(id)
        let minority = MinorityEntity()
        minority.type = type
        minorityRef.updateChildValues(minority.toAnyObject() as! [AnyHashable : Any])
    }
    
    static func deleteMinority(idMinority: String) {
        let minorityRef = Database.database().reference().child("minority").child(idMinority)
        minorityRef.removeValue()
    }

}
