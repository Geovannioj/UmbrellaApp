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
    @IBOutlet weak var validateTitleError: UILabel!
    @IBOutlet weak var validateDateError: UILabel!
    
    
    //Mark: acessories
    let locationManager = CLLocationManager()
    var reportLatitude: Double = 0.0
    var reportLongitude: Double = 0.0
    
    var reportToEdit : Report?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        
        //setts the collor background to dark purple
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        
        // it makes the font color of the datePicker turn to white
        
        self.violenceAproximatedTime.setValue(UIColor.white, forKeyPath: "textColor")
        
        //center the camera on the user location
        centerCamera(image: UIImage(named: "indicador_crime")!)
        
        //hides the errors labels and turn their font color to white
        self.validateDateError.isHidden = true
        self.validateDateError.setValue(UIColor.white, forKey: "textColor")
        self.validateTitleError.isHidden = true
        self.validateTitleError.setValue(UIColor.white, forKey: "textColor")
        
        
        //checks if there is a report to edit or a new one to be created
        
        if (reportToEdit != nil) {
            initFieldsToEdit()
        }
        
        
    }
   
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    //initiates the fields if there is a report to be edited
    func initFieldsToEdit() {
        
        self.violenceTitle.text = reportToEdit?.title
        self.violenceAproximatedTime.date = Date(timeIntervalSince1970: (self.reportToEdit?.violenceAproximatedTime)!)
    }

    // MARK: - Acion
      
    @IBAction func ChangeScreenAction(_ sender: Any) {
        
        if (!(self.violenceTitle.text?.isEmpty)! && self.violenceAproximatedTime.date <= Date()) {
            
            getLocation()
            performSegue(withIdentifier: "goToSecondRegisterView", sender: Any.self)
        
        }else {
            
            self.validateDateError.isHidden = false
            self.validateTitleError.isHidden = false
        
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
    
    func centerCamera(image: UIImage) {
        
        violenceLocation.setCenter((locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
        violenceLocation.showsUserLocation = true

            let imageView = UIImageView(image: image)
            
            imageView.center = CGPoint(x: (violenceLocation.center.x), y: (violenceLocation.center.y ))
            imageView.restorationIdentifier = "pinPoint"
            self.view.addSubview(imageView)
        //}
        
    }
    func getLocation () {
        
        self.reportLatitude = violenceLocation.camera.centerCoordinate.latitude
        self.reportLongitude = violenceLocation.camera.centerCoordinate.longitude
        
    }
    
        
}
