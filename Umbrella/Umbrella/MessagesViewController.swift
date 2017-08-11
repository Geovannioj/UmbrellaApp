//
//  MessagesViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 09/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class MessagesViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(handleReturnHome))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(handleEditCells))
    }
    
    
    
    
    
    func handleReturnHome() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleEditCells() {
        //Editar celulas
        //Remover celulas
    }
}
