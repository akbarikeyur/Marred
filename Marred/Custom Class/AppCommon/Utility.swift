//
//  Utility.swift
//  Marred
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit
import AVFoundation
import SKPhotoBrowser
import SDWebImage
import SafariServices
import Toast_Swift

struct PLATFORM {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

//MARK:- Image Function
func compressImage(_ image: UIImage, to toSize: CGSize) -> UIImage {
    var actualHeight: Float = Float(image.size.height)
    var actualWidth: Float = Float(image.size.width)
    let maxHeight: Float = Float(toSize.height)
    //600.0;
    let maxWidth: Float = Float(toSize.width)
    //800.0;
    var imgRatio: Float = actualWidth / actualHeight
    let maxRatio: Float = maxWidth / maxHeight
    //50 percent compression
    if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
        }
        else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
        }
        else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }
    }
    let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    let imageData1: Data? = img?.jpegData(compressionQuality: 1.0)//UIImageJPEGRepresentation(img!, CGFloat(1.0))//UIImage.jpegData(img!)
    UIGraphicsEndImageContext()
    return  imageData1 == nil ? image : UIImage(data: imageData1!)!
}


//MARK:- UI Function
func getUrlForImage(_ strUrl : String) -> String
{
    var newStrUrl = strUrl
    if !newStrUrl.contains("http://") && !newStrUrl.contains("https://") {
//        newStrUrl = API.IMAGE_BASE_URL + newStrUrl
    }
    if newStrUrl.contains(" ") {
        newStrUrl = newStrUrl.replacingOccurrences(of: " ", with: "%20")
    }
    return newStrUrl
}


func setImageBackgroundImage(_ imgView : UIImageView, _ strUrl : String, _ placeHolderImg : String)
{
    if strUrl == "" {
        imgView.image = UIImage.init(named: placeHolderImg)
        return
    }
    imgView.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage.init(named: placeHolderImg)) { (image, error, SDImageCacheType, url) in
        if image != nil {
            imgView.image = image
        }else{
            imgView.image = UIImage.init(named: placeHolderImg)
        }
    }
}

func setButtonBackgroundImage(_ button : UIButton, _ strUrl : String, _ placeHolderImg : String)
{
    if strUrl == "" {
        button.setBackgroundImage(UIImage.init(named: placeHolderImg), for: .normal)
        return
    }
    button.sd_setBackgroundImage(with: URL(string: getUrlForImage(strUrl)), for: UIControl.State.normal, completed: { (image, error, SDImageCacheType, url) in
        if image != nil{
            button.setBackgroundImage(image?.imageCropped(toFit: CGSize(width: button.frame.size.width, height: button.frame.size.height)), for: .normal)
        }
        else{
            button.setBackgroundImage(UIImage.init(named: placeHolderImg), for: .normal)
        }
    })
}

func setButtonImage(_ button : UIButton, _ strUrl : String, _ placeholder : String)
{
    if strUrl == "" {
        button.setImage(UIImage.init(named: placeholder), for: .normal)
        return
    }
    button.sd_setBackgroundImage(with: URL(string: getUrlForImage(strUrl)), for: UIControl.State.normal, completed: { (image, error, SDImageCacheType, url) in
        if image != nil{
            button.setImage(image, for: .normal)
        }else{
            button.setImage(UIImage.init(named: placeholder), for: .normal)
        }
    })
}

//MARK:- Toast
func displayToast(_ message:String)
{
    UIApplication.topViewController()?.view.makeToast(getTranslate(message))
}

func printData(_ items: Any..., separator: String = " ", terminator: String = "\n")
{
    #if DEBUG
        print(items)
    #endif
}

func showLoader()
{
     AppDelegate().sharedDelegate().showLoader()
}
func removeLoader()
{
     AppDelegate().sharedDelegate().removeLoader()
}

