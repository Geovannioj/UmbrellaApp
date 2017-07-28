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

class RegisterReportViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate  {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var violenceKindOption: UIPickerView!
    @IBOutlet weak var violencelatitude: UITextField!
    @IBOutlet weak var violenceLongitude: UITextField!
    @IBOutlet weak var violenceDescription: UITextView!
    @IBOutlet weak var violenceFinishTime: UIDatePicker!
    @IBOutlet weak var violenceStartTime: UIDatePicker!
    @IBOutlet weak var violenceDate: UIDatePicker!
    @IBOutlet weak var reportButton: UIButton!
    
    //Mark: acessories
    
    var refReports : FIRDatabaseReference!
    let violenceKindArray = ["Verbal","Física","Moral","Psicológica","LGBTQ+fobia","Sexual"]
    var violenceKindChosen : String = ""
    
    override func viewDidLoad() {
        self.refReports =  FIRDatabase.database().reference().child("reports")
        super.viewDidLoad()
        self.violenceKindOption.dataSource = self
        self.violenceKindOption.delegate = self
        
        //getting a reference to the node artists
        

        
    }
    
    // MARK: - Acion
    @IBAction func registerReport(_ sender: Any) {
        
        let description = self.violenceDescription.text
        var violenceKind = self.violenceKindChosen
        let userStatus = "victim"
        let violenceStartTime = self.violenceStartTime.date
        let violenceFinishTime = self.violenceFinishTime.date
        let violenceDate = self.violenceDate.date
        let latitude = Double(self.violencelatitude.text!)
        let longitude = Double(self.violenceLongitude.text!)
        
        
        let report = Report(description: description!, violenceKind: violenceKind,
                            userStatus: userStatus, violenceStartTime: violenceStartTime,
                            violenceFinishTime: violenceFinishTime, latitude: latitude!,
                            longitude: longitude!,violenceDate: violenceDate)
        
        let reportRef = self.refReports.child("report")
        
        
        reportRef.setValue(report.turnToDictionary())
        
        
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return violenceKindArray.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return violenceKindArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.violenceKindChosen = violenceKindArray[row]
    }
    
}
