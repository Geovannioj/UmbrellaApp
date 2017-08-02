//
//  LocationManagerDelegate.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 29/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManagerDelegate: NSObject,CLLocationManagerDelegate {
     var locationManager = CLLocationManager()
   
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.authorizationStatusCheck()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
    }
    func authorizationStatusCheck(){
        if (CLLocationManager.authorizationStatus() != .authorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization()
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // configLocationManager(locationManager: locationManager)
            
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "AuthorizationAccepted"), object: self)
            
            
        }
    }

   
    
}
