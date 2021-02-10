//
//  HomeAPIManager.swift
//  Marred
//
//  Created by Keyur Akbari on 22/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import Foundation

public class HomeAPIManager {

    static let shared = HomeAPIManager()

    func serviceCallToGetHome(_ isLoader : Bool, _ completion: @escaping (_ result : [String : Any]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_HOME, [String : Any](), isLoader) { (dict) in
            printData(dict)
            completion(dict)
        }
    }
    
    func serviceCallToGetCategory() {
        APIManager.shared.callPostRequest(API.GET_CATEGORY, ["cat_id" : 0], false) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    var arrCategory = [CategoryModel]()
                    for temp in data {
                        arrCategory.append(CategoryModel.init(temp))
                    }
                    setCategoryData(arrCategory)
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CATEGORY_LIST), object: nil)
                }
            }
        }
    }
    
    func serviceCallToGetSubCategory(_ id : Int, _ completion: @escaping (_ result : [[String : Any]]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_CATEGORY, ["cat_id" : id], true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToGetProductList(_ param : [String : Any], _ isLoader : Bool, _ completion: @escaping (_ result : [[String : Any]], _ total : Int) -> Void) {
        APIManager.shared.callPostRequest(API.GET_PRODUCT_LIST, param, isLoader) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let tempDict = dict["data"] as? [String : Any] {
                    if let tempData = tempDict["products"] as? [[String : Any]] {
                        if let total_products = tempDict["total_products"] as? Int {
                            completion(tempData, total_products)
                        }
                    }
                }
            }
        }
    }
    
    func serviceCallToGetPavilionCategory(_ id : Int, _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        APIManager.shared.callPostRequest(API.GET_PAVILION_CATEGORY, ["pavilions_id" : id], true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [[String : Any]] {
                    completion(data)
                }
            }
        }
    }
    
    func serviceCallToSearchProductList(_ search : String, _ isLoader : Bool, _ completion: @escaping (_ result : [[String : Any]]) -> Void) {
        APIManager.shared.callPostRequest(API.SEARCH_PRODUCT, ["search" : search], isLoader) { (dict) in
            printData(dict)
            if let data = dict["data"] as? [[String : Any]] {
                completion(data)
                return
            }
        }
    }
}
