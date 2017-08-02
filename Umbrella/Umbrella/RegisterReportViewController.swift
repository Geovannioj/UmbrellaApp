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
    @IBOutlet weak var reportButton: UIButton!
    
    //Mark: acessories
    
    var refReports : DatabaseReference!
    let violenceKindArray = ["Verbal","Física","Moral","Psicológica","LGBTQ+fobia","Sexual"]
    var violenceKindChosen : String = ""
    var reportToEdit : Report?
    var reportLatitude = Double()
    var reportLongitude = Double()
    
    
    override func viewDidLoad() {
        self.refReports =  Database.database().reference().child("reports")

        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fundo_cadastro")!)
        self.violencelatitude.text = String(self.reportLatitude)
        self.violenceLongitude.text = String(self.reportLongitude)

        super.viewDidLoad()
        
        
        if (reportToEdit != nil) {
            
            initFieldsToEdit()
            self.reportButton.setTitle("Save", for: .normal)
            self.violenceKindChosen = (reportToEdit?.violenceKind)!
            
        } else {
            
            self.violenceKindOption.selectRow(2, inComponent: 0, animated: true)
            self.violenceKindChosen = self.violenceKindArray[0]
        }
        
        self.violenceKindOption.dataSource = self
        self.violenceKindOption.delegate = self
        
        


        
    }
    
    func getViolenceKind(report: Report) -> Int {
        
        var counter: Int = 0
        
        for violenceKind in self.violenceKindArray {
            
            if violenceKind == report.violenceKind{
                return counter
            }
            counter += 1
        }
        
        return counter
    }
    
    func initFieldsToEdit() {
        self.violencelatitude.text = self.reportToEdit?.latitude
        self.violenceLongitude.text = self.reportToEdit?.longitude
        self.violenceDescription.text = self.reportToEdit?.description
        self.violenceKindOption.selectRow(getViolenceKind(report: self.reportToEdit!),
                                          inComponent: 0, animated: true)
        self.violenceFinishTime.date = Date(timeIntervalSince1970: (self.reportToEdit?.violenceFinishTime)!)
        self.violenceStartTime.date = Date(timeIntervalSince1970: (self.reportToEdit?.violenceStartTime)!)
        
    }
    // MARK: - Acion
    @IBAction func registerReport(_ sender: Any) {

        if (self.reportToEdit != nil) {
            
            editReport(reportToEdit: self.reportToEdit!)
            self.navigationController?.popToRootViewController(animated: true)
        }else {
        
            addReport()
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    @IBAction func goToMapBtn(_ sender: Any) {
        performSegue(withIdentifier: "goToMap", sender: Any.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMap" {
            if let nextScreen = segue.destination as? MapViewController {
                nextScreen.reportPosition = true
            }
        }
    }
    func addReport() {
        
        let id = refReports.childByAutoId().key
        let userId = "userIdComing"
        let description = self.violenceDescription.text
        let violenceKind = self.violenceKindChosen
        let userStatus = "victim"
        let violenceStartTime = Int(self.violenceStartTime.date.timeIntervalSince1970) //
        let violenceFinishTime = Int(self.violenceFinishTime.date.timeIntervalSince1970) //
        let latitude = self.violencelatitude.text!
        let longitude = self.violenceLongitude.text!
        
        let report = Report(id: id, userId: userId, description: description!, violenceKind: violenceKind, userStatus: userStatus, violenceStartTime: Double(violenceStartTime), violenceFinishTime: Double(violenceFinishTime), latitude: latitude, longitude: longitude)
        

        self.refReports.child(id).setValue(report.turnToDictionary())
    }
    
    func editReport(reportToEdit: Report){
        
        let description = self.violenceDescription.text
        let violenceKind = self.violenceKindChosen
        let userStatus = "victim"
        let violenceStartTime = Double(self.violenceStartTime.date.timeIntervalSince1970)
        let violenceFinishTime = Double(self.violenceFinishTime.date.timeIntervalSince1970)
        let latitude = self.violencelatitude.text!
        let longitude = self.violenceLongitude.text!
        
        let report =  [
            "id" : reportToEdit.id,
            "userId" : reportToEdit.userId,
            "description" : description,
            "violenceKind" : violenceKind,
            "userStatus" : userStatus,
            "violenceStartTime" : violenceStartTime,
            "violenceFinishTime" : violenceFinishTime,
            "latitude" : latitude,
            "longitude" : longitude
        ] as [String : Any]
        
        self.refReports.child(reportToEdit.id).setValue(report)
        
        let updateMessage = UIAlertController(title: "Report Updated",
                                              message: "This report has been successfully updated",
                                              preferredStyle: .alert)
        updateMessage.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,
                                              handler: nil))
        
        self.present(updateMessage, animated: true, completion: nil)
    }
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
