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
    @IBOutlet weak var countryTxt: TextField!
    @IBOutlet weak var countryFlagImg: UIButton!
    @IBOutlet weak var stateTxt: TextField!
    @IBOutlet weak var cityTxt: TextField!
    @IBOutlet weak var freeShipBtn: Button!
    @IBOutlet weak var flatRateBtn: Button!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sideImgView: UIImageView!
    
    var isLoader = false
    var arrCart = [CartModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableViewMethod()
        isLoader = true
        if PLATFORM.isSimulator {
            promocodeTxt.text = "maareedtest"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().showTabBar()
        serviceCallToGetCart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var newFrame = bottomView.frame
        newFrame.size.width = SCREEN.WIDTH
        bottomView.frame = newFrame
        bottomView.roundCorners(corners: [.bottomLeft], radius: 20)
        sideImgView.roundCorners(corners: [.bottomRight], radius: 20)
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { }
    }
    
    @IBAction func clickToSearch(_ sender: Any) {
        
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToApplyPromocode(_ sender: Any) {
        if promocodeTxt.text?.trimmed == "" {
            displayToast("Please enter coupon code")
        }else{
            ProductAPIManager.shared.serviceCallToApplyCoupon(promocodeTxt.text!) { (data) in
                
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
        sender.isSelected = true
    }
    
    @IBAction func clickToProcessToCheckout(_ sender: Any) {
        let vc : CheckoutVC = STORYBOARD.PRODUCT.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
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
        }
    }
    
    @objc @IBAction func clickToRemove(_ sender: UIButton) {
        showAlertWithOption("Delete", message: "Are you sure want to delete?", btns: ["No", "Yes"], completionConfirm: {
            self.arrCart.remove(at: sender.tag)
            self.updateTableviewHeight()
        }) {
            
        }
    }
}

extension ShoppingCartVC {
    func serviceCallToGetCart() {
        ProductAPIManager.shared.serviceCallToGetCart(isLoader) { (data) in
            self.arrCart = [CartModel]()
            for temp in data {
                if let dict = temp["cart"] as? [String : Any] {
                    var product = CartModel.init(dict)
                    product.store_name = temp["store_name"] as? String ?? ""
                    self.arrCart.append(product)
                }
            }
            self.updateTableviewHeight()
        }
        isLoader = false
    }
}
