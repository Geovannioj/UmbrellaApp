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

class PhotoInteractor {

    /**
     Function responsable for alocate a photo in the server and local database.
     - parameter image: an UIImage that will be saved on the databases
     - parameter comp: completion that returns the url of the photo saved
     */
    static func createPhoto(image: UIImage, completion comp: @escaping (String?) -> ()) {
        let photo = Photo()
        
        photo.id = UUID().uuidString + ".jpg"
        
        let ref = Storage.storage().reference().child("userPhotos").child("\(photo.id)")
        if let uploadData = image.data() {
            
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let url = metadata?.downloadURL()?.absoluteString {
                    
                    photo.image = uploadData
                    photo.url = url
                    
                    // Add photo to local database
                    SaveManager.instance.create(photo)
                    
                    comp(url)
                }
                
            })
        }
    }
    
//    static func getUserPhoto() -> Photo {
//        if let userId = Auth.auth().currentUser?.uid {
//            
//        }
//
//        
//        let photoRef = Database.database().reference().child("photo")
//        var photos = [Photo]()
//        
//        photoRef.observe(.value, with: { (snapshot) in
//            if snapshot.value is NSNull {
//                print("Photos not found")
//                return
//            }
//            
//            for child in snapshot.children {
//                let photo = Photo()
//                let snap = child as! DataSnapshot
//                let dict = snap.value as! [String : Any]
//                
//                photo.id = dict["id"] as! String
//                photo.image = photosDic["url"] as! String
//                photos.append(photo)
//
//            }
//            
//        })
//        
//        return photos
//    }

    /**
     Function responsable for switching the user's photo in the server and local database with a new one.
     - parameter image: an UIImage that will be saved on the databases
     */
    static func updateUserPhoto(image: UIImage) {
        
        deleteUserPhoto()
        createPhoto(image: image, completion: {(urlPhoto) -> () in
            UserInteractor.updateCurrentUser(urlPhoto: urlPhoto!)
        })
    }
    

    /**
     Function responsable for deleting the user's photo in the server and local database.
     */
    static func deleteUserPhoto() {
        if let userId = Auth.auth().currentUser?.uid {

            let urlRef = Database.database().reference().child("user").child(userId).child("urlPhoto")
            urlRef.observe(.value, with: { (snapshot: DataSnapshot) in
                if snapshot.value is NSNull {
                }
                else {
                    let photoRef = Storage.storage().reference(forURL: snapshot.value as! String)
                    let idRef = photoRef.name
                    
                    photoRef.delete(completion: { (error) in
                        if let err = error {
                            print(err)
                        }
                        else {
                            UserInteractor.updateCurrentUser(urlPhoto: "")
                            
                            let photoRealm = SaveManager.realm.objects(Photo.self).filter("id == %s", idRef).first
                            
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
