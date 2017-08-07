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
    /**
     Function responsable for creating an authentication for an user and save his data on a server and local database.
     - parameter nickname: user's nickname
     - parameter email: user's email
     - parameter password: user's password
     - parameter birthDate: user's birth date
     - parameter image: user's profile photo
     - parameter idMinority: user's correspondent minority id
     */
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
                    newUser.urlPhoto = photo
                    
                    // Add user to local database
                    SaveManager.instance.create(newUser)
                    
                    userRef.setValue(newUser.toAnyObject())
                })
            }
 
            connectUser(email: email, password: password)
            
        }
    }
    
    /**
     Returns the current user's email logged on the device.
     - returns: user's email
     */
    static func getUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
    
    /**
     Verifies if there's an user online on the device.
     - parameter completion: returns true if there's an user connected or false if there is not
     */
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
    
    /**
     Returns an array of User if there is on the server.
     - parameter completion: returns an array of User if there is users saved
     */
    static func getUsers(completion: @escaping ([User]) -> ()) {
        let userRef = Database.database().reference().child("user")
        var users = [User]()
        
        userRef.observe(.value, with: { (snapshot) in
            if snapshot.value is NSNull {
                print("Users not found")
                return
            }
            
            for child in snapshot.children {
                let user = User()
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String : Any]
                
                user.id = snapshot.key
                user.email = dict["email"] as! String
                user.nickname = dict["nickname"] as! String
                user.birthDate = dict["birthDate"] as? Date
                user.urlPhoto = dict["urlPhoto"] as? String
                user.idMinority = dict["idMinority"] as? String
                users.append(user)
            }
            
            completion(users)
        })
    }
    
    /**
     Returns an User with the id parameter if there is one on the server.
     - parameter id: id of the user desired
     - parameter completion: returns an User with the id parameter
     */
    static func getUser(withId id: String, completion: @escaping (User) -> ()) {
        let userRef = Database.database().reference().child("user").child(id)
        let user = User()
        
        userRef.observe(.value, with: { (snapshot) in
            
            let dict = snapshot.value as! [String : Any]
            user.id = snapshot.key
            user.email = dict["email"] as! String
            user.nickname = dict["nickname"] as! String
            user.birthDate = dict["birthDate"] as? Date
            user.urlPhoto = dict["urlPhoto"] as? String
            user.idMinority = dict["idMinority"] as? String
            
            completion(user)
        })
        
    }
    
    /**
     Returns an User with the email parameter if there is one on the server.
     - parameter email: email of the user desired
     - parameter completion: returns an User with the email parameter
     */
    static func getUser(withEmail email: String, completion: @escaping (User) -> ()) {
        let userRef = Database.database().reference().child("user")
        
        userRef.observe(.childAdded, with: { (snapshot: DataSnapshot) in
            
            let dict = snapshot.value as! [String : Any]
            if (dict["email"] as? String) != nil && (dict["email"] as! String) == email {
            
                let user = User()
                user.id = snapshot.key
                user.email = dict["email"] as! String
                user.nickname = dict["nickname"] as! String
                user.birthDate = dict["birthDate"] as? Date
                user.urlPhoto = dict["urlPhoto"] as? String
                user.idMinority = dict["idMinority"] as? String
                
                completion(user)
            }
        })
    }
    
    /**
     Updates the current connected user's nickname
     - parameter nickname: new user's nickname
     */
    static func updateUser(nickname: String) {
        if let userId = Auth.auth().currentUser?.uid {
            
            let userRef = Database.database().reference().child("user").child(userId)
            
            userRef.observe(.value, with: { (snapshot) in
                
                userRef.updateChildValues(["nickname" : nickname])
                
                let userRealm = SaveManager.realm.objects(User.self).filter("id == %s", userId).first
                
                try! SaveManager.realm.write {
                    userRealm?.nickname = nickname
                }
            })
        }
    }
    
    /**
     Updates the current connected user's photo
     - parameter nickname: new user's photo url
     */
    static func updateUser(urlPhoto: String) {
        if let userId = Auth.auth().currentUser?.uid {
            
            let userRef = Database.database().reference().child("user").child(userId)
            
            userRef.observe(.value, with: { (snapshot) in
                
                userRef.updateChildValues(["urlPhoto" : urlPhoto])
                
                let userRealm = SaveManager.realm.objects(User.self).filter("id == %s", userId).first
                
                try! SaveManager.realm.write {
                    userRealm?.urlPhoto = urlPhoto
                }
            })
        }
    }
    
    /**
     Updates the current connected user's birth date
     - parameter nickname: new user's birth date
     */
    static func updateUser(birthDate: Date) {
        if let userId = Auth.auth().currentUser?.uid {
        
            let userRef = Database.database().reference().child("user").child(userId)

            userRef.observe(.value, with: { (snapshot) in
                let formatter = User().dateConverter()

                userRef.updateChildValues(["birthDate" : formatter.string(from: birthDate)])
                
                let userRealm = SaveManager.realm.objects(User.self).filter("id == %s", userId).first
                
                try! SaveManager.realm.write {
                    userRealm?.birthDate = birthDate
                }

            })
        }
    }
    
    /**
     Updates the current connected user's minority
     - parameter nickname: new user's minority id
     */
    static func updateUser(idMinority: String) {
        if let userId = Auth.auth().currentUser?.uid {

            let userRef = Database.database().reference().child("user").child(userId)
            
            userRef.observe(.value, with: { (snapshot) in
                
                userRef.updateChildValues(["idMinority" : idMinority])
                
                let userRealm = SaveManager.realm.objects(User.self).filter("id == %s", userId).first
                
                try! SaveManager.realm.write {
                    userRealm?.idMinority = idMinority
                }
                
            })
        }
    }
    
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
    /**
     Connects an user to the firebase
     - parameter email: user's email
     - parameter password: user's password
     */
    static func connectUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
}
