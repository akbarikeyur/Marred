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
    var user_login, user_nicename, user_email, display_name, token : String!
    var billing, shipping : AddressModel
     
    init(_ dict : [String : Any]) {
        ID = AppModel.shared.getIntData(dict, "ID")
        user_status = AppModel.shared.getIntData(dict, "user_status")
        user_login = dict["user_login"] as? String ?? ""
        user_nicename = dict["user_nicename"] as? String ?? ""
        user_email = dict["user_email"] as? String ?? ""
        display_name = dict["display_name"] as? String ?? ""
        token = dict["token"] as? String ?? ""
        billing = AddressModel.init(dict["billing"] as? [String : Any] ?? [String : Any]())
        shipping = AddressModel.init(dict["shipping"] as? [String : Any] ?? [String : Any]())
    }
    
    func dictionary() -> [String : Any] {
        return ["ID" : ID!, "user_status" : user_status!, "user_login" : user_login!, "user_nicename" : user_nicename!, "user_email" : user_email!, "display_name" : display_name!, "token" : token!, "billing" : billing.dictionary(), "shipping" : shipping.dictionary()]
    }
}

struct AddressModel {
    var first_name, last_name, company, address_1, address_2, city, state, postcode, country, email, phone : String!
    
    init(_ dict : [String : Any]) {
        first_name = dict["first_name"] as? String ?? ""
        last_name = dict["last_name"] as? String ?? ""
        company = dict["company"] as? String ?? ""
        address_1 = dict["address_1"] as? String ?? ""
        address_2 = dict["address_2"] as? String ?? ""
        city = dict["city"] as? String ?? ""
        state = dict["state"] as? String ?? ""
        postcode = dict["postcode"] as? String ?? ""
        country = dict["country"] as? String ?? ""
        email = dict["email"] as? String ?? ""
        phone = dict["phone"] as? String ?? ""
    }
    
    func dictionary() -> [String : Any] {
        return ["first_name" : first_name!, "last_name" : last_name!, "company" : company!, "address_1" : address_1!, "address_2" : address_2!, "city" : city!, "state" : state!, "postcode" : postcode!, "country" : country!, "email" : email!, "phone" : phone!]
    }
    
}
