//
//  UserInteractor.swift
//  Umbrella
//
//  Created by Bruno Chagas on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import RealmSwift

extension User {
    
    static func getUsers() -> Results<User>{
        return AppRealm.instance.objects(User.self)
    }
    
    static func getUserWith(id: Int) -> User? {
        return AppRealm.instance.objects(User.self).filter("id == %d", id).first
    }
    
    static func getUserWith(email: String) -> User? {
        return AppRealm.instance.objects(User.self).filter("email == %s", email).first
    }
    
    static func addUser(id: Int, nickname: String, email: String,
                            password: String, age: Int?, photo: Photo?,
                            minority: Minority?) {
        try! AppRealm.instance.write {
            let newUser = User()
            
            newUser.id = self.IncrementID()
            newUser.nickname = nickname
            newUser.email = email
            newUser.password = password
            if age != nil {
                newUser.age = age!
            }
            if photo != nil {
                newUser.photo = photo
            }
            if minority != nil {
                newUser.minority = minority
            }
            
            AppRealm.instance.add(newUser)
        }
    }
    
    static func updateUser(id: Int, nickname: String) {
        let user = AppRealm.instance.objects(User.self).filter("id == %d", id).first
        
        try! AppRealm.instance.write {
            user?.nickname = nickname
        }
    }
    
    static func updateUser(id: Int, password: String) {
        let user = AppRealm.instance.objects(User.self).filter("id == %d", id).first
        
        try! AppRealm.instance.write {
            user?.password = password
        }
    }
    
    static func updateUser(id: Int, age: Int?, photo: Photo?, minority: Minority?) {
        let user = AppRealm.instance.objects(User.self).filter("id == %d", id).first
        
        try! AppRealm.instance.write {
            if age != nil {
                user?.age = age!
            }
            if photo != nil {
                user?.photo = photo
            }
            if minority != nil {
                user?.minority = minority
            }
        }
    }
    
    static func deleteUser(id: Int) {
        let user = AppRealm.instance.objects(User.self).filter("id == %d", id).first
        
        try! AppRealm.instance.write {
            AppRealm.instance.delete(user!)
        }
    }
    
    static func IncrementID() -> Int{
        let RetNext: NSArray = Array(AppRealm.instance.objects(User.self).sorted(byKeyPath: "id")) as NSArray
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = (last as! User).value(forKey: "id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}
