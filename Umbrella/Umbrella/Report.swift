//
//  Report.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation

class Report {
    
    var id : Int?
    var description : String
    var violenceKind : String
    var userStatus : String
    var violenceDate : Date
    var violenceStartTime : Date
    var violenceFinishTime : Date
    var latitude : Double
    var longitude : Double
    
    init(id : Int, description : String, violenceKind : String, userStatus : String,
         violenceStartTime : Date, violenceFinishTime : Date, latitude : Double,
         longitude : Double, violenceDate : Date) {
        
        self.id = id
        self.description = description
        self.violenceKind = violenceKind
        self.userStatus = userStatus
        self.violenceStartTime = violenceStartTime
        self.violenceFinishTime = violenceFinishTime
        self.latitude = latitude
        self.longitude = longitude
        self.violenceDate = violenceDate
    }
    
    init(description : String, violenceKind : String, userStatus : String,
         violenceStartTime : Date, violenceFinishTime : Date, latitude : Double,
         longitude : Double, violenceDate : Date) {
        
        self.description = description
        self.violenceKind = violenceKind
        self.userStatus = userStatus
        self.violenceStartTime = violenceStartTime
        self.violenceFinishTime = violenceFinishTime
        self.latitude = latitude
        self.longitude = longitude
        self.violenceDate = violenceDate
    }

    func turnToDictionary() -> Any {
        return [
            "description" : description,
            "violenceKind" : violenceKind,
            "userStatus" : userStatus,
            "violenceDate" : violenceDate,
            "violenceStartTime" : violenceStartTime,
            "violenceFinishTime" : violenceFinishTime,
            "latitude" : latitude,
            "longitude" : longitude
        ]
    }

}
