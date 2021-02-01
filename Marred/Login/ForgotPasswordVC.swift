//
//  ForgotPasswordVC.swift
//  Marred
//
//  Created by Keyur Akbari on 11/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToResetPassword(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed == "" {
            displayToast("enter_email")
        }
        else if !emailTxt.text!.isValidEmail {
            displayToast("invalid_email")
        }
        else {
            LoginAPIManager.shared.serviceCallToForgotPassword(["email" : emailTxt.text!]) {
                self.navigationController?.popViewController(animated: true)
            }
        }
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
