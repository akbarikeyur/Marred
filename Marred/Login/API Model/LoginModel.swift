//
//  LoginModel.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import Foundation

struct MenuModel {
    var id : Int!
    var name, image : String!
    
    init(_ dict : [String : Any]) {
        id = AppModel.shared.getIntData(dict, "id")
        name = dict["name"] as? String ?? ""
        image = dict["image"] as? String ?? ""
    }
}

struct UserModel {
    var ID, user_status : Int!
    var user_login, user_nicename, user_email, display_name : String!
    
    init(_ dict : [String : Any]) {
        ID = AppModel.shared.getIntData(dict, "ID")
        user_status = AppModel.shared.getIntData(dict, "user_status")
        user_login = dict["user_login"] as? String ?? ""
        user_nicename = dict["user_nicename"] as? String ?? ""
        user_email = dict["user_email"] as? String ?? ""
        display_name = dict["display_name"] as? String ?? ""
    }
    
    func dictionary() -> [String : Any] {
        return ["ID" : ID!, "user_status" : user_status!, "user_login" : user_login!, "user_nicename" : user_nicename!, "user_email" : user_email!, "display_name" : display_name!]
    }
}

