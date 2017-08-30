//
//  RegisterReportSecondTableViewController.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 24/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//
import Foundation
import UIKit
import Firebase

@IBDesignable
class RegisterReportSecondTableViewController: UITableViewController, UIPickerViewDataSource,UIPickerViewDelegate {


        
        @IBOutlet weak var scrollViewMainVIew: UIScrollView!
        @IBOutlet weak var violenceAgressionLbl: UILabel!
        @IBOutlet weak var descriptionLbl: UILabel!
        @IBOutlet weak var personIdentificationLbl: UILabel!
        @IBOutlet weak var violenceDescription: UITextView!
        @IBOutlet weak var violenceKind: UIPickerView!
        @IBOutlet weak var personIdentification: UIPickerView!
        @IBOutlet weak var addBtn: UIButton!
        @IBOutlet weak var keyBoardConstraint: NSLayoutConstraint!
        
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
        var refMessageReport: DatabaseReference!
        var refUserSupport: DatabaseReference!
        
        //atributes from the frist string
        var violenceTitle: String?
        var aproximatedTime:Double?
        var latitude:Double?
        var longitude: Double?
        
    @IBInspectable var color:UIColor = UIColor(){
        didSet{
            self.tableView.backgroundColor = color
            
            let footer = self.tableView.subviews.first { (view) -> Bool in
                view.restorationIdentifier == "Footer"
            }
            footer?.backgroundColor =  color
        }
    }
        override func viewDidLoad() {
            self.refReports =  Database.database().reference().child("reports")
            self.refMessageReport = Database.database().reference().child("user-reports")
            self.refUserSupport = Database.database().reference().child("user-support")
            
            super.viewDidLoad()
            
//            NotificationCenter.default.addObserver(self,
//                                                   selector: #selector(self.keyboardNotification(notification:)),
//                                                   name: NSNotification.Name.UIKeyboardWillChangeFrame,
//                                                   object: nil)
            
            dismissKayboardInTapGesture()
            
            
            self.tableView.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
            let footer = self.tableView.subviews.first { (view) -> Bool in
                view.restorationIdentifier == "Footer"
            }
            footer?.backgroundColor =  UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
            
            self.violenceAgressionLbl.setValue(UIColor.white, forKey: "textColor")
            self.descriptionLbl.setValue(UIColor.white, forKey: "textColor")
            self.personIdentificationLbl.setValue(UIColor.white, forKey: "textColor")
            
            
            self.violenceDescription.delegate = self
            self.violenceDescription.text = "Digite a descrição da agressão"
            self.violenceDescription.textColor = UIColor.lightGray
            
            if (reportToEdit == nil) {
                
                self.violenceKind.selectRow(2, inComponent: 0, animated: true)
                self.violenceKindChosen = self.violenceKindArray[(violenceKindArray.count - 1)]
                
                self.personIdentificationChosen = self.victimIdentificationArray[(victimIdentificationArray.count - 1)]
                
            }
            
            self.personIdentification.dataSource = self
            self.personIdentification.delegate = self
            self.personIdentification.accessibilityIdentifier = "personIdentification"
            
            
            
            self.violenceKind.dataSource = self
            self.violenceKind.delegate = self
            self.violenceKind.accessibilityIdentifier = "violenceKind"
            

            
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (reportToEdit != nil) {
            
            initFieldsToEdit()
            
            self.violenceKindChosen = (reportToEdit?.violenceKind)!
            
        }
    }
        deinit {
            NotificationCenter.default.removeObserver(self)
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
    
    func getPersonIdentification(report: Report) -> Int {
        
        var counter: Int = 0
        
        for personIdentification in self.victimIdentificationArray {
            
            if personIdentification == report.personGender{
                return counter
            }
            counter += 1
        }
        
        return counter

    }
    
        func initFieldsToEdit() {
            
            self.violenceDescription.text = reportToEdit?.description
            self.violenceDescription.textColor = UIColor.black
            
            let violenceIndex = getViolenceKind(report: self.reportToEdit!)
            let personGender = getPersonIdentification(report: self.reportToEdit!)
            
            self.violenceKind.selectRow(violenceIndex,
                                        inComponent: 0,
                                        animated: true)
            
            self.personIdentification.selectRow(0, inComponent: 0, animated: true)

            
            self.addBtn.setTitle("Salvar alteração", for: .normal)
            
        }
        
        
    func addReport() {
        
        let id = refReports.childByAutoId().key
        let userId = UserInteractor.getCurrentUserUid()
        let title = self.violenceTitle
        let description = self.violenceDescription.text
        let violenceKind = self.violenceKindChosen
        let personGender = self.personIdentificationChosen
        let violenceAproximatedTime = self.aproximatedTime
        
        let latitude = self.latitude
        let longitude = self.longitude
        
        let report = Report(id: id,
                            userId: userId!,
                            title: title!,
                            description: description!,
                            violenceKind: violenceKind,
                            violenceAproximatedTime: Double(violenceAproximatedTime!),
                            latitude: latitude!,
                            longitude: longitude!,
                            personGender: personGender)
        
        self.refReports.child(id).setValue(report.turnToDictionary())
        
        // reference to the user-report table
        let ref = self.refMessageReport.child(userId!)
        ref.updateChildValues([id : 1])
        
        //reference to the user-support table
        let databaseRef = self.refUserSupport.child(id)
        databaseRef.updateChildValues([id : id])
        
        let saveMessage = UIAlertController(title: "Relato Salvo",
                                            message: "Relato salvo com sucesso",
                                            preferredStyle: .alert)
        
        saveMessage.addAction(UIAlertAction(title: "OK",
                                            style: UIAlertActionStyle.default,
                                            handler: {(action) in
                                                self.performSegue(withIdentifier: "backToMap", sender: Any.self)
        }))
        
        self.present(saveMessage, animated: true, completion: nil)
    }
        
        func editReport(reportToEdit: Report){
            
            let report =  [
                "id" : reportToEdit.id,
                "userId" : reportToEdit.userId,
                "title" : self.violenceTitle,
                "description" : self.violenceDescription.text,
                "violenceKind" : self.violenceKindChosen,
                "violenceAproximatedTime" : self.aproximatedTime,
                "personGender": self.personIdentificationChosen,
                "latitude" : self.latitude,
                "longitude" : self.longitude
                ] as [String : Any]
            
            self.refReports.child(reportToEdit.id).setValue(report)
            
            let updateMessage = UIAlertController(title: "Relato alterado",
                                                  message: "O relato foi alterado com sucesso",
                                                  preferredStyle: .alert)
            
            updateMessage.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,
                                                  handler: { (action) in
                                                    
                                                    self.performSegue(withIdentifier: "backToMap", sender: Any.self)
                                                    
            }))
            
            self.present(updateMessage, animated: true, completion: nil)
        }
        
        @IBAction func registerAction(_ sender: Any) {
            
            if (self.reportToEdit != nil) {
                
                editReport(reportToEdit: self.reportToEdit!)
                performSegue(withIdentifier: "backToMap", sender: Any.self)
            }else {
                addReport()
                performSegue(withIdentifier: "backToMap", sender: Any.self)
                
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
        
        func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            
            var attributedString: NSAttributedString!
            
            if pickerView.accessibilityIdentifier == "violenceKind" {
                attributedString = NSAttributedString(string: violenceKindArray[row],
                                                      attributes: [NSForegroundColorAttributeName : UIColor.white])
            } else {
                attributedString = NSAttributedString(string: victimIdentificationArray[row],
                                                      attributes: [NSForegroundColorAttributeName : UIColor.white])
            }
            
            return attributedString
        }
    }
    
    
    
    
    extension RegisterReportSecondTableViewController: UITextViewDelegate {
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
            
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                
                textView.text = "Insira seu comentário"
                textView.textColor = UIColor.lightGray
                
            }
        }
}
