//
//  LoginAPIManager.swift
//  Marred
//
//  Created by Keyur Akbari on 11/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import Foundation

public class LoginAPIManager {

    static let shared = LoginAPIManager()

    func serviceCallToLogin(_ param : [String : Any], _ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequest(API.LOGIN, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [String : Any] {
                    if let tempDict = data["data"] as? [String : Any] {
                        AppModel.shared.currentUser = UserModel.init(tempDict)
                        setLoginUserData()
                        completion()
                        return
                    }
                }
            }
        }
    }
    
    func serviceCallToSignup(_ param : [String : Any], _ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequestWithBasicAuth(API.SIGNUP, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? String {
                    if data == "success" {
                        completion()
                        return
                    }else{
                        displayToast(data)
                    }
                }
            }
        }
    }
    
    func serviceCallToForgotPassword(_ param : [String : Any], _ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequest(API.FORGOT_PASSWORD, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                completion()
                return
            }
        }
    }
    
    func serviceCallToGetUserDetail(_ param : [String : Any], _ completion: @escaping () -> Void) {
        APIManager.shared.callPostRequest(API.GET_USER_DETAIL, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String, status == "success" {
                if let data = dict["data"] as? [String : Any] {
                    if let tempDict = data["data"] as? [String : Any] {
                        AppModel.shared.currentUser = UserModel.init(tempDict)
                        setLoginUserData()
                        completion()
                        return
                    }
                }
            }
        }
    }
}
