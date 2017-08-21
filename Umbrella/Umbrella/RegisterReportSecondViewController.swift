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
    
    //atributes from the frist string
    var violenceTitle: String?
    var aproximatedTime:Double?
    var latitude:Double?
    var longitude: Double?
    
    
    override func viewDidLoad() {
        self.refReports =  Database.database().reference().child("reports")
        self.refMessageReport = Database.database().reference().child("user-reports")
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        
        dismissKayboardInTapGesture()
        

        self.view.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        
        self.violenceAgressionLbl.setValue(UIColor.white, forKey: "textColor")
        self.descriptionLbl.setValue(UIColor.white, forKey: "textColor")
        self.personIdentificationLbl.setValue(UIColor.white, forKey: "textColor")
        
        
        if (reportToEdit != nil) {
            
            initFieldsToEdit()
    
            self.violenceKindChosen = (reportToEdit?.violenceKind)!
            
        } else {
            
            self.violenceKind.selectRow(2, inComponent: 0, animated: true)
            self.violenceKindChosen = self.violenceKindArray[(violenceKindArray.count - 1)]
            
            self.personIdentification.selectedRow(inComponent: 0)
            self.personIdentificationChosen = self.victimIdentificationArray[(victimIdentificationArray.count - 1)]
        }
        
        self.personIdentification.dataSource = self
        self.personIdentification.delegate = self
        self.personIdentification.accessibilityIdentifier = "personIdentification"
        
        
        
        self.violenceKind.dataSource = self
        self.violenceKind.delegate = self
        self.violenceKind.accessibilityIdentifier = "violenceKind"
        
        self.violenceDescription.delegate = self
        self.violenceDescription.text = "Digite a descrição da agressão"
        self.violenceDescription.textColor = UIColor.lightGray
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                
                self.keyBoardConstraint?.constant = 0.0
                
            } else {
                
                self.keyBoardConstraint?.constant = endFrame?.size.height ?? 0.0
                let point = CGPoint(x: 0, y: 200) // 200 or any value you like.
                self.scrollViewMainVIew.contentOffset = point

            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
            
        }
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
        
        self.violenceDescription.text = reportToEdit?.description
        self.violenceKind.selectRow(getViolenceKind(report: self.reportToEdit!),
                                    inComponent: 0,
                                    animated: true)
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
            //
        
        //
                let report = Report(id: id, userId: userId!, title: title!, description: description!, violenceKind: violenceKind, violenceAproximatedTime: Double(violenceAproximatedTime!), latitude: latitude!, longitude: longitude!, personGender: personGender)
        print(report.turnToDictionary())
        
                self.refReports.child(id).setValue(report.turnToDictionary())
       
                let ref = self.refMessageReport.child(userId!)
                
                ref.updateChildValues([id : 1])
        
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
        
        let updateMessage = UIAlertController(title: "Report Updated",
                                              message: "This report has been successfully updated",
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

    


extension RegisterReportSecondViewController: UITextViewDelegate {
    
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

