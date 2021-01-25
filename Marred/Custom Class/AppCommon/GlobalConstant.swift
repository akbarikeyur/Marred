//
//  GlobalConstant.swift
//  Marred
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import Foundation
import UIKit

let APP_VERSION = 1.0
let BUILD_VERSION = 1
let DEVICE_ID = UIDevice.current.identifierForVendor?.uuidString

let ITUNES_URL = ""
let CURRENCY = "د.إ"


struct SCREEN
{
    static var WIDTH = UIScreen.main.bounds.size.width
    static var HEIGHT = UIScreen.main.bounds.size.height
}

struct DEVICE {
    static var IS_IPHONE_X = (fabs(Double(SCREEN.HEIGHT - 812)) < Double.ulpOfOne)
}

struct IMAGE {
    static var PLACEHOLDER = "ic_placeholder"
    static var PRODUCT_PLACEHOLDER = "product_placeholder_small"
    
}

struct STORYBOARD {
    static var MAIN = UIStoryboard(name: "Main", bundle: nil)
    static var PRODUCT = UIStoryboard(name: "Product", bundle: nil)
    static var DASHBOARD = UIStoryboard(name: "Dashboard", bundle: nil)
}

struct NOTIFICATION {
    static var UPDATE_CURRENT_USER_DATA     =   "UPDATE_CURRENT_USER_DATA"
    static var REDICT_TAB_BAR               =   "REDICT_TAB_BAR"
    static var NOTIFICATION_TAB_CLICK       =   "NOTIFICATION_TAB_CLICK"
    static var SELECT_CATEGORY_CLICK        =   "SELECT_CATEGORY_CLICK"
    
    static var UPDATE_CATEGORY_LIST         =   "UPDATE_CATEGORY_LIST"
    static var REDIRECT_CONTACT_US          =   "REDIRECT_CONTACT_US"
}

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
