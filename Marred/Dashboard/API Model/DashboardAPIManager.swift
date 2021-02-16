//
//  DashboardAPIManager.swift
//  Marred
//
//  Created by Keyur on 24/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import Foundation

public class DashboardAPIManager {

    static let shared = DashboardAPIManager()

    func serviceCallToGetSellerDashboard(_ completion: @escaping (_ dict : [String : Any]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_SELLER_DASHBOARD, ["user_id" : AppModel.shared.currentUser.ID!], true) { (dict) in
            printData(dict)
            completion(dict)
        }
    }
    
    func serviceCallToGetSellerOrder(_ param : [String : Any], _ completion: @escaping (_ dict : [[String : Any]]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_SELLER_ORDER, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToGetBuyerOrder(_ completion: @escaping (_ dict : [[String : Any]]) -> Void) {
        let strUrl = API.GET_BUYER_ORDER + "&customer=" + String(AppModel.shared.currentUser.ID)
        APIManager.shared.callGetRequestWithArrayResponse(strUrl, true) { (data) in
            printData(data)
            completion(data)
        }
    }
    
    func serviceCallToGetWithdrawRequest(_ param : [String : Any], _ completion: @escaping (_ dict : [[String : Any]]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_WITHDRAW_REQUEST, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToContactUs(_ param : [String : Any], _ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequest(API.CONTACT_US, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                completion()
                return
            }
        }
    }
    
    func serviceCallToGetUserProduct(_ param : [String : Any], _ completion: @escaping (_ dict : [String : Any]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_USER_PRODUCT, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [String : Any] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToGetAddress(_ completion: @escaping (_ dict : [String : Any]) -> Void) {
        APIManager.shared.callGetRequest(API.GET_SET_ADDRESS, true) { (dict) in
            printData(dict)
            completion(dict)
        }
    }
    
    func serviceCallToSetAddress(_ param : [String : Any], _ completion: @escaping (_ dict : [String : Any]) -> Void) {
        APIManager.shared.callPutRequest(API.GET_SET_ADDRESS, param, true) { (dict) in
            printData(dict)
            if let billing = dict["billing"] as? [String : Any] {
                setBillingAddress(AddressModel.init(billing))
            }
            if let shipping = dict["shipping"] as? [String : Any]{
                setShippingAddress(AddressModel.init(shipping))
            }
        }
    }
}
