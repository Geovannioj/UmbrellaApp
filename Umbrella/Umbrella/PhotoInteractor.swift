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

extension User {

    static func createPhoto(photo: Photo) {
        let ref = Database.database().reference()
        
        let photoRef = ref.child("photo").child(ref.childByAutoId().key)
        photoRef.setValue(photo.toAnyObject())
        
        // Add user to realm
        try! AppRealm.instance.write {
            AppRealm.instance.add(photo)
        }
    }
    
    static func getPhotos() -> [Photo] {
        let photoRef = Database.database().reference().child("photo")
        var photos = [Photo]()
        
        photoRef.observe(.value, with: { (snapshot) in
            
            let photosDic = snapshot.value as! [String : Any]
            let photo = Photo()
            photo.id = photosDic["id"] as! String
            photo.url = photosDic["url"] as! String
            photos.append(photo)
        })
        
        return photos
    }

    static func updatePhoto(id: String, url: String) {
        let photoRef = Database.database().reference().child("photo").child(id)
        let photo = Photo()
        photo.id = id
        photo.url = url
        photoRef.updateChildValues(photo.toAnyObject() as! [AnyHashable : Any])
        
        let photoRealm = AppRealm.instance.objects(Photo.self).filter("id == %s", id).first
        
        try! AppRealm.instance.write {
            photoRealm?.url = url
        }
    }
    
    static func deletePhoto(idPhoto: String) {
        let photoRef = Database.database().reference().child("photo").child(idPhoto)
        photoRef.removeValue()
        
        let photoRealm = AppRealm.instance.objects(Photo.self).filter("id == %s", idPhoto).first
        
        try! AppRealm.instance.write {
            AppRealm.instance.delete(photoRealm!)
        }
    }
}
