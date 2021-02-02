          //
//  ShoppingCartVC.swift
//  Marred
//
//  Created by Keyur Akbari on 10/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class ShoppingCartVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var constraintHeightTblView: NSLayoutConstraint!
    @IBOutlet weak var promocodeTxt: TextField!
    @IBOutlet weak var calculateView: UIView!
    @IBOutlet weak var countryTxt: TextField!
    @IBOutlet weak var countryFlagImg: UIButton!
    @IBOutlet weak var stateTxt: TextField!
    @IBOutlet weak var cityTxt: TextField!
    @IBOutlet weak var freeShipBtn: Button!
    @IBOutlet weak var flatRateBtn: Button!
    @IBOutlet weak var flatRateLbl: Label!
    @IBOutlet weak var subTotalLbl: Label!
    @IBOutlet weak var totalLbl: Label!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sideImgView: UIImageView!
    @IBOutlet weak var myScroll: UIScrollView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var applyCouponBtn: Button!
    
    var isLoader = false
    var arrCart = [CartModel]()
    var totalPrice = 0.0
    var coupon = CouponModel.init([String : Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(refreshSceen), name: NSNotification.Name.init(NOTIFICATION.NOTIFICATION_TAB_CLICK), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(serviceCallToGetCart), name: NSNotification.Name.init(NOTIFICATION.REFRESH_CART), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetCartScreen), name: NSNotification.Name.init(NOTIFICATION.CLEAR_CART), object: nil)
        
        registerTableViewMethod()
        resetCartScreen()
        flatRateLbl.text = displayPriceWithCurrency("25.00")
        calculateView.isHidden = true
        clickToShipping(freeShipBtn)
        serviceCallToGetCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().showTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var newFrame = bottomView.frame
        newFrame.size.width = SCREEN.WIDTH
        bottomView.frame = newFrame
        bottomView.roundCorners(corners: [.bottomLeft], radius: 20)
        sideImgView.roundCorners(corners: [.bottomRight], radius: 20)
    }
    
    @objc func refreshSceen() {
        if tabBarController != nil {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            if tabBar.tabBarView.lastIndex == 2 {
                serviceCallToGetCart()
            }
        }
    }
    
    @objc func resetCartScreen() {
        isLoader = true
        noDataView.isHidden = true
        myScroll.isHidden = true
        promocodeTxt.text = ""
        
        arrCart = [CartModel]()
        totalPrice = 0.0
        coupon = CouponModel.init([String : Any]())
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { }
    }
    
    @IBAction func clickToSearch(_ sender: Any) {
        let vc : SearchProductVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SearchProductVC") as! SearchProductVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToApplyPromocode(_ sender: Any) {
        if self.applyCouponBtn.isSelected {
            promocodeTxt.text = ""
            promocodeTxt.textColor = BlackColor
            promocodeTxt.isUserInteractionEnabled = true
            applyCouponBtn.isSelected = false
            applyCouponBtn.setTitle(getTranslate("apply_button"), for: .normal)
            self.coupon = CouponModel.init([String : Any]())
            self.updateTotalPrice()
        }else{
            if promocodeTxt.text?.trimmed == "" {
                displayToast("enter_coupon_code")
            }else{
                ProductAPIManager.shared.serviceCallToApplyCoupon(promocodeTxt.text!) { (data) in
                    self.coupon = CouponModel.init(data)
                    self.updateTotalPrice()
                    self.promocodeTxt.text = displayPriceWithCurrency(self.coupon.amount) + getTranslate("discount_apply")
                    self.promocodeTxt.textColor = UIColor.red
                    self.promocodeTxt.isUserInteractionEnabled = false
                    self.applyCouponBtn.setTitle(getTranslate("deny_button"), for: .selected)
                    self.applyCouponBtn.isSelected = true
                 }
            }
        }
        
    }
    
    @IBAction func clickToSelectCountry(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToUpdateAddress(_ sender: Any) {
        
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
    
    @IBAction func clickToProcessToCheckout(_ sender: Any) {
        let vc : CheckoutVC = STORYBOARD.PRODUCT.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
        vc.arrCart = arrCart
        vc.isFreeShipping = freeShipBtn.isSelected
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

//MARK:- Tableview Method
extension ShoppingCartVC : UITableViewDelegate, UITableViewDataSource, CartDelegate {

    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: "CartTVC", bundle: nil), forCellReuseIdentifier: "CartTVC")
        updateTableviewHeight()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCart.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CartTVC = tblView.dequeueReusableCell(withIdentifier: "CartTVC") as! CartTVC
        cell.delegate = self
        cell.setupDetails(arrCart[indexPath.row])
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(clickToRemove(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateTableviewHeight() {
        tblView.reloadData()
        constraintHeightTblView.constant = CGFloat(130*arrCart.count)
    }
    
    func updateQuantity(_ cart: CartModel) {
        let index = arrCart.firstIndex { (temp) -> Bool in
            temp.product_id == cart.product_id
        }
        if index != nil {
            arrCart[index!] = cart
            if cart.quantity == 0 {
                serviceCallToClearToCart(arrCart[index!])
                arrCart.remove(at: index!)
                updateTableviewHeight()
            }
        }
        self.updateTotalPrice()
    }
    
    func updateTotalPrice() {
        totalPrice = 0
        for temp in arrCart {
            totalPrice += (Double(temp.quantity) * temp.price)
        }
        if coupon.id != "" && coupon.amount != "" {
            totalPrice -= Double(coupon.amount)!
        }
        subTotalLbl.text = displayPriceWithCurrency(String(totalPrice))
        if flatRateBtn.isSelected {
            totalPrice += 25.0
        }
        totalLbl.text = displayPriceWithCurrency(String(totalPrice))
    }
    
    @objc @IBAction func clickToRemove(_ sender: UIButton) {
        showAlertWithOption(getTranslate("delete_title"), message: getTranslate("delete_message"), btns: ["no_button", "yes_button"], completionConfirm: {
            self.serviceCallToClearToCart(self.arrCart[sender.tag])
            self.arrCart.remove(at: sender.tag)
            self.updateTableviewHeight()
            self.updateTotalPrice()
        }) {
            
        }
    }
}

extension ShoppingCartVC {
    @objc func serviceCallToGetCart() {
        ProductAPIManager.shared.serviceCallToGetCart(isLoader) { (data) in
            self.arrCart = [CartModel]()
            for temp in data {
                if let dict = temp["cart"] as? [String : Any] {
                    var product = CartModel.init(dict)
                    product.store_name = temp["store_name"] as? String ?? ""
                    product.price = (product.line_total / Double(product.quantity))
                    self.arrCart.append(product)
                }
            }
            self.updateTableviewHeight()
            self.updateTotalPrice()
            self.noDataView.isHidden = (self.arrCart.count > 0)
            self.myScroll.isHidden = (self.arrCart.count == 0)
        }
        isLoader = false
    }
    
    func serviceCallToClearToCart(_ cart : CartModel) {
        var param = [String : Any]()
        param["product_id"] = cart.product_id
        param["quantity"] = cart.quantity
        ProductAPIManager.shared.serviceCallToClearToCart(param) {
            
        }
    }
}