func showAlertWithOption(_ title:String, message:String, btns:[String] ,completionConfirm: @escaping () -> Void,completionCancel: @escaping () -> Void){
    
    let myAlert = UIAlertController(title:getTranslate(title), message:getTranslate(message), preferredStyle: UIAlertController.Style.alert)
    let rightBtn = UIAlertAction(title: getTranslate(btns[0].lowercased()), style: UIAlertAction.Style.default, handler: { (action) in
        completionCancel()
    })
    let leftBtn = UIAlertAction(title: getTranslate(btns[1].lowercased()), style: UIAlertAction.Style.cancel, handler: { (action) in
        completionConfirm()
    })
    myAlert.addAction(rightBtn)
    myAlert.addAction(leftBtn)
    AppDelegate().sharedDelegate().window?.rootViewController?.present(myAlert, animated: true, completion: nil)
}

func showAlert(_ title:String, message:String, completion: @escaping () -> Void) {
    
    let myAlert = UIAlertController(title:getTranslate(title), message:getTranslate(message), preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: getTranslate("ok_button"), style: UIAlertAction.Style.cancel, handler:{ (action) in
        completion()
    })
    myAlert.addAction(okAction)
    AppDelegate().sharedDelegate().window?.rootViewController?.present(myAlert, animated: true, completion: nil)
}

func displaySubViewtoParentView(_ parentview: UIView! , subview: UIView!)
{
    subview.translatesAutoresizingMaskIntoConstraints = false
    parentview.addSubview(subview);
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
    parentview.layoutIfNeeded()
}

func displaySubViewWithScaleOutAnim(_ view:UIView){
    view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
    view.alpha = 1
    UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1.0, options: [], animations: {() -> Void in
        view.transform = CGAffineTransform.identity
    }, completion: {(_ finished: Bool) -> Void in
    })
}

func displaySubViewWithScaleInAnim(_ view:UIView){
    UIView.animate(withDuration: 0.25, animations: {() -> Void in
        view.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        view.alpha = 0.0
    }, completion: {(_ finished: Bool) -> Void in
        view.removeFromSuperview()
    })
}

//MARK:- Delay Features
func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

//MARK:- Open Url
func openUrlInSafari(strUrl : String)
{
    if strUrl.trimmed == "" {
        return
    }
    var newStrUrl = strUrl
    if !newStrUrl.contains("http://") && !newStrUrl.contains("https://") {
        newStrUrl = "http://" + strUrl
    }
    if let url = URL(string: newStrUrl) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: url, configuration: config)
                UIApplication.topViewController()!.present(vc, animated: true)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.open(url, options: [:]) { (isOpen) in
                    printData(isOpen)
                }
            }
        }
    }
}

//MARK:- Call
func redirectToPhoneCall(_ strNumber : String)
{
    if strNumber == "" {
        displayToast("invalid_phone")
        return
    }
    guard let url = URL(string: "tel://\(strNumber)") else {
        displayToast("invalid_phone")
        return
    }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url)
    } else {
        UIApplication.shared.openURL(url)
    }
}

//MARK:- Email
func redirectToEmail(_ email : String)
{
    if email == "" || !email.isValidEmail {
        displayToast("invalid_email")
        return
    }
    guard let url = URL(string: "mailto:\(email)") else {
        displayToast("invalid_email")
        return
    }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url)
    } else {
        UIApplication.shared.openURL(url)
    }
}

//MARK:- Color function
func colorFromHex(hex : String) -> UIColor
{
    return colorWithHexString(hex, alpha: 1.0)
}

func colorFromHex(hex : String, alpha:CGFloat) -> UIColor
{
    return colorWithHexString(hex, alpha: alpha)
}

func colorWithHexString(_ stringToConvert:String, alpha:CGFloat) -> UIColor {
    
    var cString:String = stringToConvert.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: alpha
    )
}

func imageFromColor(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    
    let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}

//MARK:- Attribute string
func attributedStringWithColor(_ mainString : String, _ strings: [String], color: UIColor, font: UIFont? = nil) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: mainString)
    for string in strings {
        let range = (mainString as NSString).range(of: string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        if font != nil {
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
        }
    }
    return attributedString
}

