//
//  CheckoutVC.swift
//  Marred
//
//  Created by Keyur Akbari on 12/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit
import FoloosiSdk
import DropDown

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
    @IBOutlet weak var postcodeTxt: TextField!
    @IBOutlet weak var phoneFlagImg: UIImageView!
    @IBOutlet weak var phoneCodeLbl: Label!
    @IBOutlet weak var phoneTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var differentAddressBtn: Button!
    @IBOutlet weak var notesTxtView: TextView!
    @IBOutlet weak var orderTbl: UITableView!
    @IBOutlet weak var constraintHeightOrderTbl: NSLayoutConstraint!
    @IBOutlet weak var freeShipView: UIView!
    @IBOutlet weak var freeShipBtn: Button!
    @IBOutlet weak var flatRateView: UIView!
    @IBOutlet weak var flatRateBtn: Button!
    @IBOutlet weak var flatRateLbl: Label!
    @IBOutlet weak var subTotalLbl: Label!
    @IBOutlet weak var shippingChargeLbl: Label!
    @IBOutlet weak var cardBtn: Button!
    @IBOutlet weak var cashBtn: Button!
    @IBOutlet weak var totalLbl: Label!
    
    var arrCountry = [CountryModel]()
    var selectedCountry = CountryModel.init([String : Any]())
    var arrCart = [CartModel]()
    var isFreeShipping : Bool = false
    var totalPrice = 0.0
    var coupon = CouponModel.init([String : Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    func configUI() {
        loginView.isHidden = isUserLogin()
        loginLbl.attributedText = getAttributeStringWithColor(loginLbl.text!, ["Log in"], color: BlackColor, font: UIFont(name: APP_BOLD, size: 14.0), isUnderLine: true)
        registerTableViewMethod()
        
        flatRateLbl.text = displayPriceWithCurrency("25.00")
        
        FoloosiPay.initSDK(merchantKey: FOLOOSI.MERCHANT_KEY,withDelegate: self)
        
        setupDetails()
        if isFreeShipping {
            clickToShipping(freeShipBtn)
        }else{
            clickToShipping(flatRateBtn)
        }
        updateTotalPrice()
    }
    
    func setupDetails() {
        let dict = getShippingAddress()
        fnameTxt.text = dict.first_name
        lnameTxt.text = dict.last_name
        companyNameTxt.text = dict.company
        countryTxt.text = dict.country
        stateTxt.text = dict.state
        addressTxt.text = dict.address_1
        apartmentTxt.text = dict.address_2
        cityTxt.text = dict.city
        if dict.postcode != "" {
            postcodeTxt.text = dict.postcode
        }else{
            postcodeTxt.text = AppModel.shared.currentUser.shipping.postcode
        }
        if dict.phone != "" {
            phoneTxt.text = dict.phone
        }else{
            phoneTxt.text = AppModel.shared.currentUser.shipping.phone
        }
        if dict.email != "" {
            emailTxt.text = dict.email
        }else{
            emailTxt.text = AppModel.shared.currentUser.user_email
        }
        
        for temp in getJsonFromFile("country") {
            arrCountry.append(CountryModel.init(temp))
        }
        if dict.country != ""
        {
            let index = arrCountry.firstIndex { (temp) -> Bool in
                temp.name.lowercased() == dict.country.lowercased()
            }
            if index != nil {
                phoneFlagImg.image = UIImage(named: arrCountry[index!].code.lowercased())
                phoneCodeLbl.text = arrCountry[index!].dial_code
                selectedCountry = arrCountry[index!]
            }
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToLogin(_ sender: Any) {
        
    }
    
    @IBAction func clickToSelectCountry(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.semanticContentAttribute = isArabic() ? .forceLeftToRight : .forceRightToLeft
        var arrData = [String]()
        for temp in arrCountry {
            arrData.append(temp.name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedCountry = self.arrCountry[index]
            self.countryTxt.text = self.selectedCountry.name
            self.phoneFlagImg.image = UIImage(named: self.arrCountry[index].code.lowercased())
            self.phoneCodeLbl.text = self.arrCountry[index].dial_code
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectPhoneCode(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToSelectDifferentAddress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func clickToShipping(_ sender: UIButton) {
        freeShipBtn.isSelected = false
        flatRateBtn.isSelected = false
        if sender.tag == 1 {
            freeShipBtn.isSelected = true
        }else{
            flatRateBtn.isSelected = true
        }
        updateTotalPrice()
    }
    
    @IBAction func clickToSelectCard(_ sender: UIButton) {
        cardBtn.isSelected = false
        cashBtn.isSelected = false
        if sender.tag == 1 {
            cardBtn.isSelected = true
        }else{
            cashBtn.isSelected = true
        }
    }
    
    @IBAction func clickToPayNow(_ sender: Any) {
        if cardBtn.isSelected {
            setupForPayment()
        }else{
            serviceCallToCheckout()
        }
    }
    
    func updateTotalPrice() {
        totalPrice = 0
        for temp in arrCart {
            totalPrice += (Double(temp.quantity) * temp.price)
        }
        if coupon.id != "" && coupon.amount != "" {
            totalPrice -= Double(coupon.amount)!
        }
        
        subTotalLbl.text = displayPriceWithCurrency(displayFlotingPrice(totalPrice))
        
        flatRateView.isHidden = true
        freeShipView.isHidden = true
        flatRateBtn.isSelected = false
        freeShipBtn.isSelected = false
        if totalPrice >= 500 {
            freeShipBtn.isSelected = true
            freeShipView.isHidden = false
        }else {
            flatRateBtn.isSelected = true
            flatRateView.isHidden = false
        }
        
        if flatRateBtn.isSelected {
            totalPrice += 25.0
        }
        totalLbl.text = displayPriceWithCurrency(displayFlotingPrice(totalPrice))
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
        return arrCart.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CheckoutOrderTVC = orderTbl.dequeueReusableCell(withIdentifier: "CheckoutOrderTVC") as! CheckoutOrderTVC
        cell.setupDetails(arrCart[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateTableviewHeight() {
        constraintHeightOrderTbl.constant = CGFloat(130*arrCart.count)
    }
}

extension CheckoutVC : FoloosiDelegate {
    
    func setupForPayment() {
        let orderData = OrderData()
        orderData.orderTitle = "Maared" // Any Title
        orderData.currencyCode = "AED"  // 3 digit currency code like "AED"
        orderData.customColor = "#12233"  // make payment page loading color as app color.
        orderData.orderAmount = totalPrice  // in double format ##,###.##
        orderData.orderId = getCurrentTimeStampValue()  // unique order id.
        orderData.orderDescription = "Order"  // any description.
        let customer = Customer()
        customer.customerEmail = AppModel.shared.currentUser.user_email
        customer.customerName = AppModel.shared.currentUser.display_name
        if phoneTxt.text != "" {
            customer.customerPhoneNumber = phoneTxt.text
        }else{
            customer.customerPhoneNumber = "544444444"
        }
        
        orderData.customer = customer
        FLog.setLogVisible(debug: true)
        FoloosiPay.makePayment(orderData: orderData)
    }
    
    func onPaymentError(descriptionOfError: String) {
        printData("Failure Callback.")
    }
    
    func onPaymentSuccess(paymentId: String) {
        printData("Success Callback")
        // payment id : FLSAPI00060115d83142ab
        serviceCallToCheckout()
    }
}


extension CheckoutVC {
    func serviceCallToCheckout() {
        serviceCallToSetAddress()
        
        var param = [String : Any]()
        param["customer_id"] = AppModel.shared.currentUser.ID
        if cardBtn.isSelected {
            param["payment_method"] = "foloosi"
            param["payment_method_title"] = "Credit Card/Debit Card"
            param["set_paid"] = false
        }else {
            param["payment_method"] = "cod"
            param["payment_method_title"] = "Cash on delivery"
            param["set_paid"] = false
        }
        param["billing"] = getShippingDict()
        param["shipping"] = getShippingDict()
        var arrData = [[String : Any]]()
        for temp in arrCart {
            var dict = [String : Any]()
            dict["product_id"] = temp.product_id
            dict["quantity"] = temp.quantity
            if temp.variation.count > 0 {
                dict["variation_id"] = temp.variation
            }
            arrData.append(dict)
        }
        param["line_items"] = arrData
        
        if flatRateBtn.isSelected {
            var rateDict = [String : Any]()
            rateDict["method_id"] = "flat_rate"
            rateDict["method_title"] = "Flat Rate"
            rateDict["total"] = "25.00"
            arrData = [[String : Any]]()
            arrData.append(rateDict)
            param["shipping_lines"] = arrData
        }
        if coupon.id != "" {
            param["coupon_lines"] = [coupon.dictionary()]
        }
        printData(param)
        ProductAPIManager.shared.serviceCallToCheckout(param) {
            AppDelegate().sharedDelegate().continueAfterCheckout()
            self.navigationController?.popToRootViewController(animated: false)
        }
        /*
        var param = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.ID
        if coupon.code != "" {
            param["coupon_code"] = coupon.code
        }
        var type = "simple"
        var arrData = [[String : Any]]()
        for temp in arrCart {
            var dict = [String : Any]()
            dict["product_id"] = temp.product_id
            dict["qty"] = temp.quantity
            if temp.variation.count > 0 {
                dict["variations"] = temp.variation
                type = "variable"
            }
            arrData.append(dict)
        }
        param["products"] = arrData
        param["type"] = type
        if cashBtn.isSelected {
            param["payment_method"] = "COD"
        }else{
            param["payment_method"] = "foloosi"
        }
        printData(param)
        ProductAPIManager.shared.serviceCallToCheckout(param) {
            AppDelegate().sharedDelegate().continueAfterCheckout()
            self.navigationController?.popToRootViewController(animated: false)
        }
        */
    }
    
    func getShippingDict() -> [String : Any] {
        var param = [String : Any]()
        param["first_name"] = fnameTxt.text
        param["last_name"] = lnameTxt.text
        param["company"] = companyNameTxt.text
        param["address_1"] = addressTxt.text
        param["address_2"] = apartmentTxt.text
        param["city"] = cityTxt.text
        param["state"] = stateTxt.text
        param["postcode"] = postcodeTxt.text
        param["country"] = countryTxt.text
        param["email"] = emailTxt.text
        param["phone"] = phoneTxt.text
        print(param)
        return param
    }
    
    func serviceCallToSetAddress() {
        
        var newParam = [String : Any]()
        newParam["email"] = AppModel.shared.currentUser.user_email
        newParam["first_name"] = fnameTxt.text
        newParam["last_name"] = lnameTxt.text
        newParam["username"] = AppModel.shared.currentUser.user_nicename
        newParam["shipping"] = getShippingDict()
        AppDelegate().sharedDelegate().serviceCallToSetAddress(newParam)
    }
    
}
