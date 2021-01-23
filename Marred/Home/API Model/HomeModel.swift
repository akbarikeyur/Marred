//
//  HomeModel.swift
//  Marred
//
//  Created by Keyur Akbari on 07/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import Foundation

struct CategoryModel {
    var term_id, count : Int!
    var name : String!
    var img : Bool!
    
    init(_ dict : [String : Any])
    {
        term_id = AppModel.shared.getIntData(dict, "term_id")
        name = dict["name"] as? String ?? ""
        img = dict["img"] as? Bool ?? false
        count = AppModel.shared.getIntData(dict, "count")
    }
    
    func dictionary() -> [String : Any] {
        return ["term_id" : term_id!, "name" : name!, "img" : img!, "count" : count!]
    }
}

struct HomeModel {
    var name, banner : String!
    var data : [CategoryModel]!
    var products : [ProductModel]!
    
    init(_ dict : [String : Any])
    {
        name = dict["name"] as? String ?? ""
        banner = dict["banner"] as? String ?? ""
        data = [CategoryModel]()
        if let tempData = dict["data"] as? [[String : Any]] {
            for temp in tempData {
                data.append(CategoryModel.init(temp))
            }
        }
        products = [ProductModel]()
        if let tempData = dict["products"] as? [[String : Any]] {
            for temp in tempData {
                products.append(ProductModel.init(temp))
            }
        }
    }
}

struct HomeDisplayModel {
    var type : String!
    
    init(_ dict : [String : Any])
    {
        type = dict["type"] as? String ?? ""
    }
}

struct PavilionModel {
    var id : Int!
    var name, image : String!
    
    init(_ dict : [String : Any])
    {
        id = AppModel.shared.getIntData(dict, "id")
        name = dict["name"] as? String ?? ""
        image = dict["image"] as? String ?? ""
    }
}
