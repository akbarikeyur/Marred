//
//  Preference.swift
//  Marred
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

class Preference: NSObject {

    static let sharedInstance = Preference()
}


func setDataToPreference(data: AnyObject, forKey key: String)
{
    UserDefaults.standard.set(data, forKey: MD5(key))
    UserDefaults.standard.synchronize()
}

func getDataFromPreference(key: String) -> AnyObject?
{
    return UserDefaults.standard.object(forKey: MD5(key)) as AnyObject?
}

func removeDataFromPreference(key: String)
{
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

func removeUserDefaultValues()
{
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
}

//MARK: - Access Token
func setApiKey(_ token: String)
{
    setDataToPreference(data: token as AnyObject, forKey: "user_access_token")
}

func getApiKey() -> String
{
    if let token : String = getDataFromPreference(key: "user_access_token") as? String
    {
        return token
    }
    return ""
}



//MARK: - Login
func setCategoryData(_ data : [CategoryModel])
{
    var arrData = [[String : Any]]()
    for temp in data {
        arrData.append(temp.dictionary())
    }
    setDataToPreference(data: arrData as AnyObject, forKey: "category_data")
    setIsUserLogin(true)
}

func getCategoryData() -> [CategoryModel]
{
    var arrCategory = [CategoryModel]()
    if let data : [[String : Any]] = getDataFromPreference(key: "category_data") as? [[String : Any]] {
        for temp in data {
            arrCategory.append(CategoryModel.init(temp))
        }
        return arrCategory
    }
    return arrCategory
}

func setIsUserLogin(_ value: Bool)
{
    setDataToPreference(data: value as AnyObject, forKey: "is_user_login")
}

func isUserLogin() -> Bool
{
    if let value : Bool = getDataFromPreference(key: "is_user_login") as? Bool
    {
        return value
    }
    return false
}
