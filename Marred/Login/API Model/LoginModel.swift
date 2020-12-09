//
//  LoginModel.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import Foundation

struct MenuModel {
    var name, image : String!
    
    init(_ dict : [String : Any]) {
        name = dict["name"] as? String ?? ""
        image = dict["image"] as? String ?? ""
    }
}
