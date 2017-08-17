//
//  PerfilViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 13/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
//    @IBOutlet weak var inputs: ProfileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundImage(named: "bkgRegisterView")
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        setupInputs()
        setupUser()
    }

    func setupInputs() {
        
//        inputs.translatesAutoresizingMaskIntoConstraints = false
//        inputs.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        inputs.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3).isActive = true
//        inputs.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
//        inputs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
    }
    
    func setupUser(){
        
        guard let id = UserInteractor.getCurrentUserUid() else {
            return //Erro de usuario n logado
        }
        
        UserInteractor.getUser(withId: id, completion: { (user) in
            
//            let dicty = user.toAnyObject() as! [String : Any]
//            
//            if let url = user.urlPhoto {
//                self.inputs.profileImage.loadCacheImage(url)
//            }
//            
//            self.inputs.username.textField.text = dicty["nickname"] as? String
//            self.inputs.email.textField.text = dicty["email"] as? String
//            self.inputs.password.textField.text = "password"
//            self.inputs.birthDate.textField.text = dicty["birthDate"] as? String
//            self.inputs.minority.textField.text = dicty["idMinority"] as? String
            
        })
        
        
    }
}
