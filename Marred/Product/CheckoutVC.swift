//
//  CheckoutVC.swift
//  Marred
//
//  Created by Keyur Akbari on 12/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginLbl: Label!
    @IBOutlet weak var fnameTxt: TextField!
    @IBOutlet weak var lnameTxt: TextField!
    @IBOutlet weak var companyNameTxt: TextField!
    @IBOutlet weak var countryFlagImg: UIImageView!
    @IBOutlet weak var countryTxt: TextField!
    @IBOutlet weak var stateTxt: TextField!
    @IBOutlet weak var addressTxt: TextField!
    @IBOutlet weak var apartmentTxt: TextField!
    @IBOutlet weak var cityTxt: TextField!
    @IBOutlet weak var stateCountryTxt: TextField!
    @IBOutlet weak var phoneFlagImg: UIImageView!
    @IBOutlet weak var phoneCodeLbl: Label!
    @IBOutlet weak var phoneTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var differentAddressBtn: Button!
    @IBOutlet weak var notesTxtView: TextView!
    @IBOutlet weak var orderTbl: UITableView!
    @IBOutlet weak var constraintHeightOrderTbl: NSLayoutConstraint!
    @IBOutlet weak var freeShipBtn: Button!
    @IBOutlet weak var flatRateBtn: Button!
    @IBOutlet weak var subTotalLbl: Label!
    @IBOutlet weak var shippingChargeLbl: Label!
    @IBOutlet weak var flatRateLbl: Label!
    @IBOutlet weak var cardBtn: Button!
    @IBOutlet weak var totalLbl: Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    func configUI() {
        loginLbl.attributedText = getAttributeStringWithColor(loginLbl.text!, ["Log in"], color: BlackColor, font: UIFont(name: APP_BOLD, size: 14.0), isUnderLine: true)
        registerTableViewMethod()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToLogin(_ sender: Any) {
        
    }
    
    @IBAction func clickToSelectCountry(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToSelectPhoneCode(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToSelectDifferentAddress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func clickToShipping(_ sender: UIButton) {
        freeShipBtn.isSelected = false
        flatRateBtn.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func clickToSelectCard(_ sender: UIButton) {
        sender.isSelected = true
    }
    
    @IBAction func clickToPayNow(_ sender: Any) {
        
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

//MARK:- Tableview Method
extension CheckoutVC : UITableViewDelegate, UITableViewDataSource {

    func registerTableViewMethod() {
        orderTbl.register(UINib.init(nibName: "CheckoutOrderTVC", bundle: nil), forCellReuseIdentifier: "CheckoutOrderTVC")
        updateTableviewHeight()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CheckoutOrderTVC = orderTbl.dequeueReusableCell(withIdentifier: "CheckoutOrderTVC") as! CheckoutOrderTVC
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateTableviewHeight() {
        constraintHeightOrderTbl.constant = 130*3
    }
}
