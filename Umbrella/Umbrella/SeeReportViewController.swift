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
    var report:Report?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLabels()
        
    }
    
    func initLabels() {
        
        self.descriptionLbl.text = self.report?.description
        self.violenceKindLvl.text = self.report?.violenceKind
        self.latitudeLbl.text = self.report?.latitude
        self.longitudeLbl.text = self.report?.longitude
        formatDate()
    }
    
    func formatDate () {
        
        let startDate = Date(timeIntervalSince1970: (self.report?.violenceStartTime)!)
        let finishDate = Date(timeIntervalSince1970: (self.report?.violenceFinishTime)!)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm"
        
        self.violenceStartTime.text = dateFormat.string(from: startDate)
        self.violenceFinishTime.text = dateFormat.string(from: finishDate)
        
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
        
    }
}
