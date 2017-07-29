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
    let image = UIImage(named: "CustomLocationPIN")
    
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
        addPoint(image: image!)
    }
    func addPoint(image:UIImage) {
       // let imagePin = UIView(frame: CGRect(x: mapView.center.x, y: mapView.center.y, width: 5, height: 5))
        let imageView = UIImageView(image: image)
       // imageView.center = mapView.center
        imageView.center = CGPoint(x: mapView.center.x, y: (mapView.center.y - imageView.frame.height/2))
        self.view.addSubview(imageView)
       // imagePin.backgroundColor = UIColor.cyan
       // self.view.addSubview(imagePin)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
           // configLocationManager(locationManager: locationManager)
            locationManager.startUpdatingLocation()
            centerOnUser()
            
            
        }
    }
    
}

    
    

