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

class RegisterReportViewController: UIViewController  {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var violenceLocation: MKMapView!
    @IBOutlet weak var violenceTitle: UITextField!
    @IBOutlet weak var violenceAproximatedTime: UIDatePicker!
    @IBOutlet weak var nexttButton: UIButton!
    
    
    //Mark: acessories

    var reportLatitude = Double()
    var reportLongitude = Double()
    
    var reportToEdit : Report?
    
    
    override func viewDidLoad() {
        
        self.violenceAproximatedTime.setValue(UIColor.white, forKeyPath: "textColor")
        
        if (reportToEdit != nil) {
            initFieldsToEdit()
        }
        
        self.view.backgroundColor = UIColor.black

        super.viewDidLoad()
        
    }
    
        
    func initFieldsToEdit() {
        
        self.violenceTitle.text = reportToEdit?.title
        self.violenceAproximatedTime.date = Date(timeIntervalSince1970: (self.reportToEdit?.violenceAproximatedTime)!)
    }

    // MARK: - Acion
      
    @IBAction func ChangeScreenAction(_ sender: Any) {
        
        if (self.violenceTitle != nil && self.violenceAproximatedTime.date <= Date()) {
            
            performSegue(withIdentifier: "goToSecondRegisterView", sender: Any.self)
        
        }else {
            
            //apresentar labels de validação
        
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondRegisterView" {
            if let secondScreen = segue.destination as? RegisterReportSecondViewController {
                
                secondScreen.latitude = self.reportLatitude
                secondScreen.longitude = self.reportLongitude
                secondScreen.aproximatedTime = self.violenceAproximatedTime.date.timeIntervalSince1970
                secondScreen.violenceTitle = self.violenceTitle.text
                
            }
        }
    }
    
        
}
