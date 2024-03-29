//
//  RegisterReportTableViewController.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 24/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Mapbox

@IBDesignable
class RegisterReportTableViewController: UITableViewController {

 
        
        
        // MARK: - Outlets
        
    @IBOutlet weak var violenceLocation: MGLMapView!
    @IBOutlet weak var violenceTitle: UITextField!
    @IBOutlet weak var violenceAproximatedTime: UIDatePicker!
    @IBOutlet weak var nexttButton: UIButton!
    @IBOutlet weak var validateTitleError: UILabel!
    @IBOutlet weak var validateDateError: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
        
        //Mark: acessories
        let locationManager = CLLocationManager()
        var reportLatitude: Double = 0.0
        var reportLongitude: Double = 0.0
        
        var reportToEdit : Report?
        
//    @IBInspectable var color:UIColor = UIColor(){
//        didSet{
//            self.tableView.backgroundColor = color
//        }
//    }
        override func viewDidLoad() {
            super.viewDidLoad()
            
            dismissKayboardInTapGesture()
            
            //setts the collor background to dark purple
            //self.view.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
            self.tableView.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
            
            // it makes the font color of the datePicker turn to white
            
            self.violenceAproximatedTime.setValue(UIColor.white, forKeyPath: "textColor")
            
            //center the camera on the user location
            if self.reportToEdit == nil {
                
                centerCamera()
            
            } else {
             
                setMapLocation(location: violenceLocation, latitude: (reportToEdit?.latitude)!, longitude: (reportToEdit?.longitude)!)
            }
            
            
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
        
        //initiates the fields if there is a report to be edited
        func initFieldsToEdit() {
            
            self.violenceTitle.text = reportToEdit?.title
            self.violenceAproximatedTime.date = Date(timeIntervalSince1970: (self.reportToEdit?.violenceAproximatedTime)!)
        }
        
        // MARK: - Acion
        
        @IBAction func ChangeScreenAction(_ sender: Any) {
            
            if (!(self.violenceTitle.text?.isEmpty)!) {
                
                if self.violenceAproximatedTime.date <= Date(){
                    
                    getLocation()
                    performSegue(withIdentifier: "goToSecondRegisterView", sender: Any.self)
                
                    self.validateDateError.isHidden = true
                
                } else {
                    
                    self.validateDateError.isHidden = false
                }
                
                self.validateTitleError.isHidden = true
            
            }else if (self.violenceTitle.text?.isEmpty)! {
                
                self.validateTitleError.isHidden = false
                self.validateDateError.isHidden = true
                
            }else if self.violenceAproximatedTime.date >= Date() {
                
                self.validateDateError.isHidden = false
                self.validateTitleError.isHidden = false
                
            }
        }
    @IBAction func closeAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToSecondRegisterView" {
                if let secondScreen = segue.destination as? RegisterReportSecondTableViewController {
                    
                    secondScreen.latitude = self.reportLatitude
                    secondScreen.longitude = self.reportLongitude
                    secondScreen.aproximatedTime = self.violenceAproximatedTime.date.timeIntervalSince1970
                    secondScreen.violenceTitle = self.violenceTitle.text
                    
                    if self.reportToEdit != nil {
                        secondScreen.reportToEdit = self.reportToEdit
                    }
                    
                }
            }
        }
        
        func centerCamera() {
            
            violenceLocation.setCenter((locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
            violenceLocation.showsUserLocation = true
            
        }
    
    func setMapLocation(location:MGLMapView, latitude: Double, longitude: Double) {
        
        let locationCoodenate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        location.setCenter(locationCoodenate, zoomLevel: 13, animated: true)
        
        location.showsUserLocation = false
        
    }

    func getLocation () {
            
            self.reportLatitude = violenceLocation.camera.centerCoordinate.latitude
            self.reportLongitude = violenceLocation.camera.centerCoordinate.longitude
            
        }
        
        
    }




