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

struct OrderModel {
    var id, user_id, customer_id : Int!
    var status, currency, date_created, total : String!
    var billing, shipping : AddressModel!
    var line_items : [OrderProductModel]!
    var stores : [BrandModel]!
    
    init(_ dict : [String : Any]) {
        id = AppModel.shared.getIntData(dict, "id")
        user_id = AppModel.shared.getIntData(dict, "user_id")
        customer_id = AppModel.shared.getIntData(dict, "customer_id")
        status = AppModel.shared.getStringData(dict, "status")
        currency = AppModel.shared.getStringData(dict, "currency")
        if let temp = dict["date_created"] as? String {
            date_created = temp
        }
        total = AppModel.shared.getStringData(dict, "total")
        billing = AddressModel.init(dict["billing"] as? [String : Any] ?? [String : Any]())
        shipping = AddressModel.init(dict["shipping"] as? [String : Any] ?? [String : Any]())
        line_items = [OrderProductModel]()
        if let tempData = dict["line_items"] as? [[String : Any]] {
            for temp in tempData {
                line_items.append(OrderProductModel.init(temp))
            }
        }
        stores = [BrandModel]()
        if let tempData = dict["stores"] as? [[String : Any]] {
            for temp in tempData {
                stores.append(BrandModel.init(temp))
            }
        }
    }
}

struct OrderProductModel {
    var id : Int!
    var price, name, thumbnail : String!
    var quantity : Int!
    
    init(_ dict : [String : Any])
    {
        id = AppModel.shared.getIntData(dict, "id")
        price = AppModel.shared.getStringData(dict, "price")
        thumbnail = dict["thumbnail"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        quantity = AppModel.shared.getIntData(dict, "quantity")
    }
    
    func dictionary() -> [String : Any] {
        return ["id" : id!, "price" : price!, "thumbnail" : thumbnail!, "name" : name!, "quantity" : quantity!]
    }
}
