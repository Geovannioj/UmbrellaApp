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

protocol ReportDelegate {
    func changeBannerVisibility()
    func changeBlurViewVisibility()
    func getFirstPopup() -> UIView
    func getSecondPopup() -> UIView
    func getReportPopup() -> UIView
    func closeReport()
    func getChildViewControllers() -> [UIViewController]
    func getMapViewController() -> UIViewController
    func getGestures() -> [UIGestureRecognizer]
}

class RegisterReportViewController: UIViewController, UISearchBarDelegate {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var violenceLocation: MGLMapView!
    @IBOutlet weak var violenceTitle: UITextField!
    @IBOutlet weak var violenceAproximatedTime: UIDatePicker!
    @IBOutlet weak var nexttButton: UIButton!
    @IBOutlet weak var validateTitleError: UILabel!
    @IBOutlet weak var validateDateError: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Mark: acessories
    let locationManager = CLLocationManager()
    var reportLatitude: Double = 0.0
    var reportLongitude: Double = 0.0
    
    var reportToEdit : Report?
    
    var delegate: ReportDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set map delegate to self
        violenceLocation.delegate = self
        
        dismissKayboardInTapGesture()
        
        //sets the color background to dark purple
        self.view.backgroundColor = .clear
        
        // it makes the font color of the datePicker turn to white
        
        self.violenceAproximatedTime.setValue(UIColor.white, forKeyPath: "textColor")
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            //center the camera on the user location
            centerCamera(image: UIImage(named: "indicador_crime")!)
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
        
        searchBarConfig()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if searchBar.isFirstResponder == false {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    self.delegate?.getFirstPopup().center = CGPoint(x: (self.delegate?.getFirstPopup().center.x)!, y: (self.delegate?.getMapViewController().view.center.y)! - keyboardHeight)
                }, completion: nil)
            }
            nexttButton.isEnabled = false
            pageControl.isEnabled = false
            for gesture in (delegate?.getGestures())! {
                gesture.isEnabled = false
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.delegate?.getFirstPopup().center = CGPoint(x: (self.delegate?.getFirstPopup().center.x)!, y: (self.delegate?.getMapViewController().view.center.y)!)
        }, completion: nil)
        nexttButton.isEnabled = true
        pageControl.isEnabled = true
        for gesture in (delegate?.getGestures())! {
            gesture.isEnabled = true
        }
    }
    
    func searchBarConfig(){
        searchBar.delegate = self
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.clear
    }
    
    //initiates the fields if there is a report to be edited
    func initFieldsToEdit() {
        
        self.violenceTitle.text = reportToEdit?.title
        self.violenceAproximatedTime.date = Date(timeIntervalSince1970: (self.reportToEdit?.violenceAproximatedTime)!)
    }

    // MARK: - Acion
      
    @IBAction func ChangeScreenAction(_ sender: Any) {
            
        getLocation()
        //performSegue(withIdentifier: "goToSecondRegisterView", sender: Any.self)

//            for case let secondScreen as RegisterReportSecondViewController in (delegate?.getChildViewControllers())! {
//
//            }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.delegate?.getFirstPopup().center = CGPoint(x: (self.delegate?.getMapViewController().view.center.x)! - (self.delegate?.getMapViewController().view.frame.size.width)!, y: (self.delegate?.getFirstPopup().center.y)!)
            self.delegate?.getSecondPopup().center = CGPoint(x: (self.delegate?.getMapViewController().view.center.x)!, y: (self.delegate?.getSecondPopup().center.y)!)
        } , completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToSecondRegisterView" {
//            if let secondScreen = segue.destination as? RegisterReportSecondViewController {
//                
//                secondScreen.latitude = self.reportLatitude
//                secondScreen.longitude = self.reportLongitude
//                secondScreen.aproximatedTime = self.violenceAproximatedTime.date.timeIntervalSince1970
//                secondScreen.violenceTitle = self.violenceTitle.text
//                
//            }
//        }
//    }
    
    func centerCamera(image: UIImage) {
        
        violenceLocation.setCenter((locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
        violenceLocation.showsUserLocation = true

//            let imageView = UIImageView(image: image)
//            
//            imageView.center = CGPoint(x: (violenceLocation.center.x), y: (violenceLocation.center.y - imageView.frame.height/2))
//            imageView.restorationIdentifier = "pinPoint"
//            self.view.addSubview(imageView)
//            
//        //}
        
    }
    
    func getLocation () {
        
        self.reportLatitude = self.violenceLocation.centerCoordinate.latitude//violenceLocation.camera.centerCoordinate.latitude
        self.reportLongitude = self.violenceLocation.centerCoordinate.longitude//
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.delegate?.closeReport()
        //dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pageValueChanged(_ sender: UIPageControl) {
        if sender.currentPage == 1 {
            ChangeScreenAction(nexttButton)
        }
    }
    
        
}


extension RegisterReportViewController: FirstReportScreenDelegate {
    func getViolenceTitle() -> UITextField {
        return self.violenceTitle
    }
    
    func getViolenceAproximatedTime() -> UIDatePicker {
        return self.violenceAproximatedTime
    }
    
    func getLatitude() -> Double {
        return self.reportLatitude
    }
    
    func getLongitude() -> Double {
        return self.reportLongitude
    }
    
    func incompleteTasksError() {
        self.validateTitleError.isHidden = true
        self.validateDateError.isHidden = true

        if (violenceTitle.text?.isEmpty)! {
            self.validateTitleError.isHidden = false
        }
        if violenceAproximatedTime.date > Date() {
            self.validateDateError.isHidden = false
        }
    }
}
