//
//  HomeModel.swift
//  Marred
//
//  Created by Keyur Akbari on 07/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import Foundation

struct CategoryModel {
    var id : Int!
    var name, image : String!
    
    init(_ dict : [String : Any])
    {
        id = AppModel.shared.getIntData(dict, "id")
        name = dict["name"] as? String ?? ""
        image = dict["image"] as? String ?? ""
    }
    
    func dictionary() -> [String : Any] {
        return ["id" : id!, "name" : name!, "image" : image!]
    }
}

struct HomeDisplayModel {
    var type : String!
    
    init(_ dict : [String : Any])
    {
        type = dict["type"] as? String ?? ""
    }
}
