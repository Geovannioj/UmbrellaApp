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
    


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profile: UIView!
    @IBOutlet weak var settings: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundImage(named: "bkgChatView")
        
        
        self.reportView.isHidden = true
        self.settings.isHidden = true
        self.profile.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        let image: UIImageView = UIImageView(image: #imageLiteral(resourceName: "bkgChatView"))
        image.alpha = 0.1
        navigationController?.navigationBar.setBackgroundImage(image.image, for: .default)
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "perfilAsset"))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(handleEdit))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(r: 170, g: 10, b: 234)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(handleEdit))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(r: 170, g: 10, b: 234)
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
    
    func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleEdit() {
        
    }
}
