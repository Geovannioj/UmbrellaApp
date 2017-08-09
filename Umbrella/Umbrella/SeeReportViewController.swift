//
//  SeeReportViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 31/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Mapbox
class SeeReportViewController: UIViewController {
    
    @IBOutlet weak var agression: UILabel!
    @IBOutlet weak var editReportBtn: UIButton!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var violanceLocation: MGLMapView!
    @IBOutlet weak var violenceAproximateTime: UILabel!
    @IBOutlet weak var violenceDescription: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var report:Report?
    let map = MapViewController()
    var refReports: DatabaseReference!
    override func viewDidLoad() {
        self.refReports =  Database.database().reference().child("reports")
        super.viewDidLoad()
        
        initLabels()
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        
    }
    
    func initLabels() {
        self.agression.text = self.report?.violenceKind
        self.violenceDescription.text = self.report?.description
        self.violenceDescription.isEditable = false
        self.username.text = "Joelson"
        self.cityName.text = "Taguayork"
        self.initiateLocationOnMap(map: self.violanceLocation, latitude: (report?.latitude)!, longitude: (report?.longitude)!)
        self.formatDate()
    }
    
    func initiateLocationOnMap(map: MGLMapView,latitude: Double, longitude: Double) {
        
      var location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        map.setCenter(location, zoomLevel: 13, animated: true)
        
        map.showsUserLocation = false
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (self.report?.latitude)!, longitude: (self.report?.longitude)! )
        annotation.title = self.report?.title
        self.violanceLocation.addAnnotation(annotation)

    }
    
    func formatDate () {
        //getting the data to format the date
        let startDate = Date(timeIntervalSince1970: (self.report?.violenceAproximatedTime)!)
        
        //format
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm"
        
        //setting the formated date
        self.violenceAproximateTime.text = dateFormat.string(from: startDate)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editReport" {
            if let editScreen = segue.destination as? RegisterReportViewController {
                editScreen.reportToEdit = self.report
            }
        }
    }

    
    
    @IBAction func editReport(_ sender: Any) {
        performSegue(withIdentifier: "editReport", sender: Any?.self)
    }
    
    @IBAction func deleteReport(_ sender: Any) {
        
        let deleteWarning = UIAlertController(title: "Delete",
                                              message: "Are you sure you want to delete it?",
                                              preferredStyle: .alert)
        deleteWarning.addAction(UIAlertAction(title: "Delete", style: .destructive,
                                              handler: { (action) in
                                                
                                                let reportToDelete = self.report?.id
                                                self.map.reports.remove(at: self.getReportIndexInArray(report: self.report!))
                                                self.refReports.child(reportToDelete!).setValue(nil)
        }))
        
        
        deleteWarning.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,
                                              handler:nil))
        
        self.present(deleteWarning, animated: true, completion: nil)

    }
    
    func getReportIndexInArray(report: Report) -> Int {
        
        var counter = 0
        
        for report in self.map.reports {
            if report.id == self.map.reports[counter].id {
                return counter
            } else {
                counter += 1
            }
            
        }
        //if there is an error it will crash because the report was not found and a negative value was returned 
        return -1
    }

}
