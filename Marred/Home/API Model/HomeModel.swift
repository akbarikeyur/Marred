//
//  HomeModel.swift
//  Marred
//
//  Created by Keyur Akbari on 07/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import Foundation

struct CategoryModel {
    var title, image : String!
    
    init(_ dict : [String : Any])
    {
        title = dict["title"] as? String ?? ""
        image = dict["image"] as? String ?? ""
    }
}

struct HomeDisplayModel {
    var type : String!
    
    init(_ dict : [String : Any])
    {
        type = dict["type"] as? String ?? ""
    }
}
