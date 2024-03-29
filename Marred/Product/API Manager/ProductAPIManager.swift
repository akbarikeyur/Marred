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
        //6907
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
            if let message = dict["message"] as? String, message != "" {
                displayToast(message)
            }
            else {
                completion()
            }
        }
    }
    
    func serviceCallToGetCart(_ isLoader : Bool, _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        APIManager.shared.callGetRequest(API.GET_CART, isLoader) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                    return
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
    
    func serviceCallToGetBookmark(_ param : [String : Any], _ isLoader : Bool, _ completion: @escaping (_ dict : [[String : Any]]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_BOOKMARK, param, isLoader) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToGetPaymentGateway(_ completion: @escaping (_ dict : [[String : Any]]) -> Void) {
        APIManager.shared.callGetRequestWithBasicAuthenticate(API.GET_PAYMENT_GATEWAY, false) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToApplyCoupon(_ code : String, _ completion: @escaping (_ dict : [String : Any]) -> Void) {
        APIManager.shared.callGetRequestWithArrayResponse((API.APPLY_COUPON + code), true) { (data) in
            print(data)
            if data.count > 0 {
                completion(data[0])
            }
        }
    }
    
    func serviceCallToCheckout(_ param : [String : Any], _ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequest(API.CHECKOUT_ORDER, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status != "error" {
                completion()
                return
            }
            else {
                APIManager.shared.handleError(dict)
            }
        }
    }
    
    func serviceCallToClearFullCart(_ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequest(API.CLEAR_FULL_CART, [String : Any](), false) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                completion()
                return
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
    
    func serviceCallToGetDealOfDay(_ param : [String : Any], _ completion: @escaping (_ dict : [[String : Any]]) -> Void) {
        APIManager.shared.callPostRequest(API.DEAL_OF_DAY, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
}
