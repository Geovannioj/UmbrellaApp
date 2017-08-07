//
//  RegisterReportSecondViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 04/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterReportSecondViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    @IBOutlet weak var violenceAgressionLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var personIdentificationLbl: UILabel!
    @IBOutlet weak var violenceDescription: UITextView!
    @IBOutlet weak var violenceKind: UIPickerView!
    @IBOutlet weak var personIdentification: UIPickerView!
    
    //options to the picker view
    let violenceKindArray = ["Verbal","Física","Moral","Psicológica","Sexual"]
    
    let victimIdentificationArray = ["Lesbica",
                                    "Gay",
                                    "Bisexual",
                                    "Travesti",
                                    "Transgênero",
                                    "Transexual",
                                    "Queer",
                                    "outros"]
    
    //atributes to of the second screen
    var violenceKindChosen: String = ""
    var personIdentificationChosen: String = ""
    
    //report to be edited
    var reportToEdit: Report?
    
    //database reference
    var refReports: DatabaseReference!
    
    //atributes from the frist string
    var violenceTitle: String?
    var aproximatedTime:Double?
    var latitude:Double?
    var longitude: Double?
    
    
    override func viewDidLoad() {
        self.refReports =  Database.database().reference().child("reports")
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        self.violenceAgressionLbl.setValue(UIColor.white, forKey: "textColor")
        self.descriptionLbl.setValue(UIColor.white, forKey: "textColor")
        self.personIdentificationLbl.setValue(UIColor.white, forKey: "textColor")
        
        
        if (reportToEdit != nil) {
            
            initFieldsToEdit()
    
            self.violenceKindChosen = (reportToEdit?.violenceKind)!
            
        } else {
            
            self.violenceKind.selectRow(2, inComponent: 0, animated: true)
            self.violenceKindChosen = self.violenceKindArray[0]
            
            self.personIdentification.selectedRow(inComponent: 0)
            self.personIdentificationChosen = self.victimIdentificationArray[0]
        }
        
        self.personIdentification.dataSource = self
        self.personIdentification.delegate = self
        self.personIdentification.accessibilityIdentifier = "personIdentification"
        self.personIdentification.setValue(UIColor.white, forKey: "textColor")
        
        
        self.violenceKind.dataSource = self
        self.violenceKind.delegate = self
        self.violenceKind.accessibilityIdentifier = "violenceKind"
        self.violenceKind.setValue(UIColor.white, forKey: "textColor")
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

    @IBAction func registerReport(_ sender: Any) {
        
        if (self.reportToEdit != nil) {
            
            editReport(reportToEdit: self.reportToEdit!)
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            
            addReport()
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }

    func initFieldsToEdit() {
        
        self.violenceDescription.text = reportToEdit?.description
        self.violenceKind.selectRow(getViolenceKind(report: self.reportToEdit!),
                                    inComponent: 0,
                                    animated: true)
        
    }

    
    func addReport() {
        
                let id = refReports.childByAutoId().key
                let userId = "userIdComing"
                let title = self.violenceTitle
                let description = self.violenceDescription.text
                let violenceKind = self.violenceKindChosen
                let personGender = self.personIdentificationChosen
                let violenceAproximatedTime = self.aproximatedTime
        
                let latitude = self.latitude
                let longitude = self.longitude
        
                let report = Report(id: id, userId: userId, title: title!, description: description!, violenceKind: violenceKind, violenceAproximatedTime: Double(violenceAproximatedTime!), latitude: latitude!, longitude: longitude!, personGender: personGender)
        print(report.turnToDictionary())
        
               self.refReports.child(id).setValue(report.turnToDictionary())
       
        let saveMessage = UIAlertController(title: "Report saved",
                                              message: "This report has been successfully saved",
                                              preferredStyle: .alert)
        saveMessage.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,
                                              handler: nil))
        
        self.present(saveMessage, animated: true, completion: nil)
    }
    
    func editReport(reportToEdit: Report){
        
        //        let title = self.violencetitle.text
        //        let description = self.violenceDescription.text
        //        let violenceKind = self.violenceKindChosen
        //        let violenceAproximatedTime = Double(self.violenceAproximatedTime.date.timeIntervalSince1970)
        //        let latitude = self.violencelatitude.text!
        //        let longitude = self.violenceLongitude.text!
        //
        //        let report =  [
        //            "id" : reportToEdit.id,
        //            "userId" : reportToEdit.userId,
        //            "title" : title,
        //            "description" : description,
        //            "violenceKind" : violenceKind,
        //            "violenceAproximatedTime" : violenceAproximatedTime,
        //            "latitude" : latitude,
        //            "longitude" : longitude
        //        ] as [String : Any]
        //
        //        self.refReports.child(reportToEdit.id).setValue(report)
        
        let updateMessage = UIAlertController(title: "Report Updated",
                                              message: "This report has been successfully updated",
                                              preferredStyle: .alert)
        updateMessage.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,
                                              handler: nil))
        
        self.present(updateMessage, animated: true, completion: nil)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        if (self.reportToEdit != nil) {
            
            editReport(reportToEdit: self.reportToEdit!)
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            
            addReport()
            self.navigationController?.popToRootViewController(animated: true)
        }

    }
    
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.accessibilityIdentifier == "violenceKind" {
            
            return violenceKindArray.count
        
        }else {
            
            return self.victimIdentificationArray.count
        }
        
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.accessibilityIdentifier == "violenceKind" {
            
            return violenceKindArray[row]
            
        }else {
            
            return victimIdentificationArray[row]
            
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.accessibilityIdentifier == "violenceKind" {
            
           self.violenceKindChosen = violenceKindArray[row]
            
        }else {
            
            self.personIdentificationChosen = victimIdentificationArray[row]
            
        }
        
        
    }

    
}
