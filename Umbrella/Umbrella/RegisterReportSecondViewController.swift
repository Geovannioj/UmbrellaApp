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

protocol FirstReportScreenDelegate {
    func getViolenceTitle() -> UITextField
    func getViolenceAproximatedTime() -> UIDatePicker
    func getLatitude() -> Double
    func getLongitude() -> Double
    func incompleteTasksError()
}


class RegisterReportSecondViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    @IBOutlet weak var violenceAgressionLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var personIdentificationLbl: UILabel!
    @IBOutlet weak var violenceDescription: UITextView!
    @IBOutlet weak var violenceKind: UIPickerView!
    @IBOutlet weak var personIdentification: UIPickerView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let alert = AlertPresenter()
    
    //options to the picker view
    
    var delegate: ReportDelegate?
    var firstReportScreenDelegate: FirstReportScreenDelegate?
    
    //atributes to of the second screen
    var personIdentificationChosen: MinorityEntity = MinorityEntity()
    var minorities: [MinorityEntity] = []
    var violenceKindChosen: FilterEntity = FilterEntity()
    var violences: [FilterEntity] = []
    
    //report to be edited
    var reportToEdit: Report?
    
    //database reference
    var refReports: DatabaseReference!
    var refMessageReport: DatabaseReference!
    var refUserSupport: DatabaseReference!
    
    
    override func viewDidLoad() {
        self.refReports =  Database.database().reference().child("reports")
        self.refMessageReport = Database.database().reference().child("user-reports")
        self.refUserSupport = Database.database().reference().child("user-support")
        super.viewDidLoad()
        
        for case let firstScreen as RegisterReportViewController in (delegate?.getChildViewControllers())! {
            self.firstReportScreenDelegate = firstScreen
        }
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.keyboardNotification(notification:)),
//                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
//                                               object: nil)
        
        dismissKayboardInTapGesture()
        

        self.view.backgroundColor = .clear
        
        self.violenceAgressionLbl.setValue(UIColor.white, forKey: "textColor")
        self.descriptionLbl.setValue(UIColor.white, forKey: "textColor")
        self.personIdentificationLbl.setValue(UIColor.white, forKey: "textColor")
        self.violenceDescription.layer.cornerRadius = 6
        
        if (reportToEdit != nil) {
            
            initFieldsToEdit()
    
            //self.violenceKindChosen = (reportToEdit?.violenceKind)!
            
        } else {
            
            self.violenceKind.selectRow(2, inComponent: 0, animated: true)
            
            
            self.personIdentification.selectedRow(inComponent: 0)
            
        }
        
        MinorityInteractor.getMinorities(completion: { minoritiesFirebase in
            self.minorities.append(contentsOf: minoritiesFirebase)
            self.personIdentification.dataSource = self
            self.personIdentification.delegate = self
            self.personIdentification.accessibilityIdentifier = "personIdentification"
            self.personIdentificationChosen = self.minorities[(self.minorities.count - 1)]
        })
        
        FilterInteractor.getFilters(completion: { violencesFirebase in
            self.violences.append(contentsOf: violencesFirebase)
            self.violenceKind.accessibilityIdentifier = "violenceKind"
            self.violenceKind.dataSource = self
            self.violenceKind.delegate = self
            self.violenceKindChosen = self.violences[(self.violences.count - 1)]
        })
        
        
        self.violenceDescription.delegate = self
        self.violenceDescription.text = "Digite a descrição da agressão"
        self.violenceDescription.textColor = UIColor.lightGray
        
        self.addBtn.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.delegate?.getSecondPopup().center = CGPoint(x: (self.delegate?.getSecondPopup().center.x)!, y: (self.delegate?.getMapViewController().view.center.y)! - keyboardHeight)
            }, completion: nil)
            backButton.isEnabled = false
            addBtn.isEnabled = false
            pageControl.isEnabled = false
            for gesture in (delegate?.getGestures())! {
                gesture.isEnabled = false
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.delegate?.getSecondPopup().center = CGPoint(x: (self.delegate?.getSecondPopup().center.x)!, y: (self.delegate?.getMapViewController().view.center.y)!)
        }, completion: nil)
        backButton.isEnabled = true
        addBtn.isEnabled = true
        pageControl.isEnabled = true
        for gesture in (delegate?.getGestures())! {
            gesture.isEnabled = true
        }
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
//    @objc func keyboardNotification(notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//            
//            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
//            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
//            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
//            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
//            
////            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
////                
////                self.keyBoardConstraint?.constant = 0.0
////                
////            } else {
////                
////                self.keyBoardConstraint?.constant = endFrame?.size.height ?? 0.0
////                let point = CGPoint(x: 0, y: 200) // 200 or any value you like.
////                self.scrollViewMainVIew.contentOffset = point
////
////            }
//            
//            UIView.animate(withDuration: duration,
//                           delay: TimeInterval(0),
//                           options: animationCurve,
//                           animations: { self.view.layoutIfNeeded() },
//                           completion: nil)
//            
//        }
//    }
    
    func getViolenceKind(report: Report) -> Int {
        
        var counter: Int = 0
        
        for violenceKind in self.violences {
            
            if violenceKind.type == report.violenceKind{
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
        let title = self.firstReportScreenDelegate?.getViolenceTitle().text
        let description = self.violenceDescription.text
        let violenceKind = self.violenceKindChosen.type
        let personGender = self.personIdentificationChosen.type
        let violenceAproximatedTime = self.firstReportScreenDelegate?.getViolenceAproximatedTime().date.timeIntervalSince1970
        
        let latitude = self.firstReportScreenDelegate?.getLatitude()
        let longitude = self.firstReportScreenDelegate?.getLongitude()
        
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
        }))
        
        self.present(saveMessage, animated: true, completion: nil)
    }
    
    func editReport(reportToEdit: Report){
        
                let report =  [
                    "id" : reportToEdit.id,
                    "userId" : reportToEdit.userId,
                    "title" : self.firstReportScreenDelegate?.getViolenceTitle(),
                    "description" : self.violenceDescription.text,
                    "violenceKind" : self.violenceKindChosen,
                    "violenceAproximatedTime" : self.firstReportScreenDelegate?.getViolenceAproximatedTime(),
                    "personGender": self.personIdentificationChosen,
                    "latitude" : self.firstReportScreenDelegate?.getLatitude(),
                    "longitude" : self.firstReportScreenDelegate?.getLongitude()
                ] as [String : Any]
        
                self.refReports.child(reportToEdit.id).setValue(report)
        
        alert.showAlert(viewController: (delegate?.getMapViewController())!, title: "Report Updated", message: "This report has been successfully updated", confirmButton: nil, cancelButton: "OK")
        
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if (!(self.firstReportScreenDelegate?.getViolenceTitle().text?.isEmpty)! &&
            (self.firstReportScreenDelegate?.getViolenceAproximatedTime().date)! <= Date()) {
            
            if (self.reportToEdit != nil) {
                editReport(reportToEdit: self.reportToEdit!)
                closeButtonAction(sender)
            }else {
                
                addReport()
                closeButtonAction(sender)
            }
        }
        else{
            firstReportScreenDelegate?.incompleteTasksError()
            backButtonAction(backButton)
        }
        

    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.delegate?.getFirstPopup().center = CGPoint(x: (self.delegate?.getMapViewController().view.center.x)!, y: (self.delegate?.getFirstPopup().center.y)!)
            self.delegate?.getSecondPopup().center = CGPoint(x: (self.delegate?.getMapViewController().view.center.x)! + (self.delegate?.getMapViewController().view.frame.size.width)!, y: (self.delegate?.getSecondPopup().center.y)!)
        }, completion: nil)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.delegate?.closeReport()
        //dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pageValueChanged(_ sender: UIPageControl) {
        if sender.currentPage == 0 {
            backButtonAction(backButton)
        }
    }
    
    
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.accessibilityIdentifier == "violenceKind" {
            
            return violences.count
        
        }else {
            
            return self.minorities.count
        }
        
    }
    
    //MARK: Delegates
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        
//        if pickerView.accessibilityIdentifier == "violenceKind" {
//            
//            return violenceKindArray[row]
//            
//        }else {
//            
//            return minorities[row].type
//            
//        }
//        
//        
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.accessibilityIdentifier == "violenceKind" {
            
           self.violenceKindChosen = violences[row]
            
        }else {
            
            self.personIdentificationChosen = minorities[row]
            
        }
        
        
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attributedString: NSAttributedString!
        
        if pickerView.accessibilityIdentifier == "violenceKind" {
                attributedString = NSAttributedString(string: violences[row].type,
                                                      attributes: [NSForegroundColorAttributeName : UIColor.white])
        } else {
                attributedString = NSAttributedString(string: minorities[row].type,
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

