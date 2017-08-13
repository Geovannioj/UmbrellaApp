//
//  Report.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation

class Report {
    
    var id : String
    var userId : String
    var title : String
    var description : String
    var violenceKind : String
    var violenceAproximatedTime : Double
    var latitude : Double
    var longitude : Double
    var personGender : String
    
    init(id : String,
         userId: String,
         title : String,
         description : String,
         violenceKind : String,
         violenceAproximatedTime : Double,
         latitude : Double,
         longitude : Double,
         personGender: String) {
        
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.violenceKind = violenceKind
        self.violenceAproximatedTime = violenceAproximatedTime
        self.latitude = latitude
        self.longitude = longitude
        self.personGender = personGender
        
    }
    
    init() {
        self.id = "No Id"
        self.userId = "No User"
        self.title = "No title"
        self.description = "No description"
        self.violenceKind = "No violence"
        self.violenceAproximatedTime = 123
        self.latitude = 0.0
        self.longitude = 0.0
        self.personGender = "nO gender"
    }
    func turnToDictionary() -> Any {
        
        return [
            "id" : id,
            "userId" : userId,
            "title" : title,
            "description" : description,
            "violenceKind" : violenceKind,
            "violenceAproximatedTime" : violenceAproximatedTime,
            "latitude" : latitude,
            "longitude" : longitude,
            "personGender" : personGender
        ]
    }

}
