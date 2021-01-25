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
        signupBtn.setAttributedTitle(attributedStringWithColor("If not a member yet, Sign up", ["Sign up"], color: BlackColor, font: UIFont(name: APP_MEDIUM, size: 12.0)), for: .normal)
        
        if PLATFORM.isSimulator {
//            emailTxt.text = "FV500@maared24.com"
//            passwordTxt.text = "FO2VR5NJ8W"
//            emailTxt.text = "keyurdakbari@gmail.com"
            emailTxt.text = "amishapadasala20@gmail.com"
            passwordTxt.text = "qqqqqq"
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
    
    @IBAction func clickToSignIn(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed == "" {
            displayToast("Please enter email")
        }
        else if !emailTxt.text!.isValidEmail {
            displayToast("Invalid email")
        }
        else if passwordTxt.text?.trimmed == "" {
            displayToast("Please enter password")
        }
        else {
            var param = [String : Any]()
            param["user_email"] = emailTxt.text
            param["user_password"] = passwordTxt.text
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
