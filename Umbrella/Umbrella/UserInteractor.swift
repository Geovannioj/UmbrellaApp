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

extension User {
    
    // -TODO: Password cryptography and email validation
    static func createUser(nickname: String, email: String,
                            password: String, age: Int?, photo: Photo?,
                            minority: Minority?) {
        
        // Add user to firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            // Treatment in case of error
            if error != nil {
                print(error!)
                return
            }
            
            let newUser = User()
            
            // Reference of the user table in firebase
            let userRef = Database.database().reference().child("user").child(String(newUser.id))
            
            // Fill an instance of the user with data
            newUser.id = (user?.uid)!
            newUser.nickname = nickname
            newUser.email = email
            newUser.password = password
            if age != nil {
                newUser.age = age!
            }
            if photo != nil {
                newUser.idPhoto = photo?.id
                createPhoto(photo: photo!)
            }
            if minority != nil {
                newUser.idMinority = minority?.id
            }
            
            userRef.setValue(newUser.toAnyObject())
            
            // Add user to realm
            try! AppRealm.instance.write {
                AppRealm.instance.add(newUser)
            }
            
            connectUser(email: email, password: password)
        }
    }
    
    //    static func getUsers() -> Results<User>{
    //
    //    }
    //
    //    static func getOnlineUsers() {
    //        
    //    }
    //
    //    static func getUserWith(id: Int) -> User? {
    //
    //    }
    //
    //    static func getUserWith(email: String) -> User? {
    //        
    //    }
    
    static func updateUser(id: String, nickname: String) {
        let userRef = Database.database().reference().child("user").child(id)
        let user = User()
        user.id = id
        user.nickname = nickname
        
        userRef.observe(.value, with: { (snapshot) in
            
            let userDic = snapshot.value as! [String : Any]
            user.email = userDic["email"] as! String
            user.password = userDic["password"] as! String
            user.age = userDic["age"] as! Int
            user.idPhoto = userDic["idPhoto"] as? String
            user.idMinority = userDic["idMinority"] as? String
        })

        userRef.updateChildValues(user.toAnyObject() as! [AnyHashable : Any])
        
        let userRealm = AppRealm.instance.objects(User.self).filter("id == %s", id).first
        
        try! AppRealm.instance.write {
            userRealm?.nickname = nickname
        }
    }
    
    static func updateUser(id: String, password: String) {
        let userRef = Database.database().reference().child("user").child(id)
        let user = User()
        user.id = id
        user.password = password
        
        userRef.observe(.value, with: { (snapshot) in
            
            let userDic = snapshot.value as! [String : Any]
            user.email = userDic["email"] as! String
            user.nickname = userDic["nickname"] as! String
            user.age = userDic["age"] as! Int
            user.idPhoto = userDic["idPhoto"] as? String
            user.idMinority = userDic["idMinority"] as? String
        })
        
        userRef.updateChildValues(user.toAnyObject() as! [AnyHashable : Any])
        
        let userRealm = AppRealm.instance.objects(User.self).filter("id == %s", id).first
        
        try! AppRealm.instance.write {
            userRealm?.password = password
        }
    }
    
    static func updateUser(id: String, age: Int?, photo: Photo?, minority: Minority?) {
        let userRef = Database.database().reference().child("user").child(id)
        let user = User()
        
        userRef.observe(.value, with: { (snapshot) in
            
            let userDic = snapshot.value as! [String : Any]
            user.email = userDic["email"] as! String
            user.nickname = userDic["nickname"] as! String
            user.password = userDic["password"] as! String
            
            user.id = id
            if age != nil {
                user.age = age!
            }
            if photo != nil {
                user.idPhoto = photo?.id
                createPhoto(photo: photo!)
                deletePhoto(idPhoto: userDic["idPhoto"] as! String)
            }
            if minority != nil {
                user.idMinority = minority?.id
            }
            
        })
        
        userRef.updateChildValues(user.toAnyObject() as! [AnyHashable : Any])
        
        let userRealm = AppRealm.instance.objects(User.self).filter("id == %s", id).first
        
        try! AppRealm.instance.write {
            if age != nil {
                userRealm?.age = age!
            }
            if photo != nil {
                userRealm?.idPhoto = photo?.id
            }
            if minority != nil {
                userRealm?.idMinority = minority?.id
            }
        }
    }
    
    // -TODO: Delete auth user reference
    static func deleteUser(id: String) {
        let userRef = Database.database().reference().child("user").child(id)
        
        userRef.observe(.value, with: { (snapshot) in
            let userDic = snapshot.value as! [String : Any]
            deletePhoto(idPhoto: userDic["idPhoto"] as! String)
        })
        
        userRef.removeValue()
        
        let user = AppRealm.instance.objects(User.self).filter("id == %s", id).first
        
        try! AppRealm.instance.write {
            AppRealm.instance.delete(user!)
        }
    }
    
    // -TODO: give access to all funccionalities of the app
    static func connectUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
}
