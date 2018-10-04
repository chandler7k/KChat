//
//  User.swift
//  GameOfChat
//
//  Created by ChandlerZou on 2018/10/3.
//  Copyright © 2018 zouhuanlin. All rights reserved.
//

import UIKit

class User: NSObject {
    var email: String?
    var name: String?
    init(dictionary: [String: Any]){
        self.name = dictionary["names"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
