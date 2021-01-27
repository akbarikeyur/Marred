//
//  MyAddressTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit
protocol MyAddressDelegate {
    func updateAddress(_ index : Int, _ dict : AddressModel)
}
class MyAddressTVC: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var fnameTxt: TextField!
    @IBOutlet weak var lnameTxt: TextField!
    @IBOutlet weak var companyTxt: TextField!
    @IBOutlet weak var address1Txt: TextField!
    @IBOutlet weak var address2Txt: TextField!
    @IBOutlet weak var countryTxt: TextField!
    @IBOutlet weak var stateTxt: TextField!
    @IBOutlet weak var cityTxt: TextField!
    @IBOutlet weak var postcodeTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var phoneTxt: TextField!
    
    var index = 0
    var deleagate : MyAddressDelegate?
    var addressDict = AddressModel.init([String : Any]())
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : AddressModel) {
        if PLATFORM.isSimulator {
            addressDict = dict
            fnameTxt.text = "Test"
            lnameTxt.text = "Akbari"
            companyTxt.text = "Testing Company"
            address1Txt.text = "North street"
            address2Txt.text = "Western Plaza"
            countryTxt.text = "India"
            stateTxt.text = "Gujarat"
            cityTxt.text = "Surat"
            postcodeTxt.text = "395006"
            emailTxt.text = "test@gmail.com"
            phoneTxt.text = "+917567080717"
        }else{
            addressDict = dict
            fnameTxt.text = dict.first_name
            lnameTxt.text = dict.last_name
            companyTxt.text = dict.company
            address1Txt.text = dict.address_1
            address2Txt.text = dict.address_2
            countryTxt.text = dict.country
            stateTxt.text = dict.state
            cityTxt.text = dict.city
            postcodeTxt.text = dict.postcode
            emailTxt.text = dict.email
            phoneTxt.text = dict.phone
        }
    }
    
    @IBAction func clickToUpdate(_ sender: Any) {
        if fnameTxt.text?.trimmed == "" {
            displayToast("Please enter first name")
        }
        else if lnameTxt.text?.trimmed == "" {
            displayToast("Please enter last name")
        }
        else if companyTxt.text?.trimmed == "" {
            displayToast("Please enter company name")
        }
        else if address1Txt.text?.trimmed == "" {
            displayToast("Please enter address")
        }
        else if countryTxt.text?.trimmed == "" {
            displayToast("Please enter country")
        }
        else if stateTxt.text?.trimmed == "" {
            displayToast("Please enter state")
        }
        else if cityTxt.text?.trimmed == "" {
            displayToast("Please enter city")
        }
        else if postcodeTxt.text?.trimmed == "" {
            displayToast("Please enter postal code")
        }
        else if emailTxt.text?.trimmed == "" {
            displayToast("Please enter email")
        }
        else if !emailTxt.text!.isValidEmail {
            displayToast("Invalid email")
        }
        else if phoneTxt.text?.trimmed == "" {
            displayToast("Please enter phone number")
        }
        else {
            var param = [String : Any]()
            param["first_name"] = fnameTxt.text
            param["last_name"] = lnameTxt.text
            param["company"] = companyTxt.text
            param["address_1"] = address1Txt.text
            param["address_2"] = address2Txt.text
            param["city"] = cityTxt.text
            param["state"] = stateTxt.text
            param["postcode"] = postcodeTxt.text
            param["country"] = countryTxt.text
            param["email"] = emailTxt.text
            param["phone"] = phoneTxt.text
            print(param)
            
            var newParam = [String : Any]()
            newParam["id"] = AppModel.shared.currentUser.ID
            newParam["firstname"] = fnameTxt.text
            newParam["lastname"] = fnameTxt.text
            newParam["username"] = AppModel.shared.currentUser.user_nicename
            newParam["email"] = AppModel.shared.currentUser.user_email
            newParam["role"] = isSeller() ? "seller" : "customer"
            if index == 0 {
                newParam["billing"] = param
            }else{
                newParam["shipping"] = param
            }
            LoginAPIManager.shared.serviceCallToUpdateUserDetail(newParam) {
                displayToast("Address update successfully.")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addressDict.first_name = fnameTxt.text
        addressDict.last_name = lnameTxt.text
        addressDict.company = companyTxt.text
        addressDict.address_1 = address1Txt.text
        addressDict.address_2 = address2Txt.text
        addressDict.city = cityTxt.text
        addressDict.state = stateTxt.text
        addressDict.postcode = postcodeTxt.text
        addressDict.country = countryTxt.text
        addressDict.email = emailTxt.text
        addressDict.phone = phoneTxt.text
        deleagate?.updateAddress(index, addressDict)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
