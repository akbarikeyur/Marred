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
    
    func serviceCallToGetProducts(_ param : [String : Any], _ completion: @escaping (_ dict : [[String : Any]]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_ORDER, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
}
