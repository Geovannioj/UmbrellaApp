//
//  ProfileViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 13/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit

class ProfileManagerViewController: UIViewController {
    


    @IBOutlet weak var profile: UIView!
    @IBOutlet weak var settings: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subView.backgroundColor = UIColor(patternImage: UIImage(named: "bkgRegisterView")!)
        
        self.reportView.isHidden = true
        self.settings.isHidden = true
        self.profile.isHidden = false
    }
    @IBAction func manageSegmentedControl(_ sender: Any) {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.profile.isHidden = false
            self.settings.isHidden = true
            self.reportView.isHidden = true
        case 1:
            self.profile.isHidden = true
            self.settings.isHidden = true
            self.reportView.isHidden = false
            
        case 2:
            self.profile.isHidden = true
            self.settings.isHidden = false
            self.reportView.isHidden = true
        default:
            break
        }
    }
}
