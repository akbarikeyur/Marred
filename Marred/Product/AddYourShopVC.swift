//
//  AddYourShopVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit
import DropDown

class AddYourShopVC: UIViewController {

    @IBOutlet weak var fnameTxt: TextField!
    @IBOutlet weak var lnameTxt: TextField!
    @IBOutlet weak var businessNameTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var phoneFlagImg: UIImageView!
    @IBOutlet weak var phonecodeLbl: Label!
    @IBOutlet weak var phoneTxt: TextField!
    @IBOutlet weak var pavilionFlagImg: UIImageView!
    @IBOutlet weak var pavillionTxt: TextField!
    @IBOutlet weak var categoryTxt: TextField!
    @IBOutlet weak var requestTxtview: TextView!
    
    var arrCountry = [CountryModel]()
    var arrCategory = getCategoryData()
    var arrPavilion = [PavilionModel]()
    var selectedCategory = CategoryModel.init([String : Any]())
    var selectedPavilion = PavilionModel.init([String : Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    func setupDetail() {
        fnameTxt.text = AppModel.shared.currentUser.display_name
        emailTxt.text = AppModel.shared.currentUser.user_email
        for temp in getJsonFromFile("country") {
            arrCountry.append(CountryModel.init(temp))
        }
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let index = arrCountry.firstIndex { (temp) -> Bool in
                temp.code.lowercased() == countryCode.lowercased()
            }
            if index != nil {
                phoneFlagImg.image = UIImage(named: arrCountry[index!].code.lowercased())
                phonecodeLbl.text = arrCountry[index!].dial_code
            }
        }
        
        for temp in getJsonFromFile("pavilion") {
            arrPavilion.append(PavilionModel.init(temp))
        }
        if arrPavilion.count > 0 {
            selectedPavilion = arrPavilion[0]
            pavilionFlagImg.image = UIImage(named: selectedPavilion.image)
            pavillionTxt.text = selectedPavilion.name
        }
        
        if arrCategory.count > 0 {
            selectedCategory = arrCategory[0]
            categoryTxt.text = selectedCategory.name
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectCoutryCode(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCountry {
            arrData.append(temp.name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.phoneFlagImg.image = UIImage(named: self.arrCountry[index].code.lowercased())
            self.phonecodeLbl.text = self.arrCountry[index].dial_code
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectPavilion(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrPavilion {
            arrData.append(temp.name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedPavilion = self.arrPavilion[index]
            self.pavilionFlagImg.image = UIImage(named: self.selectedPavilion.image)
            self.pavillionTxt.text = self.selectedPavilion.name
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCategory(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCategory {
            arrData.append(temp.name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedCategory = self.arrCategory[index]
            self.categoryTxt.text = self.selectedCategory.name
        }
        dropDown.show()
    }
    
    @IBAction func clickToSend(_ sender: Any) {
        self.view.endEditing(true)
        if fnameTxt.text?.trimmed == "" {
            displayToast("Please enter first name")
        }
        else if lnameTxt.text?.trimmed == "" {
            displayToast("Please enter last name")
        }
        else if businessNameTxt.text?.trimmed == "" {
            displayToast("Please enter business name")
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
        else if pavillionTxt.text?.trimmed == "" {
            displayToast("Please select pavilion")
        }
        else if categoryTxt.text?.trimmed == "" {
            displayToast("Please select category")
        }
        else{
            var param = [String : Any]()
            param["user_id"] = AppModel.shared.currentUser.ID
            param["first_name"] = fnameTxt.text
            param["last_name"] = lnameTxt.text
            param["business_name"] = businessNameTxt.text
            param["email"] = emailTxt.text
            param["phonecode"] = phonecodeLbl.text
            param["phone"] = phoneTxt.text
            param["pavilion"] = String(selectedPavilion.id)
            param["category"] = String(selectedCategory.term_id)
            param["request"] = requestTxtview.text
            printData(param)
            ProductAPIManager.shared.serviceCallToAddShop(param) {
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
