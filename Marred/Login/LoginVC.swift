//
//  LoginVC.swift
//  Marred
//
//  Created by Keyur Akbari on 11/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var passwordTxt: TextField!
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var signupBtn: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    func configUI() {
        signupBtn.setAttributedTitle(attributedStringWithColor(getTranslate("signup_button_title"), [getTranslate("signup_button")], color: BlackColor, font: UIFont(name: APP_MEDIUM, size: 12.0)), for: .normal)
        
        if PLATFORM.isSimulator {
            //Buyer
//            emailTxt.text = "FV500@maared24.com"
//            passwordTxt.text = "FO2VR5NJ8W"
//            emailTxt.text = "keyurdakbari@gmail.com"
//            emailTxt.text = "testingakbari@gmail.com"
//            passwordTxt.text = "qqqqqq"
            
            //Seller
//            emailTxt.text = "amishapadasala20@gmail.com"
//            passwordTxt.text = "qqqqqq"
            emailTxt.text = "FV037@maared24.com" //"FV114@maared24.com"
            passwordTxt.text = "CMDDVB227U"//"BCF8FMICTN"
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToShowHidePassword(_ sender: UIButton) {
        passwordBtn.isSelected = !passwordBtn.isSelected
        passwordTxt.isSecureTextEntry = !passwordBtn.isSelected
    }
    
    @IBAction func clickToForgotPassword(_ sender: Any) {
        let vc : ForgotPasswordVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSkip(_ sender: Any) {
        AppDelegate().sharedDelegate().navigateToDashBoard()
    }
    
    @IBAction func clickToSignIn(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed == "" {
            displayToast("enter_email")
        }
        else if !emailTxt.text!.isValidEmail {
            displayToast("invalid_email")
        }
        else if passwordTxt.text?.trimmed == "" {
            displayToast("enter_password")
        }
        else {
            var param = [String : Any]()
            param["user_email"] = emailTxt.text
            param["user_password"] = passwordTxt.text
            param["noti_token"] = getPushToken()
            printData(param)
            LoginAPIManager.shared.serviceCallToLogin(param) {
                AppDelegate().sharedDelegate().navigateToDashBoard()
            }
        }
    }
    
    @IBAction func clickToSignup(_ sender: Any) {
        let vc : SignupVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
