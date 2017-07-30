//
//  Report.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation

class Report {
    
    var id : String?
    var description : String
    var violenceKind : String
    var userStatus : String
    var violenceStartTime : String
    var violenceFinishTime : String
    var latitude : String
    var longitude : String
    
    init(id : String, description : String, violenceKind : String, userStatus : String,
         violenceStartTime : String, violenceFinishTime : String, latitude : String,
         longitude : String) {
        
        self.id = id
        self.description = description
        self.violenceKind = violenceKind
        self.userStatus = userStatus
        self.violenceStartTime = violenceStartTime
        self.violenceFinishTime = violenceFinishTime
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
//    init(description : String, violenceKind : String, userStatus : String,
//         violenceStartTime : Date, violenceFinishTime : Date, latitude : Double,
//         longitude : Double) {
//        
//        self.description = description
//        self.violenceKind = violenceKind
//        self.userStatus = userStatus
//        self.violenceStartTime = violenceStartTime
//        self.violenceFinishTime = violenceFinishTime
//        self.latitude = latitude
//        self.longitude = longitude
//    }

    func turnToDictionary() -> Any {
        
        
        return [
            "id" : id,
            "description" : description,
            "violenceKind" : violenceKind,
            "userStatus" : userStatus,
            "violenceStartTime" : violenceStartTime,
            "violenceFinishTime" : violenceFinishTime,
            "latitude" : latitude,
            "longitude" : longitude
        ]
    }

}