func attributeStringStrikeThrough(_ mainString : String) -> NSAttributedString
{
    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: mainString)
    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
    return attributeString
}

func getAttributeStringWithColor(_ main_string : String, _ substring : [String], color : UIColor?, font : UIFont?, isUnderLine : Bool) -> NSMutableAttributedString
{
    let attribute = NSMutableAttributedString.init(string: main_string)
    
    for sub_string in substring{
        let range = (main_string as NSString).range(of: sub_string)
        if let newColor = color{
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: newColor , range: range)
        }
        if let newFont = font {
            attribute.addAttribute(NSAttributedString.Key.font, value: newFont , range: range)
        }
        
        if isUnderLine{
            attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
            if let newColor = color{
                attribute.addAttribute(NSAttributedString.Key.underlineColor , value: newColor, range: range)
            }
        }
    }
    
    return attribute
}

func attributedStringWithBackgroundColor(_ mainString : String, _ strings: [String], bgcolor: UIColor, font: UIFont? = nil) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: mainString)
    for string in strings {
        let range = (mainString as NSString).range(of: string)
        attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: bgcolor, range: range)
        if font != nil {
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
        }
    }
    return attributedString
}

//MARK:- Display full image
func displayFullScreenImage(_ arrImg : [String], _ index : Int) {
    var images = [SKPhoto]()
    for temp in arrImg {
        let photo = SKPhoto.photoWithImageURL(temp)
        photo.shouldCachePhotoURLImage = true
        images.append(photo)
    }
    // 2. create PhotoBrowser Instance, and present.
    let browser = SKPhotoBrowser(photos: images)
    browser.initializePageIndex(index)
    UIApplication.topViewController()!.present(browser, animated: true, completion: {})
}

//MARK:- Localization
func getTranslate(_ str : String) -> String
{
    return NSLocalizedString(str, comment: "")
}

//MARK:- Get Json from file
func getJsonFromFile(_ file : String) -> [[String : Any]]
{
    if let filePath = Bundle.main.path(forResource: file, ofType: "json"), let data = NSData(contentsOfFile: filePath) {
        do {
            if let json : [[String : Any]] = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String : Any]] {
                return json
            }
        }
        catch {
            //Handle error
        }
    }
    return [[String : Any]]()
}

//MARK:- Placeholder color
func setTextFieldPlaceholderColor(_ textField : UITextField, _ color : UIColor)
{
    if textField.placeholder != "" {
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

func setupButtonHighlightEffect(_ button : UIButton, _ normalBGColor : UIColor, _ highlightBGColor : UIColor)
{
    button.setTitleColor(highlightBGColor, for: .normal)
    button.setTitleColor(normalBGColor, for: .highlighted)
    button.setBackgroundImage(imageFromColor(color: normalBGColor), for: .normal)
    button.setBackgroundImage(imageFromColor(color: highlightBGColor), for: .highlighted)
}

func displayPriceWithCurrency(_ price : String) -> String {
    return getTranslate("currency_aed") + price
}

func displayDiscountPriceWithCurrency(_ price : String, _ discount : Int) -> String {
    let newPrice = Float(price)! - (Float(price)! * Float(discount) / 100)
    return String(newPrice) + getTranslate("currency_aed")
}

func getDiscountPrice(_ price : Float, _ discount : Int) -> Float {
    let newPrice = price - (price * Float(discount) / 100)
    return newPrice
}

func getStockStatus(_ status : String) -> String {
    if status == "instock" {
        return getTranslate("instock_status")
    }
    else {
        return getTranslate("out_of_stock_status")
    }
}

func getStockStatusColor(_ status : String) -> UIColor {
    if status == "instock" {
        return GreenColor
    }
    else {
        return UIColor.red
    }
}

func isArabic() -> Bool {
    if Locale.current.languageCode == "ar" {
        return true
    }
    return false
}
