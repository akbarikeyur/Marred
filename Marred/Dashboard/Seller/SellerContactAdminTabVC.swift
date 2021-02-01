//
//  SellerContactAdminTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 17/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SellerContactAdminTabVC: UIViewController {

    @IBOutlet weak var fnameTxt: TextField!
    @IBOutlet weak var lnameTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var messageTxtView: TextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupData()
    }
    
    func setupDetails() {
        
    }
    
    func resetData() {
        fnameTxt.text = ""
        lnameTxt.text = ""
        emailTxt.text = ""
        messageTxtView.text = ""
    }
    
    func setupData() {
        resetData()
        if AppModel.shared.currentUser.display_name.contains(" ") {
            let arrTemp = AppModel.shared.currentUser.display_name.components(separatedBy: " ")
            fnameTxt.text = arrTemp[0]
            lnameTxt.text = arrTemp[1]
        }
        emailTxt.text = AppModel.shared.currentUser.user_email
    }
    
    //MARK:- Button click event
    @IBAction func clickToSend(_ sender: Any) {
        self.view.endEditing(true)
        if fnameTxt.text?.trimmed == "" {
            displayToast("enter_fname")
        }
        else if lnameTxt.text?.trimmed == "" {
            displayToast("enter_lname")
        }
        else if emailTxt.text?.trimmed == "" {
            displayToast("enter_email")
        }
        else if !emailTxt.text!.isValidEmail {
            displayToast("invalid_email")
        }
        else if messageTxtView.text?.trimmed == "" {
            displayToast("enter_message")
        }
        else{
            var param = [String : Any]()
            param["user_id"] = AppModel.shared.currentUser.ID
            param["first_name"] = fnameTxt.text
            param["last_name"] = lnameTxt.text
            param["email"] = emailTxt.text
            param["user_message"] = messageTxtView.text
            
            DashboardAPIManager.shared.serviceCallToContactUs(param) {
                self.resetData()
                showAlert("contact_admin_title", message: "contact_admin_message") {
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.NOTIFICATION_TAB_CLICK), object: ["tabIndex" : 0])
                }
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
