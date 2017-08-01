//
//  MapViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 27/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

class MapViewController: UIViewController {
    
    let image = UIImage(named: "CustomLocationPIN")
    let locationDelegate = LocationManagerDelegate()
    var mapDelegate = MapViewDelegate()
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapDelegate = MapViewDelegate(mapView: mapView, view: self.view)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.centerOnUser),
            name:NSNotification.Name.init(rawValue: "AuthorizationAccepted"),
            object: nil
        )
        
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
  
    
    func centerOnUser(){
       // let camera = MGLMapCamera(lookingAtCenter: (mapView.userLocation?.coordinate)!, fromDistance: CLLocationDistance.init(exactly: 500)!, pitch: 5, heading: CLLocationDirection(exactly: 9)!)
       // mapView.setCamera(camera, animated: false)
        mapView.setCenter((locationDelegate.locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
        mapView.showsUserLocation = true
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
    
    @IBAction func heatMapButton(_ sender: UIButton) {
        mapDelegate.heatAction()
        
    }
    @IBAction func pinAction(_ sender: UIButton) {
        mapDelegate.addPin()
        
    }
    
}

    
    

