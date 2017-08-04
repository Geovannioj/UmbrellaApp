//
//  MapViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 27/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController {
    override func viewDidLoad() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        User.createUser(nickname: "BrunoAgoraRealm", email: "bruno@mail.com", password: "123456", birthDate: nil, image: #imageLiteral(resourceName: "turn-off"), idMinority: "-KqTAOwPUvqs0f_sbVeP")
//        User.createUser(nickname: "Jonas", email: "jonas@mail.com", password: "123456", age: 21, photo: photo, idMinority: "-KqTAOwPUvqs0f_sbVeP")
//        User.createUser(nickname: "Eduardo", email: "eduardo@mail.com", password: "123456", age: 21, photo: photo, idMinority: "-KqTAOwPUvqs0f_sbVeP")
//        User.createUser(nickname: "Geovanni", email: "geovanni@mail.com", password: "123456", age: 21, photo: photo, idMinority: "-KqTAOwPUvqs0f_sbVeP")
//        User.createUser(nickname: "Osmala", email: "osmala@mail.com", password: "123456", age: 21, photo: photo, idMinority: "-KqTAOwPUvqs0f_sbVeP")
//        User.createUser(nickname: "Marquinhos", email: "marquinhos@mail.com", password: "123456", age: 21, photo: photo, idMinority: "-KqTAOwPUvqs0f_sbVeP")
        
        
        //User.updateUser(id: "bf9qpLxCJnP1K3VIigAGmonqzs82", nickname: "bruno")
    }
}
