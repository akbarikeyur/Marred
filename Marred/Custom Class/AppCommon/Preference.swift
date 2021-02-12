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

//MARK: - Push notification device token
func setPushToken(_ token: String)
{
    setDataToPreference(data: token as AnyObject, forKey: "PUSH_DEVICE_TOKEN")
}

func getPushToken() -> String
{
    if let token : String = getDataFromPreference(key: "PUSH_DEVICE_TOKEN") as? String
    {
        return token
    }
    return AppDelegate().sharedDelegate().getFCMToken()
}

//MARK: - Login
func setCategoryData(_ data : [CategoryModel])
{
    var arrData = [[String : Any]]()
    for temp in data {
        arrData.append(temp.dictionary())
    }
    setDataToPreference(data: arrData as AnyObject, forKey: "category_data")
    setSynchDateCategory()
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

func setLoginUserData()
{
    if AppModel.shared.currentUser != nil && AppModel.shared.currentUser.ID != 0 {
        setDataToPreference(data: AppModel.shared.currentUser.dictionary() as AnyObject, forKey: "login_user_data")
        setIsUserLogin(true)
        if AppModel.shared.currentUser.token != "" {
            setApiKey(AppModel.shared.currentUser.token)
        }
    }
}

func getLoginUserData() -> UserModel
{
    if let dict : [String : Any] = getDataFromPreference(key: "login_user_data") as? [String : Any]
    {
        return UserModel.init(dict)
    }
    return UserModel.init([String : Any]())
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

func setIsSeller(_ value: Bool)
{
    setDataToPreference(data: value as AnyObject, forKey: "is_user_seller")
}

func isSeller() -> Bool
{
    if let value : Bool = getDataFromPreference(key: "is_user_seller") as? Bool
    {
        return value
    }
    return false
}

func setHomeBannerData(_ data: [String])
{
    setDataToPreference(data: data as AnyObject, forKey: "home_banner_data")
}

func getHomeBannerData() -> [String]
{
    if let data : [String] = getDataFromPreference(key: "home_banner_data") as? [String]
    {
        return data
    }
    return [String]()
}

func setHomePavalionData(_ data: [HomeModel])
{
    var arrData = [[String : Any]]()
    for temp in data {
        arrData.append(temp.dictionary())
    }
    setDataToPreference(data: arrData as AnyObject, forKey: "home_pavilion_data")
}

func getHomePavalionData() -> [HomeModel]
{
    var arrData = [HomeModel]()
    if let data : [[String : Any]] = getDataFromPreference(key: "home_pavilion_data") as? [[String : Any]]
    {
        for temp in data {
            arrData.append(HomeModel.init(temp))
        }
    }
    return arrData
}

func setPavilionData(_ data: [PavilionModel])
{
    var arrData = [[String : Any]]()
    for temp in data {
        arrData.append(temp.dictionary())
    }
    setDataToPreference(data: arrData as AnyObject, forKey: "pavilion_data")
    setSynchDatePavilion()
}

func getPavilionData() -> [PavilionModel]
{
    var arrData = [PavilionModel]()
    if let data : [[String : Any]] = getDataFromPreference(key: "pavilion_data") as? [[String : Any]]
    {
        for temp in data {
            arrData.append(PavilionModel.init(temp))
        }
    }
    return arrData
}

//Address
func setBillingAddress(_ dict : AddressModel) {
    setDataToPreference(data: dict.dictionary() as AnyObject, forKey: "user_billing_address")
}

func getBillingAddress() -> AddressModel {
    var address = AddressModel.init([String : Any]())
    if let data : [String : Any] = getDataFromPreference(key: "user_billing_address") as? [String : Any]
    {
        address = AddressModel.init(data)
    }
    return address
}

func setShippingAddress(_ dict : AddressModel) {
    setDataToPreference(data: dict.dictionary() as AnyObject, forKey: "user_shiping_address")
}

func getShippingAddress() -> AddressModel {
    var address = AddressModel.init([String : Any]())
    if let data : [String : Any] = getDataFromPreference(key: "user_shiping_address") as? [String : Any]
    {
        address = AddressModel.init(data)
    }
    return address
}

func setSynchDateCategory() {
    setDataToPreference(data: getDateStringFromDate(date: Date(), format: "dd-MM-yyyy") as AnyObject, forKey: "synch_date_cat")
}

func isDifferentSynchDateCategory() -> Bool {
    if let strDate : String = getDataFromPreference(key: "synch_date_cat") as? String
    {
        if strDate == getDateStringFromDate(date: Date(), format: "dd-MM-yyyy") {
            return false
        }
    }
    return true
}

func removeSynchDateCategory() {
    removeDataFromPreference(key: "synch_date_cat")
}

func setSynchDatePavilion() {
    setDataToPreference(data: getDateStringFromDate(date: Date(), format: "dd-MM-yyyy") as AnyObject, forKey: "synch_date_pav")
}

func isDifferentSynchDatePavilion() -> Bool {
    if let strDate : String = getDataFromPreference(key: "synch_date_pav") as? String
    {
        if strDate == getDateStringFromDate(date: Date(), format: "dd-MM-yyyy") {
            return false
        }
    }
    return true
}

func removeSynchDatePavilion() {
    removeDataFromPreference(key: "synch_date_pav")
}
