//
//  ProductModel.swift
//  Marred
//
//  Created by Keyur Akbari on 06/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import Foundation

struct ProductModel {
    var id, vendor_id : Int!
    var price, thumbnail, title, vendor, author_name, view, get_status, get_sku, order_published : String!
    var brands : BrandModel!
    
    init(_ dict : [String : Any])
    {
        id = AppModel.shared.getIntData(dict, "id")
        if dict["price"] != nil {
            price = AppModel.shared.getStringData(dict, "price")
        }else if dict["get_price"] != nil {
            price = AppModel.shared.getStringData(dict, "get_price")
        }
        
        thumbnail = dict["thumbnail"] as? String ?? ""
        
        if thumbnail == "" {
            if let images = dict["images"] as? [[String : Any]], images.count > 0 {
                thumbnail = images[0]["src"] as? String ?? ""
            }
        }
        if dict["title"] != nil {
            title = dict["title"] as? String ?? ""
        }else if dict["get_name"] != nil {
            title = dict["get_name"] as? String ?? ""
        }else if dict["name"] != nil {
            title = dict["name"] as? String ?? ""
        }
        vendor = dict["vendor"] as? String ?? ""
        if vendor == "" {
            vendor = dict["store"] as? String ?? ""
        }
        brands = BrandModel.init(dict["brands"] as? [String : Any] ?? [String : Any]())
        vendor_id = AppModel.shared.getIntData(dict, "vendor_id")
        author_name = dict["author_name"] as? String ?? ""
        view = AppModel.shared.getStringData(dict, "view")
        get_status = AppModel.shared.getStringData(dict, "get_status")
        get_sku = AppModel.shared.getStringData(dict, "get_sku")
        order_published = AppModel.shared.getStringData(dict, "order_published")
    }
    
    func dictionary() -> [String : Any] {
        return ["id" : id!, "price" : price!, "thumbnail" : thumbnail!, "title" : title!, "vendor" : vendor!, "brands" : brands.dictionary(), "vendor_id" : vendor_id!, "author_name" : author_name!]
    }
}

struct ProductDetailModel {
    var get_total_sales, get_stock_quantity, product_id : Int!
    var get_name, get_status, get_description, get_short_description, get_sku, get_price, get_regular_price, get_sale_price, get_tax_status, get_stock_status, get_purchase_note, get_type, thumbnail, vendor : String!
    var get_featured, get_virtual, get_manage_stock : Bool!
    var related_products : [ProductModel]!
    var get_categories : [CategoryModel]!
    var brands : BrandModel!
    var images : [String]!
    var get_available_variations : [VariationModel]!
    
    init(_ dict : [String : Any])
    {
        product_id = AppModel.shared.getIntData(dict, "product_id")
        brands = BrandModel.init(dict["brands"] as? [String : Any] ?? [String : Any]())
        get_type = dict["get_type"] as? String ?? ""
        thumbnail = dict["thumbnail"] as? String ?? ""
        vendor = dict["vendor"] as? String ?? ""
        get_total_sales = AppModel.shared.getIntData(dict, "get_total_sales")
        get_stock_quantity = AppModel.shared.getIntData(dict, "get_stock_quantity")
        get_name = dict["get_name"] as? String ?? ""
        get_status = dict["get_status"] as? String ?? ""
        get_description = dict["get_description"] as? String ?? ""
        get_short_description = dict["get_short_description"] as? String ?? ""
        get_sku = dict["get_sku"] as? String ?? ""
        get_tax_status = dict["get_tax_status"] as? String ?? ""
        get_stock_status = dict["get_stock_status"] as? String ?? ""
        get_purchase_note = dict["get_purchase_note"] as? String ?? ""
        get_categories = [CategoryModel]()
        if let data = dict["get_categories"] as? [[String : Any]] {
            for temp in data {
                get_categories.append(CategoryModel.init(temp))
            }
        }
        get_price = AppModel.shared.getStringData(dict, "get_price")
        get_regular_price = AppModel.shared.getStringData(dict, "get_regular_price")
        get_sale_price = AppModel.shared.getStringData(dict, "get_sale_price")
        get_featured = dict["get_featured"] as? Bool ?? false
        get_virtual = dict["get_virtual"] as? Bool ?? false
        get_manage_stock = dict["get_manage_stock"] as? Bool ?? false
        
        related_products = [ProductModel]()
        if let data = dict["related_products"] as? [[String : Any]] {
            for temp in data {
                related_products.append(ProductModel.init(temp))
            }
        }
        
        images = dict["images"] as? [String] ?? [String]()
        get_available_variations = [VariationModel]()
        if let data = dict["get_available_variations"] as? [[String : Any]] {
            for temp in data {
                get_available_variations.append(VariationModel.init(temp))
            }
        }
    }
}

