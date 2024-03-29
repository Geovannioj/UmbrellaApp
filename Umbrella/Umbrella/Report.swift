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
    var supports: Int
    var supporters: [UserEntity] = []
    var isActive: Int // 0 active 1 innactive
    
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
        self.supports = 0
        self.isActive = 0
    }
    
    init(id : String,
         userId: String,
         title : String,
         description : String,
         violenceKind : String,
         violenceAproximatedTime : Double,
         latitude : Double,
         longitude : Double,
         personGender: String,
         supports: Int) {
        
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.violenceKind = violenceKind
        self.violenceAproximatedTime = violenceAproximatedTime
        self.latitude = latitude
        self.longitude = longitude
        self.personGender = personGender
        self.supports = supports
        self.isActive = 0
    }

    init(id : String,
         userId: String,
         title : String,
         description : String,
         violenceKind : String,
         violenceAproximatedTime : Double,
         latitude : Double,
         longitude : Double,
         personGender: String,
         supports: Int,
         isActive: Int) {
        
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.violenceKind = violenceKind
        self.violenceAproximatedTime = violenceAproximatedTime
        self.latitude = latitude
        self.longitude = longitude
        self.personGender = personGender
        self.supports = supports
        self.isActive = isActive
    }

    init(id : String,
         userId: String,
         title : String,
         description : String,
         violenceKind : String,
         violenceAproximatedTime : Double,
         latitude : Double,
         longitude : Double,
         personGender: String,
         isActive: Int) {
        
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.violenceKind = violenceKind
        self.violenceAproximatedTime = violenceAproximatedTime
        self.latitude = latitude
        self.longitude = longitude
        self.personGender = personGender
        self.isActive = isActive
        self.supports = 0
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
        self.supports = 0
        self.isActive = 0
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
            "personGender" : personGender,
            "supports" : supports,
            "isActive" : isActive
        ]
    }

}
