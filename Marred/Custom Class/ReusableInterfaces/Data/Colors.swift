//
//  Colors.swift
//  Marred
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

var ClearColor = UIColor.clear
var BlackColor = colorFromHex(hex: "000000")
var WhiteColor = colorFromHex(hex: "FFFFFF")
var DarkTextColor = colorFromHex(hex: "4E586E")
var YellowColor = colorFromHex(hex: "FBF908")
var DarkYellowColor = colorFromHex(hex: "FBDA2D")
var GrayColor = colorFromHex(hex: "707070")
var GreenColor = colorFromHex(hex: "669900")
var BorderColor = colorFromHex(hex: "C1C1C1")
var LightBorderColor = colorFromHex(hex: "D5D5D5")
var LightTextColor = colorFromHex(hex: "858585")
var OrangeColor = colorFromHex(hex: "FE604D")

enum ColorType : Int32 {
    case Clear = 0
    case Black = 1
    case White = 2
    case DarkText = 3
    case Yellow = 4
    case DarkYellow = 5
    case Gray = 6
    case Green = 7
    case Border = 8
    case LightBorder = 9
    case LightText = 10
    case Orange = 11
}

extension ColorType {
    var value: UIColor {
        get {
            switch self {
                case .Clear:
                    return ClearColor
                case .Black:
                    return BlackColor
                case .White:
                    return WhiteColor
                case .DarkText:
                    return DarkTextColor
                case .Yellow:
                    return YellowColor
                case .DarkYellow:
                    return DarkYellowColor
                case .Gray:
                    return GrayColor
                case .Green:
                    return GreenColor
                case .Border:
                    return BorderColor
                case .LightBorder:
                    return LightBorderColor
                case .LightText:
                    return LightTextColor
                case .Orange:
                    return OrangeColor
            }
        }
    }
}

enum GradientColorType : Int32 {
    case Clear = 0
    case Login = 1
}

extension GradientColorType {
    var layer : GradientLayer {
        get {
            let gradient = GradientLayer()
            switch self {
            case .Clear: //0
                gradient.frame = CGRect.zero
            case .Login: //1
                gradient.colors = [
                    colorFromHex(hex: "FD7F5E").cgColor,
                    colorFromHex(hex: "FF625F").cgColor
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint.zero
                gradient.endPoint = CGPoint(x: 1, y: 0)
            }
            
            return gradient
        }
    }
}


enum GradientColorTypeForView : Int32 {
    case Clear = 0
    case App = 1
}


extension GradientColorTypeForView {
    var layer : GradientLayer {
        get {
            let gradient = GradientLayer()
            switch self {
            case .Clear: //0
                gradient.frame = CGRect.zero
            case .App: //1
                gradient.colors = [
                    colorFromHex(hex: "FD7F5E").cgColor,
                    colorFromHex(hex: "FF625F").cgColor
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint.zero
                gradient.endPoint = CGPoint(x: 1, y: 0)
            }
            
            return gradient
        }
    }
}

