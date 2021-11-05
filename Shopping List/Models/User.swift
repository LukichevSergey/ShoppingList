//
//  User.swift
//  Shopping List
//
//  Created by Сергей Лукичев on 05.11.2021.
//

import Foundation
import Firebase

struct User {
    let uid: String
    let email: String
    
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
