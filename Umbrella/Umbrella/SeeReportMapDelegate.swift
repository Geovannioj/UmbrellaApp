//
//  SeeReportMapDelegate.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 14/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import Mapbox

extension ReportTableViewController:MGLMapViewDelegate{
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            // If there’s no reusable annotation view available, initialize a new one.
            if annotationView == nil {
                annotationView = AgressionPinAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView!.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                
                
            }
            
            annotationView?.contentMode = .scaleAspectFit
            return annotationView
            
        
        // Customise your annotation view here...
        
        }
}
