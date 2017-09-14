//
//  PhotoInteractor.swift
//  Umbrella
//
//  Created by Bruno Chagas on 31/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase
import FirebaseStorage
import FirebaseAuth

class PhotoInteractor {

    /**
     Function responsable for alocate a photo in the server and local database.
     - parameter image: an UIImage that will be saved on the databases
     - parameter handler: deals with errors and completes photo operation actions
     - parameter completion: completion that returns the url of the photo saved
     */
    static func createPhoto(image: UIImage, handler: InteractorCompleteProtocol, completion completionHandler: @escaping (String?) -> ()) {
        let photo = PhotoEntity()
        
        photo.id = UUID().uuidString + ".jpg"
        
        let ref = Storage.storage().reference().child("userPhotos").child("\(photo.id)")
        if let uploadData = image.data() {
            
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                // Treatment in case of photo alocation error
                if error != nil {
                    handler.completePhotoOperation!(error: error)
                    return
                }
                
                if let url = metadata?.downloadURL()?.absoluteString {
                    
                    photo.image = uploadData
                    photo.url = url
                    
                    // Add photo to local database
                    SaveManager.instance.create(photo)
                    
                    completionHandler(url)
                }
            })
        }
    }
    
    /**
     Gets user photo from the local database if there is one.
     */
    static func getCurrentUserPhoto() -> PhotoEntity? {
        if let userId = Auth.auth().currentUser?.uid {
            if let urlPhoto = SaveManager.realm.objects(UserEntity.self).filter("id == %s", userId).first?.urlPhoto {
                
                if let photo = SaveManager.realm.objects(PhotoEntity.self).filter("url == %s", urlPhoto).first {
                    return photo
                }
            }
        }

        return nil
    }

    /**
     Function responsable for returning a photo giving an especific url.
     - parameter url: desired photo's url
     - parameter handler: deals with errors and completes photo operation actions
     - parameter completion: returns the desired photo if it founds
     */
    static func getUserPhoto(withUrl url: String, handler: InteractorCompleteProtocol?, completion: @escaping (PhotoEntity?) -> ()) {
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 1 * 1024 * 1024 * 3) { (data, error) -> Void in
            if (error != nil) {
                if (handler != nil) {
                    handler?.completePhotoOperation!(error: error)
                }
            } else {
                let photo = PhotoEntity()
                photo.url = url
                photo.image = data
                
                completion(photo)
            }
        }
        completion(nil)
    }
    
    /**
     Function responsable for switching the user's photo in the server and local database with a new one.
     - parameter image: an UIImage that will be saved on the databases
     - parameter handler: deals with errors and completes photo operation actions
     */
    static func updateCurrentUserPhoto(image: UIImage, handler: InteractorCompleteProtocol) {
        
        deleteCurrentUserPhoto(handler: handler)
        createPhoto(image: image, handler: handler, completion: {(urlPhoto) -> () in
            UserInteractor.updateCurrentUser(urlPhoto: urlPhoto!)
        })
    }
    

    /**
     Function responsable for deleting the user's photo in the server and local database.
     - parameter photoHandler: deals with errors and completes photo operation actions
     */
    static func deleteCurrentUserPhoto(handler: InteractorCompleteProtocol) {
        if let userId = UserInteractor.getCurrentUserUid() {

            let urlRef = Database.database().reference().child("user").child(userId).child("urlPhoto")
            urlRef.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                if snapshot.value is NSNull {
                }
                else {
                    let photoRef = Storage.storage().reference(forURL: snapshot.value as! String)
                    let idRef = photoRef.name
                    
                    photoRef.delete(completion: { (error) in
                        if let err = error {
                            handler.completePhotoOperation!(error: err)
                        }
                        else {
                            UserInteractor.updateCurrentUser(urlPhoto: "")
                            
                            let photoRealm = SaveManager.realm.objects(PhotoEntity.self).filter("id == %s", idRef).first
                            
                            try! SaveManager.realm.write {
                                SaveManager.realm.delete(photoRealm!)
                            }
                        }
                    })
                }
            })
        }
    }
}
