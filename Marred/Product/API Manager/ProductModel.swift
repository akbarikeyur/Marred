//
//  ProductModel.swift
//  Marred
//
//  Created by Keyur Akbari on 06/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import Foundation

struct ProductModel {
    var id : Int!
    var price, thumbnail, title, vendor : String!
    var brands : BrandModel!
    
    init(_ dict : [String : Any])
    {
        id = AppModel.shared.getIntData(dict, "id")
        price = AppModel.shared.getStringData(dict, "price")
        thumbnail = dict["thumbnail"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        vendor = dict["vendor"] as? String ?? ""
        brands = BrandModel.init(dict["brands"] as? [String : Any] ?? [String : Any]())
    }
}

struct BrandModel {
    var count, parent, term_group, term_id, term_taxonomy_id : Int!
    var desc, filter, name, slug, taxonomy : String!
    
    init(_ dict : [String : Any])
    {
        count = AppModel.shared.getIntData(dict, "count")
        parent = AppModel.shared.getIntData(dict, "parent")
        term_group = AppModel.shared.getIntData(dict, "term_group")
        term_id = AppModel.shared.getIntData(dict, "term_id")
        term_taxonomy_id = AppModel.shared.getIntData(dict, "term_taxonomy_id")
        desc = dict["description"] as? String ?? ""
        filter = dict["filter"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        slug = dict["slug"] as? String ?? ""
        taxonomy = dict["taxonomy"] as? String ?? ""
    }
    
    func dictionary() -> [String : Any] {
        return ["count" : count!, "parent" : parent!, "term_group" : term_group!, "term_id" : term_id!, "term_taxonomy_id" : term_taxonomy_id!, "description" : desc!, "filter" : filter!, "name" : name!, "slug" : slug!, "taxonomy" : taxonomy!]
    }
}
