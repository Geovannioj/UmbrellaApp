//
//  ImagePickerController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 30/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

protocol ImagePickerRouterProtocol : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func removePicture()
}

class ImagePickerRouter {
    
    func showSelectOptions(_ view: UIViewController, presenter: ImagePickerRouterProtocol) {
        
        let chooseAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        chooseAction.addAction(UIAlertAction(title: "Tirar Foto", style: .default, handler:{_ in
            self.presentPicker(view : view, type : .camera, presenter : presenter)
        }))
        
        chooseAction.addAction(UIAlertAction(title: "Escolher Foto", style: .default, handler:{_ in
            self.presentPicker(view : view, type : .photoLibrary, presenter : presenter)
        }))
        
        chooseAction.addAction(UIAlertAction(title: "Remover Foto", style: .destructive, handler:{_ in
            presenter.removePicture()
        }))
        
        chooseAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        view.present(chooseAction, animated: true, completion: nil)
    }
    
    private func presentPicker(view : UIViewController, type : UIImagePickerControllerSourceType, presenter : ImagePickerRouterProtocol) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = presenter
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(type) {
            picker.sourceType = type
            view.present(picker, animated: true, completion: nil)
        }
    }
}

