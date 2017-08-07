//
//  RegisterReportViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 27/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Mapbox

class RegisterReportViewController: UIViewController  {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var violenceLocation: MGLMapView!
    @IBOutlet weak var violenceTitle: UITextField!
    @IBOutlet weak var violenceAproximatedTime: UIDatePicker!
    @IBOutlet weak var nexttButton: UIButton!
    
    
    //Mark: acessories
    let locationDelegate = LocationManagerDelegate()
    var reportLatitude = Double()
    var reportLongitude = Double()
    
    var reportToEdit : Report?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.violenceAproximatedTime.setValue(UIColor.white, forKeyPath: "textColor")
        getLocation(image: UIImage(named: "Shape")!)
        if (reportToEdit != nil) {
            initFieldsToEdit()
        }
        
        self.view.backgroundColor = UIColor.black

        
        
    }
    
        
    func initFieldsToEdit() {
        
        self.violenceTitle.text = reportToEdit?.title
        self.violenceAproximatedTime.date = Date(timeIntervalSince1970: (self.reportToEdit?.violenceAproximatedTime)!)
    }

    // MARK: - Acion
      
    @IBAction func ChangeScreenAction(_ sender: Any) {
        
        if (self.violenceTitle != nil && self.violenceAproximatedTime.date <= Date()) {
            
            performSegue(withIdentifier: "goToSecondRegisterView", sender: Any.self)
        
        }else {
            
            //apresentar labels de validação
        
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondRegisterView" {
            if let secondScreen = segue.destination as? RegisterReportSecondViewController {
                
                secondScreen.latitude = self.reportLatitude
                secondScreen.longitude = self.reportLongitude
                secondScreen.aproximatedTime = self.violenceAproximatedTime.date.timeIntervalSince1970
                secondScreen.violenceTitle = self.violenceTitle.text
                
            }
        }
    }
    
    
    func getLocation (image:UIImage) {
      violenceLocation.setCenter((locationDelegate.locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
        violenceLocation.showsUserLocation = true
        
        let view = self.view.subviews.first { (i) -> Bool in
            i.restorationIdentifier == "pinPoint"
        }
        if view != nil {
            view?.removeFromSuperview()
            
        }else{
            let imageView = UIImageView(image: image)
            
            imageView.center = CGPoint(x: violenceLocation.center.x, y: (violenceLocation.center.y - imageView.frame.height/2))
            imageView.restorationIdentifier = "pinPoint"
            self.view.addSubview(imageView)
        }


        let reportPin = MGLPointAnnotation()
        reportPin.coordinate = CLLocationCoordinate2D(latitude: violenceLocation.camera.centerCoordinate.latitude, longitude: violenceLocation.camera.centerCoordinate.longitude)
        
        violenceLocation.addAnnotation(reportPin)
        
        self.reportLatitude = violenceLocation.camera.centerCoordinate.latitude
        self.reportLongitude = violenceLocation.camera.centerCoordinate.longitude
        print(self.reportLongitude)
        print(self.reportLatitude)
    }
    
        
}
