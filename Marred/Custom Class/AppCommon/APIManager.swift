//
//  APIManager.swift
//  Marred
//
//  Created by Keyur Akbari on 01/09/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire


struct API {
    static let BASE_URL = "https://maared24.com/wp-json/"
    
    static let LOGIN                                  =       BASE_URL + "v1/user/signin"
    static let SIGNUP                                 =       BASE_URL + "v1/user/register"
    static let FORGOT_PASSWORD                        =       BASE_URL + "v1/user/forgotpassword"
    static let GET_USER_DETAIL                        =       BASE_URL + "v1/user/getuserdetail"
    
    static let GET_HOME                               =       BASE_URL + "v1/getHomepage"
    
    static let GET_CATEGORY                           =       BASE_URL + "v1/get_cateogories"
    static let GET_PAVILION                           =       BASE_URL + "v1/getGlobalPavilion"
    static let GET_PAVILION_CATEGORY                  =       BASE_URL + "v1/pavilions"
    
    static let SEARCH_PRODUCT                         =       BASE_URL + "v1/user/ProductSearch"
    static let GET_PRODUCT_LIST                       =       BASE_URL + "v1/getProductsByCat"
    static let GET_PRODUCT_DETAIL                     =       BASE_URL + "v1/productDetail"
    
    static let ADD_TO_CART                            =       BASE_URL + "cocart/v1/add-item"
    static let CLEAR_CART                             =       BASE_URL + "cocart/v1/clear"
    static let GET_CART_COUNT                         =       BASE_URL + "cocart/v1/count-items"
    static let GET_CART                               =       BASE_URL + "v1/cocart/custom/get-cart"
    
    static let APPLY_COUPON                           =       BASE_URL + "wc/v3/coupons?code="
    static let GET_PAYMENT_GATEWAY                    =       BASE_URL + "wc/v3/payment_gateways"
    static let CHECKOUT_ORDER                         =       BASE_URL + "wc/v2/orders" //"v1/user/checkout"
    static let CLEAR_FULL_CART                        =       BASE_URL + "cocart/v1/clear"
    
    static let ADD_BOOKMARK                           =       BASE_URL + "v1/bookmark/addbookmark"
    static let REMOVE_BOOKMARK                        =       BASE_URL + "v1/bookmark/removebookmark"
    static let GET_BOOKMARK                           =       BASE_URL + "v1/bookmark/getbookmark"
    
    static let GET_SELLER_DASHBOARD                   =       BASE_URL + "v1/seller/Dashboard"
    static let ADD_SHOP                               =       BASE_URL + "v1/seller/addShop"
    static let DEAL_OF_DAY                            =       BASE_URL + "v1/deal_of_the_day"
    
    static let GET_USER_PRODUCT                       =       BASE_URL + "v1/user/getPorductByUser"
    static let GET_BUYER_ORDER                        =       BASE_URL + "v1/user/getOrders"
    static let GET_SELLER_ORDER                       =       BASE_URL + "v1/user/getVendorOrder"
    static let GET_WITHDRAW_REQUEST                   =       BASE_URL + "v1/seller/getwithDrawRequest"
    
    static let CONTACT_US                             =       BASE_URL + "v1/contactadmin"
    
    static let GET_SET_ADDRESS                        =       BASE_URL + "wc/v2/customers/" + String(AppModel.shared.currentUser.ID)
}

public class APIManager {
    
    static let shared = APIManager()
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func addLangParam(_ strUrl : String) -> String {
        if strUrl.contains("user/getVendorOrder") || strUrl.contains("user/getOrders") {
            return strUrl
        }
        if isArabic() {
            if strUrl.contains("?") {
                return strUrl + "&wpml_language=ar"
            }else{
                return strUrl + "?wpml_language=ar"
            }
        }else{
            if strUrl.contains("?") {
                return strUrl + "&wpml_language=en"
            }else{
                return strUrl + "?wpml_language=en"
            }
        }
    }
    
    func getJsonHeader() -> HTTPHeaders {
        if isUserLogin() {
            return ["Content-Type":"application/json", "Accept":"application/json", "Authorization" : "Bearer " + getApiKey()]
        }else{
            return ["Content-Type":"application/json", "Accept":"application/json"]
        }
    }
    
    func getBasicJson() -> HTTPHeaders {
        if isUserLogin() {
            return ["Content-Type":"application/json", "Accept":"application/json", "Authorization" : "Basic " + getApiKey()]
        }else{
            return ["Content-Type":"application/json", "Accept":"application/json"]
        }
    }
    
    func getMultipartHeader() -> [String:String]{
        if isUserLogin() {
            return ["Content-Type":"multipart/form-data", "Accept":"application/json", "Authorization" : "Bearer " + getApiKey()]
        }else{
            return ["Content-Type":"multipart/form-data", "Accept":"application/json"]
        }
    }
    
    
    func networkErrorMsg()
    {
        removeLoader()
        showAlert("Marred", message: "no_network") {
            
        }
    }
    
    func toJson(_ dict:[String:Any]) -> String {
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString!
    }
    
    func toJson(_ array : [[String:Any]]) -> String {
        var jsonString : String = ""
        do {
            if let postData : NSData = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData {
                jsonString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            }
        } catch {
            print(error)
        }
        return jsonString
    }
    
