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
    var reportPosition : Bool = false
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapDelegate = MapViewDelegate(mapView: mapView, view: self.view)
        //Adiiona observer para authorização do GPS
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
    
  
    //Objetivo: Função para centrar no usuario quando ocorre o request do GPS.
    func centerOnUser(){
        mapView.setCenter((locationDelegate.locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
        mapView.showsUserLocation = true
    }
    //Objetivo:Instanciar uma view com a imagem fornecida no centro do mapa .
    func addPoint(image:UIImage) {
        let view = self.view.subviews.first { (i) -> Bool in
            i.restorationIdentifier == "pinPoint"
        }
        if view != nil {
            view?.removeFromSuperview()
            
        }else{
            let imageView = UIImageView(image: image)
            
            imageView.center = CGPoint(x: mapView.center.x, y: (mapView.center.y - imageView.frame.height/2))
            imageView.restorationIdentifier = "pinPoint"
            self.view.addSubview(imageView)
        }
        
  
    }
    
    @IBAction func addCenterAction(_ sender: Any) {
        addPoint(image: UIImage(named: "Shape")!)
    }
    
    @IBAction func heatMapButton(_ sender: UIButton) {
        mapDelegate.heatAction()
        
    }
    @IBAction func pinAction(_ sender: UIButton) {
        mapDelegate.addPin()
        
        if reportPosition {
          performSegue(withIdentifier: "backToRegister", sender: Any.self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToRegister"{
            if let backToRegisterReport = segue.destination as? RegisterReportViewController {
                
                backToRegisterReport.reportLatitude = mapDelegate.latitude
                backToRegisterReport.reportLongitude = mapDelegate.longitude
                print(mapDelegate.latitude)
                print(mapDelegate.longitude)
            }
        }
    }
}

    
    

