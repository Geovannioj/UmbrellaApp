//
//  FirebaseManager.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    var refReports : DatabaseReference!
    
    func initReference() {
        self.refReports =  Database.database().reference().child("reports")
    }
    
    
}
