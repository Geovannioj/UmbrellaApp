//
//  MapViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 27/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Mapbox

class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizationStatusCheck()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
        
    func configLocationManager(locationManager:CLLocationManager){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
    }
    func authorizationStatusCheck(){
        if (CLLocationManager.authorizationStatus() != .authorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization()
            
        }else{
            configLocationManager(locationManager: locationManager)
        }
        
    }
    
    func centerOnUser(){
       // let camera = MGLMapCamera(lookingAtCenter: (mapView.userLocation?.coordinate)!, fromDistance: CLLocationDistance.init(exactly: 500)!, pitch: 5, heading: CLLocationDirection(exactly: 9)!)
       // mapView.setCamera(camera, animated: false)
        mapView.setCenter((locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
        mapView.showsUserLocation = true
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
           // configLocationManager(locationManager: locationManager)
            locationManager.startUpdatingLocation()
            centerOnUser()
        }
    }
    
}

    
    