struct VariationModel {
    var variation_id : Int!
    var attribute_pa_size, attribute_pa_color, display_price, full_src, thumb_src : String!
    var isForSize, isForColor : Bool!
    
    init(_ dict : [String : Any])
    {
        variation_id = AppModel.shared.getIntData(dict, "variation_id")
        attribute_pa_size = ""
        attribute_pa_color = ""
        isForSize = false
        isForColor = false
        if let tempDict = dict["attributes"] as? [String : Any] {
            if tempDict["attribute_pa_size"] != nil {
                isForSize = true
                attribute_pa_size = AppModel.shared.getStringData(tempDict, "attribute_pa_size")
            }
            if tempDict["attribute_pa_color"] != nil {
                isForColor = true
                attribute_pa_color = AppModel.shared.getStringData(tempDict, "attribute_pa_color")
            }
        }
        display_price = AppModel.shared.getStringData(dict, "display_price")
        full_src = ""
        thumb_src = ""
        if let tempDict = dict["image"] as? [String : Any] {
            full_src = AppModel.shared.getStringData(tempDict, "full_src")
            thumb_src = AppModel.shared.getStringData(tempDict, "thumb_src")
        }
    }
}

struct ImageModel {
    var id : Int!
    var src : String!
    
    init(_ dict : [String : Any]) {
        id = AppModel.shared.getIntData(dict, "id")
        src = dict["src"] as? String ?? ""
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

struct CartModel {
    var product_id, product_name, product_price, product_image, store_name : String!
    var quantity : Int!
    var line_total, price : Double!
    var variation : [String : Any]!
    
    init(_ dict : [String : Any]) {
        product_id = AppModel.shared.getStringData(dict, "product_id")
        product_name = AppModel.shared.getStringData(dict, "product_name")
        product_price = AppModel.shared.getStringData(dict, "product_price")
        quantity = AppModel.shared.getIntData(dict, "quantity")
        product_image = AppModel.shared.getStringData(dict, "product_image")
        store_name = AppModel.shared.getStringData(dict, "store_name")
        line_total = AppModel.shared.getDoubleData(dict, "line_total")
        price = AppModel.shared.getDoubleData(dict, "price")
        variation = dict["variation"] as? [String : Any] ?? [String : Any]()
    }
}

struct DealProductModel {
    var id : Int!
    var get_featured : Bool!
    var get_name, get_status, get_description, get_short_description, get_price, thumbnail : String!
    
    init(_ dict : [String : Any]) {
        id = AppModel.shared.getIntData(dict, "id")
        get_featured = dict["get_featured"] as? Bool ?? false
        get_name = AppModel.shared.getStringData(dict, "get_name")
        get_status = AppModel.shared.getStringData(dict, "get_status")
        get_description = AppModel.shared.getStringData(dict, "get_description")
        get_short_description = AppModel.shared.getStringData(dict, "get_short_description")
        get_price = AppModel.shared.getStringData(dict, "get_price")
        thumbnail = AppModel.shared.getStringData(dict, "thumbnail")
    }
    
    func dictionary() -> [String : Any] {
        return ["id" : id!, "get_featured" : get_featured!, "get_name" : get_name!, "get_status" : get_status!, "get_description" : get_description!, "get_short_description":get_short_description!, "get_price":get_price!,  "thumbnail":thumbnail!]
    }
}

struct CouponModel {
    var id, code, amount : String
    
    init(_ dict : [String : Any]) {
        id = AppModel.shared.getStringData(dict, "id")
        code = AppModel.shared.getStringData(dict, "code")
        amount = AppModel.shared.getStringData(dict, "amount")
    }
}
