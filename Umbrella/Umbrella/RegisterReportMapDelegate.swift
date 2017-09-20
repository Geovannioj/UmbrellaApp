//
//  RegisterReportMapDelegate.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 14/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import Mapbox

extension RegisterReportViewController: MGLMapViewDelegate{
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // Customise the user location annotation view
        if annotation is MGLUserLocation {
            var userLocationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomUserLocationAnnotationViewIdentifier") as? CustomUserLocationView
            
            if userLocationAnnotationView == nil {
                userLocationAnnotationView = CustomUserLocationView(reuseIdentifier: "CustomUserLocationAnnotationViewIdentifier")
                userLocationAnnotationView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                
            }
            
         
            
            return userLocationAnnotationView
        }
        return nil
        
    }
    
}
