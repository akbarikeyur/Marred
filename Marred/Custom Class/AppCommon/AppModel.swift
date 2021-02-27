//
//  AppModel.swift
//  Marred
//
//  Created by Keyur Akbari on 26/06/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class AppModel: NSObject {
    
    static let shared = AppModel()
    var currentUser : UserModel!
    var CART_COUNT : Int!
    
    func resetData() {
        currentUser = UserModel.init([String : Any]())
        CART_COUNT = 0
    }
    
    func getCategoryArrOfDictionary(arr:[CategoryModel]) -> [[String:Any]] {
        let len:Int = arr.count
        var retArr:[[String:Any]] =  [[String:Any]] ()
        for i in 0..<len{
            retArr.append(arr[i].dictionary())
        }
        return retArr
    }
    
    func getProductArrOfDictionary(arr:[ProductModel]) -> [[String:Any]] {
        let len:Int = arr.count
        var retArr:[[String:Any]] =  [[String:Any]] ()
        for i in 0..<len{
            retArr.append(arr[i].dictionary())
        }
        return retArr
    }
    
    func getIntData(_ dict : [String : Any], _ key : String) -> Int {
        var value = 0
        if let temp = dict[key] as? Int {
            value = temp
        }
        else if let temp = dict[key] as? String, temp != "" {
            value = Int(temp)!
        }
        return value
    }
    
    func getStringData(_ dict : [String : Any], _ key : String) -> String {
        var value = ""
        if let temp = dict[key] as? String {
            value = temp
        }
        else if let temp = dict[key] as? Int {
            value = String(temp)
        }
        return value
    }
    
    func getDoubleData(_ dict : [String : Any], _ key : String) -> Double {
        var value = 0.0
        if let temp = dict[key] as? Double {
            value = temp
        }
        else if let temp = dict[key] as? Int {
            value = Double(temp)
        }
        else if let temp = dict[key] as? String, temp != "" {
            value = Double(temp)!
        }
        return value
    }
}

struct CountryModel {
    var name, dial_code, code : String!
    
    init(_ dict : [String : Any]) {
        name = dict["name"] as? String ?? ""
        dial_code = dict["dial_code"] as? String ?? ""
        code = dict["code"] as? String ?? ""
    }
}
