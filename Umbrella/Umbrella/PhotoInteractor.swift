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

extension User {

    static func createPhoto(image: UIImage, completion comp: @escaping (String?) -> ()) {
        let photo = Photo()
        
        photo.id = UUID().uuidString
        
        let ref = Storage.storage().reference().child("userPhotos").child("\(photo.id).jpg")
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
    
//    static func getPhotos() -> [Photo] {
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

//    static func updatePhoto(id: String, url: String) {
//        let photoRef = Database.database().reference().child("photo").child(id)
//        let photo = Photo()
//        photo.id = id
//        photo.url = url
//        photoRef.updateChildValues(photo.toAnyObject() as! [AnyHashable : Any])
//        
//        let photoRealm = AppRealm.instance.objects(Photo.self).filter("id == %s", id).first
//        
//        try! AppRealm.instance.write {
//            photoRealm?.url = url
//        }
//    }
//    
//    static func deletePhoto(idPhoto: String) {
//        let photoRef = Database.database().reference().child("photo").child(idPhoto)
//        photoRef.removeValue()
//        
//        let photoRealm = AppRealm.instance.objects(Photo.self).filter("id == %s", idPhoto).first
//        
//        try! AppRealm.instance.write {
//            AppRealm.instance.delete(photoRealm!)
//        }
//    }
}
