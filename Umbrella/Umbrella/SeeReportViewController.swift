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

class SeeReportViewController: UIViewController {
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var violenceKindLvl: UILabel!
    @IBOutlet weak var violenceStartTime: UILabel!
    @IBOutlet weak var violenceFinishTime: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var agression: UILabel!
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var violanceLocation: MKMapView!
    @IBOutlet weak var violenceAproximateTime: UILabel!
    
    @IBOutlet weak var violenceDescription: UITextView!
    var report:Report?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLabels()
        
    }
    
    func initLabels() {
        
//        self.descriptionLbl.text = self.report?.description
//        self.violenceKindLvl.text = self.report?.violenceKind
        
        self.agression.text = self.report?.violenceKind
        self.violenceDescription.text = self.report?.description
        self.violenceDescription.isEditable = false
        self.username.text = "Joelson"
        self.cityName.text = "Taguayork"
        self.formatDate()
    }
    
    func formatDate () {
        //getting the data to format the date
        let startDate = Date(timeIntervalSince1970: (self.report?.violenceAproximatedTime)!)
        
        //format
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm"
        
        //setting the formated date
        self.violenceAproximateTime.text = dateFormat.string(from: startDate)
        //self.violenceStartTime.text = dateFormat.string(from: startDate)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "editReport" {
//            if let editScreen = segue.destination as? RegisterReportViewController {
//                editScreen.reportToEdit = self.report
//            }
//        }
    }
    @IBAction func editReport(_ sender: Any) {
        //performSegue(withIdentifier: "editReport", sender: Any?.self)
    }
    
    @IBAction func deleteReport(_ sender: Any) {
        
    }
}
