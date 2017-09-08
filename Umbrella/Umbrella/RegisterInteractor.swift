//
//  RegisterInteractor.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 30/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import Firebase

class RegisterInteractor: RegisterInteractorProtocol {
    
    weak var output: RegisterInteractorOutputProtocol!
    
    /**
     Function responsable for creating an authentication for an user and save his data on a server and local database.
     - parameter nickname: user's nickname
     - parameter email: user's email
     - parameter password: user's password
     - parameter image: user's profile photo
     - parameter handler: deals with errors and completes sign in actions
     */
    func createUser(nickname: String, email: String, password: String, image: UIImage?) {
        
        // Add user to firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            // Treatment in case of user creation error
            if error != nil {
                self.dealWithError(error)
                return
            }
            
            // Fill an instance of the user with data
            let newUser = UserEntity()
            newUser.id = (user?.uid)!
            newUser.nickname = nickname
            newUser.email = email
            
            // Reference of the user table in firebase
            let userRef = Database.database().reference().child("user").child(String(newUser.id))
            
            if image != nil {
                
                self.createPhoto(image: image!, completion: { (photo) -> () in
                    newUser.urlPhoto = photo
                    
                    // Add user to local database
                    SaveManager.instance.create(newUser)
                    // Add user to firebase
                    userRef.setValue(newUser.toAnyObject())
                    self.output.completeCreate()
                })
                
            } else {
                // Add user to local database
                SaveManager.instance.create(newUser)
                // Add user to firebase
                userRef.setValue(newUser.toAnyObject())
                self.output.completeCreate()
            }
            
            // Save the password on the keychain
            //KeychainService.savePassword(service: "Umbrella-Key", account: newUser.id, data: password)
        }
    }
    
    /**
     Function responsable for alocate a photo in the server and local database.
     - parameter image: an UIImage that will be saved on the databases
     - parameter handler: deals with errors and completes photo operation actions
     - parameter completion: completion that returns the url of the photo saved
     */
    func createPhoto(image: UIImage, completion: @escaping (String?) -> ()) {
        let photo = PhotoEntity()
        
        photo.id = UUID().uuidString + ".jpg"
        
        let ref = Storage.storage().reference().child("userPhotos").child("\(photo.id)")
        if let uploadData = image.data() {
            
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                // Treatment in case of photo alocation error
                if error != nil {
                    self.dealWithError(error)
                    return
                }
                
                if let url = metadata?.downloadURL()?.absoluteString {
                    
                    photo.image = uploadData
                    photo.url = url
                    
                    // Add photo to local database
                    SaveManager.instance.create(photo)
                    
                    completion(url)
                }
            })
        }
    }
    
    // -TODO: Write a formal email verification on firebase options and test this method
    /**
     Sends an email verification to the user's email
     - parameter handler: deals with errors
     */
    func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            
            if error != nil {
                self.dealWithError(error)
            }
        })
    }
    
    func dealWithError(_ error : Error!) {
        
        if let errCode = AuthErrorCode(rawValue: error._code) {
            
            
            
            switch errCode {
            case .invalidEmail:
                output.fetched("Email inválido", field: .email)
                
            case .emailAlreadyInUse:
                output.fetched("Email já cadastrado", field: .email)
                
            case .weakPassword:
                output.fetched("Senha deve possuir pelo menos 6 caracteres", field: .password)
                
            case .networkError:
                output.fetched("Verifique sua conexão com a internet", field: nil)
                
            case .invalidUserToken, .userTokenExpired:
                output.fetched("Sessão expirada", field: nil)

            default:
                output.fetched("Ocorreu um erro, tente novamente mais tarde", field: nil)
            }
        }
    }
    

    
}
