//
//  FilterInteractor.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 30/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//


import Foundation
import RealmSwift
import Firebase

class FilterInteractor {
    
    static func createFilter(filter: String) {
        let ref = Database.database().reference()
        let filt = FilterEntity()
        filt.id = ref.childByAutoId().key
        filt.type = filter
        
        let filterRef = ref.child("filter").child(filt.id)
        filterRef.setValue(filt.toAnyObject())
        
    }
    
    static func getFilters(completion: @escaping ([FilterEntity]) -> ()){
        let filterRef = Database.database().reference().child("filter")
        var filters: [FilterEntity] = []
        
        filterRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                print("Filter not found")
                return
            }
            
            for child in snapshot.children {
                let filter = FilterEntity()
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String : AnyObject]
                
                filter.id = snap.key
                filter.type = dict["type"] as! String
                filters.append(filter)
            }
            completion(filters)
        })
    }
    
    static func getFilter(withType type: String, completion: @escaping (FilterEntity) -> ()){
        let filterRef = Database.database().reference().child("filter")
        
        filterRef.observeSingleEvent(of: .childAdded, with: { (snapshot: DataSnapshot) in
            
            let dict = snapshot.value as! [String : Any]
            if (dict["type"] as? String) != nil && (dict["type"] as! String) == type {
                
                let filter = FilterEntity()
                
                filter.id = snapshot.key
                filter.type = dict["type"] as! String
                
                completion(filter)
            }
        })
    }
    
    static func getFilter(withId id: String, completion: @escaping (MinorityEntity) -> ()){
        let filterRef = Database.database().reference().child("filter").child(id)
        
        filterRef.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            
            let dict = snapshot.value as! [String : Any]
            let filter = MinorityEntity()
            
            filter.id = id
            filter.type = dict["type"] as! String
            
            completion(filter)
        })
    }
    
    static func updateFilter(id: String, type: String) {
        let filterRef = Database.database().reference().child("filter").child(id)
        let filter = MinorityEntity()
        filter.type = type
        filterRef.updateChildValues(filter.toAnyObject() as! [AnyHashable : Any])
    }
    
    static func deleteMinority(idMinority: String) {
        let filterRef = Database.database().reference().child("filter").child(idMinority)
        filterRef.removeValue()
    }
    
}