    func handleError(_ dict : [String : Any])
    {
        if let status = dict["status"] as? String, status == "error" {
            if let message = dict["message"] as? String {
                showAlert("Error", message: message) {}
            }
        }
    }
    
    //MARK:- Get request
    func callGetRequestWithBasicAuthenticate(_ api : String, _ isLoaderDisplay : Bool, _ completion: @escaping (_ result : [String:Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        if isLoaderDisplay {
            showLoader()
        }
        
        Alamofire.request(addLangParam(api), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getJsonHeader()).authenticate(user: "ck_eb581e733c1f69769fa0ca5407cd56f7f7137942", password: "cs_bedc787fb94f3adeffae2e40475b3fbae5812305").responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                if let result = response.result.value as? [String:Any] {
                    completion(result)
                    return
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func callGetRequestWithArrayResponse(_ api : String, _ isLoaderDisplay : Bool, _ completion: @escaping (_ result : [[String:Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        if isLoaderDisplay {
            showLoader()
        }
        
        Alamofire.request(addLangParam(api), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getBasicJson()).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                if let result = response.result.value as? [[String:Any]] {
                    completion(result)
                    return
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func callGetRequest(_ api : String, _ isLoaderDisplay : Bool, _ completion: @escaping (_ result : [String:Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        if isLoaderDisplay {
            showLoader()
        }
        
        Alamofire.request(addLangParam(api), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getJsonHeader()).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                if let result = response.result.value as? [String:Any] {
                    completion(result)
                    return
                }
                else if let result = response.result.value as? [[String:Any]] {
                    completion(["data" : result])
                    return
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Put Request
    func callPutRequest(_ api : String, _ param : [String : Any], _ isLoaderDisplay : Bool, _ completion: @escaping (_ result : [String:Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        if isLoaderDisplay {
            showLoader()
        }
        
        Alamofire.request(addLangParam(api), method: .put, parameters: param, encoding: JSONEncoding.default, headers: getJsonHeader()).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                if let result = response.result.value as? [String:Any] {
                    completion(result)
                    return
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
        /*
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: addLangParam(api), method: .put, headers: getJsonHeader()) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    printData("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    removeLoader()
                    if let result = response.result.value as? [String:Any] {
                        completion(result)
                        return
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        return
                    }
                }
            case .failure(let error):
                removeLoader()
                printData(error.localizedDescription)
                break
            }
        }
        */
    }
    
    //MARK:- Post request
    func callPostRequestWithBasicAuth(_ api : String, _ params : [String : Any], _ isLoaderDisplay : Bool, _ completion: @escaping (_ result : [String:Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        if isLoaderDisplay {
            showLoader()
        }
        
        Alamofire.request(addLangParam(api), method: .post, parameters: params, encoding: JSONEncoding.default, headers: getJsonHeader()).authenticate(user: "ck_eb581e733c1f69769fa0ca5407cd56f7f7137942", password: "cs_bedc787fb94f3adeffae2e40475b3fbae5812305").responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                if let result = response.result.value as? [String:Any] {
                    completion(result)
                    return
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func callPostRequest(_ api : String, _ params : [String : Any], _ isLoaderDisplay : Bool, _ completion: @escaping (_ result : [String:Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        if isLoaderDisplay {
            showLoader()
        }
        printData(addLangParam(api))
        Alamofire.request(addLangParam(api), method: .post, parameters: params, encoding: JSONEncoding.default, headers: getJsonHeader()).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                if let result = response.result.value as? [String:Any] {
                    completion(result)
                    return
                }
                else if let result = response.result.value as? [[String:Any]], result.count > 0 {
                    completion(["data" : result])
                    return
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    
    //MARK:- Multipart request
    func callMultipartRequest(_ api : String, _ params : [String : Any], _ isLoaderDisplay : Bool, _ completion: @escaping (_ result : [String:Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        if isLoaderDisplay {
            showLoader()
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: addLangParam(api), method: .post, headers: getJsonHeader()) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    printData("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    removeLoader()
                    if let result = response.result.value as? [String:Any] {
                        completion(result)
                        return
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        return
                    }
                }
            case .failure(let error):
                removeLoader()
                printData(error.localizedDescription)
                break
            }
        }
    }
    
    func callMultipartRequestWithImage(_ api : String, _ params : [String : Any], _ arrImg : [UIImage?], _ imgName : String, _ isLoaderDisplay : Bool, _ completion: @escaping (_ result : [String:Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        if isLoaderDisplay {
            showLoader()
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            for temp in arrImg {
                if let image = temp {
                    if let imageData = image.jpegData(compressionQuality: 1.0) {
                        multipartFormData.append(imageData, withName: imgName, fileName: (imgName + ".jpg"), mimeType: "image/jpg")
                    }
                }
            }
        }, usingThreshold: UInt64.init(), to: addLangParam(api), method: .post, headers: getMultipartHeader()) { (result) in
            switch result{
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        printData("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        removeLoader()
                        if let result = response.result.value as? [String:Any] {
                            completion(result)
                            return
                        }
                        else if let error = response.error{
                            displayToast(error.localizedDescription)
                            return
                        }
                    }
                case .failure(let error):
                    removeLoader()
                    printData(error.localizedDescription)
                    break
            }
        }
    }
}
