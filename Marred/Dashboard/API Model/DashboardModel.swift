//
//  DashboardModel.swift
//  Marred
//
//  Created by Keyur on 24/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import Foundation

struct DashboardSellerModel {
    var total_sales, order_total, pageviews : String!
    var orders : DashboardSellerOrderModel!
    var products : DashboardSellerProductModel!
    
    init(_ dict : [String : Any]) {
        total_sales = AppModel.shared.getStringData(dict, "total_sales")
        order_total = AppModel.shared.getStringData(dict, "order_total")
        pageviews = AppModel.shared.getStringData(dict, "pageviews")
        orders = DashboardSellerOrderModel.init(dict["orders"] as? [String :Any] ?? [String :Any]())
        products = DashboardSellerProductModel.init(dict["products"] as? [String :Any] ?? [String :Any]())
    }
    
    func dictionary() -> [String : Any] {
        return ["total_sales" : total_sales!, "order_total" : order_total!, "pageviews" : pageviews!, "orders" : orders.dictionary(), "products" : products.dictionary()]
    }
}

struct DashboardSellerOrderModel {
    var total, wc_completed, wc_pending, wc_processing, wc_cancelled, wc_failed : String!
    
    init(_ dict : [String : Any]) {
        total = AppModel.shared.getStringData(dict, "total")
        wc_completed = AppModel.shared.getStringData(dict, "wc_completed")
        wc_pending = AppModel.shared.getStringData(dict, "wc_pending")
        wc_processing = AppModel.shared.getStringData(dict, "wc_processing")
        wc_cancelled = AppModel.shared.getStringData(dict, "wc_cancelled")
        wc_failed = AppModel.shared.getStringData(dict, "wc_failed")
    }
    
    func dictionary() -> [String : Any] {
        return ["total" : total!, "wc_completed" : wc_completed!, "wc_pending" : wc_pending!, "wc_processing" : wc_processing!, "wc_cancelled" : wc_cancelled!, "wc_failed" : wc_failed!]
    }
}

struct DashboardSellerProductModel {
    var total : String!
    
    init(_ dict : [String : Any]) {
        total = AppModel.shared.getStringData(dict, "total")
    }
    
    func dictionary() -> [String : Any] {
        return ["total" : total!]
    }
}

struct TitleValueModel {
    var title, value : String!
    
    init(_ dict : [String : Any]) {
        title = dict["title"] as? String ?? ""
        value = dict["value"] as? String ?? ""
    }
}

struct WithdrawModel {
    var id, user_id, amount, date, status, method, note : String!
    
    init(_ dict : [String : Any]) {
        id = AppModel.shared.getStringData(dict, "id")
        user_id = AppModel.shared.getStringData(dict, "user_id")
        amount = AppModel.shared.getStringData(dict, "amount")
        date = AppModel.shared.getStringData(dict, "date")
        status = AppModel.shared.getStringData(dict, "status")
        method = AppModel.shared.getStringData(dict, "method")
        note = AppModel.shared.getStringData(dict, "note")
        
    }
}

struct OrderProductModel {
    var id : Int!
    var get_name, get_status, get_description, get_short_description, thumbnail, get_price, store_name : String!
    var get_featured : Bool!
    
    
    init(_ dict : [String : Any])
    {
        id = AppModel.shared.getIntData(dict, "id")
        get_price = AppModel.shared.getStringData(dict, "get_price")
        store_name = AppModel.shared.getStringData(dict, "store_name")
        thumbnail = dict["thumbnail"] as? String ?? ""
        get_name = dict["get_name"] as? String ?? ""
        get_status = dict["get_status"] as? String ?? ""
        get_description = dict["get_description"] as? String ?? ""
        get_short_description = dict["get_short_description"] as? String ?? ""
        get_featured = dict["get_featured"] as? Bool ?? false
    }
}

struct OrderModel {
    var product_detail : OrderProductModel!
    var id, quantity : Int!
    var status, currency, date_created, total : String!
    var billing, shipping : AddressModel!
    
    init(_ dict : [String : Any]) {
        id = AppModel.shared.getIntData(dict, "id")
        quantity = AppModel.shared.getIntData(dict, "quantity")
        status = AppModel.shared.getStringData(dict, "status")
        currency = AppModel.shared.getStringData(dict, "currency")
        if let tempDict = dict["date_created"] as? [String : Any] {
            date_created = AppModel.shared.getStringData(tempDict, "date")
        }
        total = AppModel.shared.getStringData(dict, "total")
        billing = AddressModel.init(dict["billing"] as? [String : Any] ?? [String : Any]())
        shipping = AddressModel.init(dict["shipping"] as? [String : Any] ?? [String : Any]())
        
    }
}
