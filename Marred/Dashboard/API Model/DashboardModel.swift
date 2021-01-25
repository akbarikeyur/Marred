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
