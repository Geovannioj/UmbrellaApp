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

@objc protocol UserInteractorCompleteProtocol {
    
    @objc optional func completeLogin(user : UserInfo?, error : Error?)
    @objc optional func completeCreate(user : UserInfo?, error : Error?)
    @objc optional func completeDelete(error : Error?)
    @objc optional func completeSingOut(error : Error?)
    @objc optional func completeEmailVerification(error : Error?)
    @objc optional func completeUpdatePassword(error : Error?)

}

class UserInteractor {
    
    // -TODO: Email validation
    /**
     Function responsable for creating an authentication for an user and save his data on a server and local database.
     - parameter nickname: user's nickname
     - parameter email: user's email
     - parameter password: user's password
     - parameter birthDate: user's birth date (optional)
     - parameter idMinority: user's correspondent minority id (optional)
     - parameter image: user's profile photo
     - parameter userHandler: deals with errors and completes sign in actions
     - parameter photoHandler: deals with errors and completes photo operation actions
     */
    static func createUser(nickname: String, email: String,
                           password: String, birthDate: Date?,
                           idMinority: String?, image: UIImage,
                           userHandler : UserInteractorCompleteProtocol,
                           photoHandler: PhotoInteractorCompleteProtocol ) {
        
        // Add user to firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            // Treatment in case of user creation error
            if error != nil {
                userHandler.completeCreate?(user: user, error: error)
                return
            }
            
            let newUser = UserEntity()
            newUser.id = (user?.uid)!
            
            // Reference of the user table in firebase
            let userRef = Database.database().reference().child("user").child(String(newUser.id))
            
            // Fill an instance of the user with data
            newUser.nickname = nickname
            newUser.email = email
            if birthDate != nil {
                newUser.birthDate = birthDate!
            }
            if idMinority != nil {
                newUser.idMinority = idMinority
            }
            PhotoInteractor.createPhoto(image: image, photoHandler: photoHandler, completion: { (photo) -> () in
                newUser.urlPhoto = photo
                
                // Add user to local database
                SaveManager.instance.create(newUser)
                
                // Add user to firebase
                userRef.setValue(newUser.toAnyObject())
            })
            
            userHandler.completeCreate?(user: user, error: error)
            
            // Save the password on the keychain
            //KeychainService.savePassword(service: "Umbrella-Key", account: newUser.id, data: password)
            
        }
    }
    
    /**
     Function responsable for creating an authentication for an user and save his data on a server and local database.
     - parameter nickname: user's nickname
     - parameter email: user's email
     - parameter password: user's password
     - parameter birthDate: user's birth date (optional)
     - parameter idMinority: user's correspondent minority id (optional)
     - parameter userHandler: deals with errors and completes sign in actions
     */
    static func createUser(nickname: String, email: String,
                           password: String, birthDate: Date?,
                           idMinority: String?, userHandler : UserInteractorCompleteProtocol) {
        
        // Add user to firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            // Treatment in case of error
            if error != nil {
                userHandler.completeCreate?(user: user, error: error)
                return
            }
            
            let newUser = UserEntity()
            newUser.id = (user?.uid)!
            
            // Reference of the user table in firebase
            let userRef = Database.database().reference().child("user").child(String(newUser.id))
            
            // Fill an instance of the user with data
            newUser.nickname = nickname
            newUser.email = email
            if birthDate != nil {
                newUser.birthDate = birthDate!
            }
            if idMinority != nil {
                newUser.idMinority = idMinority
            }
                
            // Add user to local database
            SaveManager.instance.create(newUser)
            
            // Add user to firebase
            userRef.setValue(newUser.toAnyObject())
            
            userHandler.completeCreate?(user: user, error: error)
            
            // Save the password on the keychain
            //KeychainService.savePassword(service: "Umbrella-Key", account: newUser.id, data: password)
            
        }
    }

    
    /**
     Returns the current user's uid logged on the device.
     - returns: user's uid
     */
    static func getCurrentUserUid() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    /**
     Returns the current user's email logged on the device.
     - returns: user's email
     */
    static func getCurrentUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
    
    /**
     Verifies if the device is connected to the firebase.
     - parameter completion: returns true if there's an user connected or false if there is not
     */
    static func isFirebaseOnline(completion: @escaping (Bool) -> ()) {
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
    static func getUsers(completion: @escaping ([UserEntity]) -> ()) {
        let userRef = Database.database().reference().child("user")
        var users = [UserEntity]()
        
        userRef.observe(.value, with: { (snapshot) in
            if snapshot.value is NSNull {
                print("Users not found")
                return
            }
            
            for child in snapshot.children {
                let user = UserEntity()
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
     - parameter id: desired user's id
     - parameter completion: returns an User with the id parameter
     */
    static func getUser(withId id: String, completion: @escaping (UserEntity) -> ()) {
        let userRef = Database.database().reference().child("user").child(id)
        let user = UserEntity()
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
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
     - parameter email: desired user's email
     - parameter completion: returns an User with the email parameter
     */
    static func getUser(withEmail email: String, completion: @escaping (UserEntity) -> ()) {
        let userRef = Database.database().reference().child("user")
        
        userRef.observeSingleEvent(of: .childAdded, with: { (snapshot: DataSnapshot) in
            
            let dict = snapshot.value as! [String : Any]
            if (dict["email"] as? String) != nil && (dict["email"] as! String) == email {
            
                let user = UserEntity()
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
        if let userId = getCurrentUserUid() {
            
            let userRef = Database.database().reference().child("user").child(userId)
            
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                userRef.updateChildValues(["nickname" : nickname])
                
                let userRealm = SaveManager.realm.objects(UserEntity.self).filter("id == %s", userId).first
                
                try! SaveManager.realm.write {
                    userRealm?.nickname = nickname
                }
            })
        }
    }
    
    /**
     Updates the current connected user's photo.
     - parameter nickname: new user's photo url
     */
    static func updateCurrentUser(urlPhoto: String) {
        if let userId = getCurrentUserUid() {
            
            let userRef = Database.database().reference().child("user").child(userId)
            
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                userRef.updateChildValues(["urlPhoto" : urlPhoto])
                
                let userRealm = SaveManager.realm.objects(UserEntity.self).filter("id == %s", userId).first
                
                try! SaveManager.realm.write {
                    userRealm?.urlPhoto = urlPhoto
                }
            })
        }
    }
    
    /**
     Updates the current connected user's birth date.
     - parameter nickname: new user's birth date
     */
    static func updateCurrentUser(birthDate: Date) {
        if let userId = getCurrentUserUid() {
        
            let userRef = Database.database().reference().child("user").child(userId)

            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let formatter = UserEntity().dateConverter()

                userRef.updateChildValues(["birthDate" : formatter.string(from: birthDate)])
                
                let userRealm = SaveManager.realm.objects(UserEntity.self).filter("id == %s", userId).first
                
                try! SaveManager.realm.write {
                    userRealm?.birthDate = birthDate
                }

            })
        }
    }
    
    /**
     Updates the current connected user's minority.
     - parameter nickname: new user's minority id
     */
    static func updateCurrentUser(idMinority: String) {
        if let userId = getCurrentUserUid() {

            let userRef = Database.database().reference().child("user").child(userId)
            
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                userRef.updateChildValues(["idMinority" : idMinority])
                
                let userRealm = SaveManager.realm.objects(UserEntity.self).filter("id == %s", userId).first
                
                try! SaveManager.realm.write {
                    userRealm?.idMinority = idMinority
                }
                
            })
        }
    }
    
    // -FIXME: the user need a page to change his password.
//    /**
//     Updates the current connected user's password.
//     - parameter password: new user's password
//     - parameter handler: deals with errors and completes changing password actions
//     */
//    static func updateCurrentUser(password: String, handler: UserInteractorCompleteProtocol) {
//        if ((Auth.auth().currentUser?.uid) != nil) {
//            Auth.auth().currentUser?.updatePassword(to: password, completion: { error in
//                handler.completeUpdatePassword!(error: error)
//            })
//            
//        }
//    }

    // -FIXME: Dont delete, just deactivate the user
    /**
     Deletes the current user logged in.
     - parameter userHandler: deals with errors and completes user deletion actions
     - parameter photoHandler: deals with errors and completes photo operation actions

     */
    static func deleteUser(userHandler: UserInteractorCompleteProtocol,
                           photoHandler: PhotoInteractorCompleteProtocol) {
        
        if let userId = getCurrentUserUid() {

            Auth.auth().currentUser?.delete(completion: { error in
                if let err = error {
                    userHandler.completeDelete!(error: err)
                }
                    
                else {
                    let userRef = Database.database().reference().child("user").child(userId)
                    PhotoInteractor.deleteCurrentUserPhoto(photoHandler: photoHandler)
                    userRef.removeValue()
                    
                    //KeychainService.removePassword(service: "Umbrella-Key", account: userId)
                    
                    if let user = SaveManager.realm.objects(UserEntity.self).filter("id == %s", userId).first {
                        
                        try! SaveManager.realm.write {
                            SaveManager.realm.delete(user)
                        }
                    }
                }
            })
        }
    }
    
    // -FIXME: Not useful for the MVP
    // -TODO: give access to all funccionalities of the app
    /**
     Try to login the user online or offline
     - parameter email: user's email
     - parameter password: user's password
     - parameter completion: returns the state of connection of the user
     */
//    static func connectUser(email: String, password: String, completion: ((Bool) -> ())?) {
//        UserInteractor.isUserOnline(completion: { (connected) -> () in
//            var logged = false
//            
//            if connected == true {
//                UserInteractor.connectUserOnline(email: email, password: password)
//                
//            } else {
//                logged = UserInteractor.connectUserOffline(email: email, password: password)
//            }
//            
//            completion?(logged)
//        })
//    }
    
    /**
     Connects an user to the firebase
     - parameter email: user's email
     - parameter password: user's password
     - parameter userHandler: deals with errors and completes login actions
     */
    static func connectUserOnline(email: String, password: String, userHandler: UserInteractorCompleteProtocol) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            userHandler.completeLogin!(user: user, error: error)
        })
    }
    
    
//    /**
//     Connects an user on offline mode if his account was already saved on the device.
//     - parameter email: user's email
//     - parameter password: user's password
//     - returns: true is the user's email and password exist and false if they don't
//     */
//    private static func connectUserOffline(email: String, password: String) -> Bool {
//        if let user = SaveManager.realm.objects(UserEntity.self).filter("email == %s", email).first {
//            let pass = KeychainService.loadPassword(service: "Umbrella-Key", account: user.id)
//            if pass == password {
//                return true
//            }
//        }
//        return false
//    }
    
    /**
     Disconnects the currunt logged user of the firebase
     - parameter userHandler: deals with errors and completes disconnection actions
     */
    static func disconnectUser(userHandler: UserInteractorCompleteProtocol) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            userHandler.completeSingOut!(error: error)
        }
    }
    
    // -TODO: Write a formal email verification on firebase options and test this method
    /**
     Sends an email verification to the user's email
     - parameter userHandler: deals with errors
    */
    static func sendEmailVerification(userHandler: UserInteractorCompleteProtocol) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
             userHandler.completeEmailVerification!(error: error)
        })
    }
    
}







