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

    func serviceCallToGetCategory() {
        APIManager.shared.callGetRequest(API.GET_CATEGORY, false) { (data) in
            printData(data)
            var arrCategory = [CategoryModel]()
            for temp in data {
                arrCategory.append(CategoryModel.init(temp))
            }
            setCategoryData(arrCategory)
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CATEGORY_LIST), object: nil)
        }
    }
    
    func serviceCallToGetSubCategory(_ id : Int, _ completion: @escaping (_ result : [[String:Any]]) -> Void) {
        let strUrl = API.GET_CATEGORY + "?parent=" + String(id)
        APIManager.shared.callGetRequest(strUrl, true) { (data) in
            printData(data)
            completion(data)
        }
    }
}
