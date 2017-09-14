//
//  ProfileViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 13/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit

class ProfileManagerViewController: UIViewController, ProfileDelegate {

    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var extendedNavBar: ExtendedNavBarView!
    @IBOutlet weak var profile: UIView!
    @IBOutlet weak var settings: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .default
        view.backgroundImage(named: "bkgChatView")
        extendedNavBar.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        
        self.reportView.isHidden = true
        self.settings.isHidden = true
        self.profile.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileContainerSegue" {
            let profileContainerViewController = segue.destination as! ProfileTableViewController
            profileContainerViewController.delegate = self
        }
    }
    
    func getNavBar() -> UINavigationItem {
        return self.navigationItem
    }
    
    func getSegmentedControl() -> UISegmentedControl {
        return self.segmentedControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navBar = navigationController?.navigationBar
        
        navBar?.isTranslucent = true
        navBar?.shadowImage = UIImage()
        
        let alphaView = UIView(frame: CGRect(x: 0, y: -20, width: (navigationController?.view.bounds.size.width)!, height: (navBar?.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height))
        alphaView.backgroundColor = .white
        alphaView.alpha = 0.5
        navBar?.addSubview(alphaView)
        navBar?.bringSubview(toFront: (navBar?.subviews.last)!)
        
        //navigationController?.view.addSubview(alphaView)
        //navigationController?.view.bringSubview(toFront: (navigationController?.view.subviews.last)!)
        
        //navBar?.addSubview(alphaView)
        //navBar?.bringSubview(toFront: (navBar?.subviews.last)!)
        
        navBar?.setBackgroundImage(#imageLiteral(resourceName: "bkgChatView"), for: .default)
        navBar?.tintColor = UIColor(r: 170, g: 10, b: 234)
        
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "perfilAsset"))
        navBar?.bringSubview(toFront: (navBar?.subviews.last)!)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(handleReturn))
        navBar?.bringSubview(toFront: (navBar?.subviews.last)!)
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: nil)
        //navBar?.bringSubview(toFront: (navBar?.subviews.last)!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func manageSegmentedControl(_ sender: Any) {
        
        if self.navigationItem.rightBarButtonItem?.title == "Pronto" {
            handleEdit()
        }
        
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.profile.isHidden = false
            self.settings.isHidden = true
            self.reportView.isHidden = true
            if let rightButton = getNavBar().rightBarButtonItem {
                rightButton.isEnabled = true
                rightButton.title = "Editar"
            }
        case 1:
            self.profile.isHidden = true
            self.settings.isHidden = true
            self.reportView.isHidden = false
            if let rightButton = getNavBar().rightBarButtonItem {
                rightButton.isEnabled = false
                rightButton.title = ""
            }
        case 2:
            self.profile.isHidden = true
            self.settings.isHidden = false
            self.reportView.isHidden = true
            if let rightButton = getNavBar().rightBarButtonItem {
                rightButton.isEnabled = false
                rightButton.title = ""
            }
        default:
            break
        }
    }
    
    func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleEdit() {
        let name = navigationItem.rightBarButtonItem?.title
        if name == "Editar" {
            navigationItem.rightBarButtonItem?.title = "Pronto"
        }
        else {
            navigationItem.rightBarButtonItem?.title = "Editar"
        }
    }
    
}
