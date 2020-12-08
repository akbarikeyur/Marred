//
//  Fonts.swift
//  Marred
//
//  Created by Keyur on 22/05/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import Foundation
import UIKit

let APP_REGULAR = "Roboto-Regular"
let APP_MEDIUM = "Roboto-Medium"
let APP_BOLD = "Roboto-Bold"
let APP_ITALIC = "Roboto-Italic"
let APP_LIGHT = "Roboto-Light"

enum FontType : String {
    case Clear = ""
    case ARegular = "ar"
    case AMedium = "am"
    case ABold = "ab"
    case AItalic = "ai"
    case ALight = "al"
}


extension FontType {
    var value: String {
        get {
            switch self {
                case .Clear:
                    return APP_REGULAR
                case .ARegular:
                    return APP_REGULAR
                case .AMedium:
                    return APP_MEDIUM
                case .ABold:
                    return APP_BOLD
                case .AItalic:
                    return APP_ITALIC
                case .ALight:
                    return APP_LIGHT
            }
        }
    }
}

