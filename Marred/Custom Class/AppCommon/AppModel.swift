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
    
    func resetData() {
        currentUser = UserModel.init([String : Any]())
    }
    
//    func getPropertyTypeArrOfDictionary(arr:[PropertyTypeModel]) -> [[String:Any]] {
//        let len:Int = arr.count
//        var retArr:[[String:Any]] =  [[String:Any]] ()
//        for i in 0..<len{
//            retArr.append(arr[i].dictionary())
//        }
//        return retArr
//    }
    
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
