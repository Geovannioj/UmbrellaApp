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
     Function responsable for creating an authentication for an user and save his data on a server and local database and logs the user in if the operation is successful.
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
            //newUser.password = password
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
                    
                    // Add user to firebase
                    userRef.setValue(newUser.toAnyObject())
                })
            }
            
            // Save the password on the keychain
            KeychainService.savePassword(service: "Umbrella-Key", account: newUser.id, data: password)
 
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
    static func updateCurrentUser(nickname: String) {
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
    static func updateCurrentUser(urlPhoto: String) {
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
    static func updateCurrentUser(birthDate: Date) {
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
    static func updateCurrentUser(idMinority: String) {
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
    static func updateUser(password: String) {
        
    }

    /**
     Deletes the current user logged in.
     */
    static func deleteUser() {
        if let userId = Auth.auth().currentUser?.uid {

            Auth.auth().currentUser?.delete(completion: { error in
                if let err = error {
                    print(err)
                }
                    
                else {
                    let userRef = Database.database().reference().child("user").child(userId)
                    PhotoInteractor.deleteUserPhoto()
                    userRef.removeValue()
                    
                    KeychainService.removePassword(service: "Umbrella-Key", account: userId)
                    
                    if let user = SaveManager.realm.objects(User.self).filter("id == %s", userId).first {
                        
                        try! SaveManager.realm.write {
                            SaveManager.realm.delete(user)
                        }
                    }
                }
            })
        }
    }
    
    // -TODO: give access to all funccionalities of the app
    /**
     Connects an user to the firebase
     - parameter email: user's email
     - parameter password: user's password
     */
    static func connectUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    /**
     Disconnects the currunt logged user of the firebase
     */
    static func disconnectUser() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // -TODO: Write a formal email verification on firebase options and test this method
    /**
     Sends an email verification to the user's email
    */
    static func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
    }
    
}
