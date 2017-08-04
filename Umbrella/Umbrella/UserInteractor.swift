//
//  UserInteractor.swift
//  Umbrella
//
//  Created by Bruno Chagas on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class UserInteractor {
    
    // -TODO: Password cryptography and email validation
    static func createUser(nickname: String, email: String,
                           password: String, birthDate: Date?, image: UIImage?,
                            idMinority: String?) {
        
        // Add user to firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            // Treatment in case of error
            if error != nil {
                print(error!)
                return
            }
            
            let newUser = User()
            newUser.id = (user?.uid)!
            
            // Reference of the user table in firebase
            let userRef = Database.database().reference().child("user").child(String(newUser.id))
            
            // Fill an instance of the user with data
            
            newUser.nickname = nickname
            newUser.email = email
            newUser.password = password
            if birthDate != nil {
                newUser.birthDate = birthDate!
            }
            if idMinority != nil {
                newUser.idMinority = idMinority
            }
            if image != nil {
                PhotoInteractor.createPhoto(image: image!, completion: { (photo) -> () in
                    newUser.idPhoto = photo
                    
                    // Add user to local database
                    SaveManager.instance.create(newUser)
                    
                    userRef.setValue(newUser.toAnyObject())
                })
            }
            
            
            
            
            connectUser(email: email, password: password)
            
        }
    }
    
    // -TODO: Int is not accepted on dictionary
//    static func getUsers(completion: @escaping ([User]) -> ()) {
//        let userRef = Database.database().reference().child("user")
//        var users = [User]()
//        
//        userRef.observe(.childAdded, with: { (snapshot) in
//            if snapshot.value is NSNull {
//                print("Users not found")
//                return
//            }
//            
//            for child in snapshot.children {
//                let user = User()
//                let snap = child as! DataSnapshot
//                let dict = snap.value as! [String : Any]
//                
//                user.id = dict["id"] as! String
//                user.email = dict["email"] as! String
//                user.nickname = dict["nickname"] as! String
//                user.age = dict["age"] as! Int
//                user.idPhoto = dict["idPhoto"] as? String
//                user.idMinority = dict["idMinority"] as? String
//                users.append(user)
//            }
//            
//            completion(users)
//        })
//    }
    
    
    static func getUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
    
    static func isUserOnline(completion: @escaping (Bool) -> ()) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value != nil {
                completion(true)
            }
            else {
                completion(false)
            }
        })
    }
    
    static func getUser(withId id: String, completion: @escaping (User) -> ()) {
        let userRef = Database.database().reference().child("user").child(id)
        let user = User()
        
        userRef.observe(.value, with: { (snapshot) in
            
            let dict = snapshot.value as! [String : Any]
            user.id = dict["id"] as! String
            user.email = dict["email"] as! String
            user.nickname = dict["nickname"] as! String
            user.birthDate = dict["birthDate"] as? Date
            user.idPhoto = dict["idPhoto"] as? String
            user.idMinority = dict["idMinority"] as? String
            
            completion(user)
        })
        
    }
    
    static func getUser(withEmail email: String, completion: @escaping (User) -> ()) {
        let userRef = Database.database().reference().child("user")
        
        userRef.observe(.childAdded, with: { (snapshot: DataSnapshot) in
            
            let dict = snapshot.value as! [String : Any]
            if (dict["email"] as? String) != nil && (dict["email"] as! String) == email {
            
                let user = User()
                user.id = dict["id"] as! String
                user.email = dict["email"] as! String
                user.nickname = dict["nickname"] as! String
                user.birthDate = dict["birthDate"] as? Date
                user.idPhoto = dict["idPhoto"] as? String
                user.idMinority = dict["idMinority"] as? String
                
                completion(user)
            }
        })
    }
    
    // -FIXME: Not working
//    static func updateUser(id: String, nickname: String) {
//        let userRef = Database.database().reference().child("user").child(id)
//        let user = User()
//        user.id = id
//        user.nickname = nickname
//        
//        userRef.observe(.value, with: { (snapshot) in
//            
//            let dict = snapshot.value as! [String : Any]
//            user.email = dict["email"] as! String
//            user.password = dict["password"] as! String
//            user.age = dict["age"] as! Int
//            user.idPhoto = dict["idPhoto"] as? String
//            user.idMinority = dict["idMinority"] as? String
//        })
//
//        userRef.updateChildValues(user.toAnyObject() as! [AnyHashable : Any])
//        
//        let userRealm = AppRealm.instance.objects(User.self).filter("id == %s", id).first
//        
//        try! AppRealm.instance.write {
//            userRealm?.nickname = nickname
//        }
//    }
    
    // -FIXME: Not working
//    static func updateUser(id: String, password: String) {
//        let userRef = Database.database().reference().child("user").child(id)
//        let user = User()
//        user.id = id
//        user.password = password
//        
//        userRef.observe(.value, with: { (snapshot) in
//            
//            let userDic = snapshot.value as! [String : Any]
//            user.email = userDic["email"] as! String
//            user.nickname = userDic["nickname"] as! String
//            user.age = userDic["age"] as! Int
//            user.idPhoto = userDic["idPhoto"] as? String
//            user.idMinority = userDic["idMinority"] as? String
//        })
//        
//        userRef.updateChildValues(user.toAnyObject() as! [AnyHashable : Any])
//        
//        let userRealm = AppRealm.instance.objects(User.self).filter("id == %s", id).first
//        
//        try! AppRealm.instance.write {
//            userRealm?.password = password
//        }
//    }
    
    // -FIXME: Not working
//    static func updateUser(id: String, age: Int?, photo: Photo?, minority: Minority?) {
//        let userRef = Database.database().reference().child("user").child(id)
//        let user = User()
//        
//        userRef.observe(.value, with: { (snapshot) in
//            
//            let userDic = snapshot.value as! [String : Any]
//            user.email = userDic["email"] as! String
//            user.nickname = userDic["nickname"] as! String
//            user.password = userDic["password"] as! String
//            
//            user.id = id
//            if age != nil {
//                user.age = age!
//            }
//            if photo != nil {
//                user.idPhoto = photo?.id
//                createPhoto(photo: photo!)
//                deletePhoto(idPhoto: userDic["idPhoto"] as! String)
//            }
//            if minority != nil {
//                user.idMinority = minority?.id
//            }
//            
//        })
//        
//        userRef.updateChildValues(user.toAnyObject() as! [AnyHashable : Any])
//        
//        let userRealm = AppRealm.instance.objects(User.self).filter("id == %s", id).first
//        
//        try! AppRealm.instance.write {
//            if age != nil {
//                userRealm?.age = age!
//            }
//            if photo != nil {
//                userRealm?.idPhoto = photo?.id
//            }
//            if minority != nil {
//                userRealm?.idMinority = minority?.id
//            }
//        }
//    }
    
    // -TODO: Delete auth user reference
//    static func deleteUser(id: String) {
//        let userRef = Database.database().reference().child("user").child(id)
//        
//        userRef.observe(.value, with: { (snapshot) in
//            let userDic = snapshot.value as! [String : Any]
//            deletePhoto(idPhoto: userDic["idPhoto"] as! String)
//        })
//        
//        userRef.removeValue()
//        
//        let user = AppRealm.instance.objects(User.self).filter("id == %s", id).first
//        
//        try! AppRealm.instance.write {
//            AppRealm.instance.delete(user!)
//        }
//    }
    
    // -TODO: give access to all funccionalities of the app
    static func connectUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
}
