//
//  PerfilViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 13/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var inputs: ProfileView!
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        //view.backgroundImage(named: "bkgRegisterView")
        setupInputs()
        setupUser()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isEdit == false {
            if indexPath.section == 0 && indexPath.row == 1 {
                return 0
            }
            if indexPath.section == 2 && indexPath.row == 1 {
                return 0
            }
            return 44
        }
        else {
            if indexPath.section == 1 && indexPath.row == 0 {
                return 0
            }
            if indexPath.section == 1 && indexPath.row == 1 {
                return 0
            }
            if indexPath.section == 2 && indexPath.row == 0 {
                return 0
            }
            return 44
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.cellForRow(at: IndexPath(row: 1, section: 1))?.isHidden = true
        self.tableView.cellForRow(at: IndexPath(row: 2, section: 1))?.isHidden = true
        print(tableView.cellForRow(at: IndexPath(row: 2, section: 1)) ?? "adfasd")
        self.tableView.reloadData()
    }
    func setupInputs() {
        
        inputs.translatesAutoresizingMaskIntoConstraints = false
        inputs.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        inputs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        inputs.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inputs.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    func setupUser(){
        
        guard let id = UserInteractor.getCurrentUserUid() else {
            return //Erro de usuario n logado
        }
        
        UserInteractor.getUser(withId: id, completion: { (user) in
            
            let dicty = user.toAnyObject() as! [String : Any]
            
            if let url = user.urlPhoto {
                self.inputs.profileImage.loadCacheImage(url)
            }
            
            self.inputs.username.text = dicty["nickname"] as? String
//            self.inputs.email.textLabel.text = dicty["email"] as? String
//            self.inputs.password.textLabel.text = "password"
//            self.inputs.birthDate.textLabel.text = dicty["birthDate"] as? String
//            self.inputs.minority.textLabel.text = dicty["idMinority"] as? String
            
        })
    }
    
    
}
