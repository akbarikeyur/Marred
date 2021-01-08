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
}
