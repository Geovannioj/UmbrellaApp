//
//  AlertPresenter.swift
//  Umbrella
//
//  Created by Bruno Chagas on 15/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class AlertPresenter {
    
    func showAlert(viewController: UIViewController, title: String, message: String, confirmButton: String?, cancelButton: String?, onAffirmation:  @escaping (Void) -> (Void) = { }) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if confirmButton != nil {
            alertView.addAction(UIAlertAction(title: confirmButton, style: .default, handler: { (action) in
                onAffirmation()
            }))
        }
        
        if cancelButton != nil {
            alertView.addAction(UIAlertAction(title: cancelButton, style: .default, handler: nil))
        }
        
        viewController.present(alertView, animated: true, completion: nil)
    }

}
