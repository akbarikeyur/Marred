//
//  ProductAPIManager.swift
//  Marred
//
//  Created by Keyur on 07/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import Foundation

public class ProductAPIManager {

    static let shared = ProductAPIManager()

    func serviceCallToGetProductDetail(_ product_id : Int, _ completion: @escaping (_ dict : [String : Any]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_PRODUCT_DETAIL, ["product_id" : product_id], true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [String : Any] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToAddToCart(_ param : [String : Any], _ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequest(API.ADD_TO_CART, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                completion()
            }
        }
    }
    
    func serviceCallToGetCart(_ isLoader : Bool, _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        APIManager.shared.callGetRequest(API.GET_CART, isLoader) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [String : Any] {
                    if let cart = data["cart"] as? [[String : Any]] {
                        completion(cart)
                        return
                    }
                }
            }
        }
    }
    
    func serviceCallToClearToCart(_ param : [String : Any], _ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequest(API.CLEAR_CART, param, false) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                completion()
            }
        }
    }
    
    func serviceCallToAddBookmark(_ param : [String : Any], _ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequest(API.ADD_BOOKMARK, param, false) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                completion()
            }
        }
    }
    
    func serviceCallToRemoveBookmark(_ param : [String : Any], _ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequest(API.REMOVE_BOOKMARK, param, false) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                completion()
            }
        }
    }
    
    func serviceCallToGetBookmark(_ param : [String : Any], _ completion: @escaping (_ dict : [[String : Any]]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_BOOKMARK, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToGetPaymentGateway(_ completion: @escaping (_ dict : [[String : Any]]) -> Void) {
        APIManager.shared.callGetRequest(API.GET_PAYMENT_GATEWAY, false) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToApplyCoupon(_ code : String, _ completion: @escaping (_ dict : [[String : Any]]) -> Void) {
        APIManager.shared.callGetRequest((API.APPLY_COUPON + code), true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToAddShop(_ param : [String : Any], _ completion: @escaping () -> Void) {
        
        APIManager.shared.callPostRequest(API.ADD_SHOP, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                completion()
                return
            }
        }
    }    
}
