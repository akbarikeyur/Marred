//
//  MyAddressTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit
import DropDown

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
    var arrCountry = [CountryModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        for temp in getJsonFromFile("country") {
            arrCountry.append(CountryModel.init(temp))
        }
    }
    
    func setupDetails(_ dict : AddressModel) {
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
    
    @IBAction func clickToSelectCountry(_ sender: UIButton) {
        self.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.semanticContentAttribute = isArabic() ? .forceLeftToRight : .forceRightToLeft
        var arrData = [String]()
        for temp in arrCountry {
            arrData.append(temp.name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.countryTxt.text = item
        }
        dropDown.show()
    }
    
    @IBAction func clickToUpdate(_ sender: Any) {
        self.endEditing(true)
        if fnameTxt.text?.trimmed == "" {
            displayToast("enter_fname")
        }
        else if lnameTxt.text?.trimmed == "" {
            displayToast("enter_lname")
        }
        else if companyTxt.text?.trimmed == "" {
            displayToast("enter_company_name")
        }
        else if address1Txt.text?.trimmed == "" {
            displayToast("enter_address")
        }
        else if countryTxt.text?.trimmed == "" {
            displayToast("enter_country")
        }
        else if stateTxt.text?.trimmed == "" {
            displayToast("enter_state")
        }
        else if cityTxt.text?.trimmed == "" {
            displayToast("enter_city")
        }
        else if postcodeTxt.text?.trimmed == "" {
            displayToast("enter_postal_code")
        }
        else if emailTxt.text?.trimmed == "" {
            displayToast("enter_email")
        }
        else if !emailTxt.text!.isValidEmail {
            displayToast("invalid_email")
        }
        else if phoneTxt.text?.trimmed == "" {
            displayToast("enter_phone")
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
//            if index == 0 {
//                newParam["billing"] = param
//            }else{
                newParam["shipping"] = param
//            }
            newParam["email"] = AppModel.shared.currentUser.user_email
            newParam["first_name"] = fnameTxt.text
            newParam["last_name"] = lnameTxt.text
            newParam["username"] = AppModel.shared.currentUser.user_nicename
            DashboardAPIManager.shared.serviceCallToSetAddress(newParam) { (dic) in
                displayToast("address_success_msg")
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
