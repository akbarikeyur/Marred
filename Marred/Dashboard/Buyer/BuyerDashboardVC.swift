//
//  BuyerDashboardVC.swift
//  Marred
//
//  Created by Keyur Akbari on 12/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class BuyerDashboardVC: UIViewController {

    @IBOutlet weak var tabCV: UICollectionView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var cartLbl: Label!
    
    var arrTabData = [getTranslate("tab_dashboard"), getTranslate("tab_order"), getTranslate("tab_address"), getTranslate("tab_account"), getTranslate("tab_contact")]
    var selectedTab = getTranslate("tab_dashboard")
    
    let dashboardTab : BuyerDashboardTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "BuyerDashboardTabVC") as! BuyerDashboardTabVC
    let orderTab : BuyerOrderTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "BuyerOrderTabVC") as! BuyerOrderTabVC
    let addressTab : BuyerAddressTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "BuyerAddressTabVC") as! BuyerAddressTabVC
    let accountTab : BuyerAccountDetailTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "BuyerAccountDetailTabVC") as! BuyerAccountDetailTabVC
    let contactTab : SellerContactAdminTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "SellerContactAdminTabVC") as! SellerContactAdminTabVC
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToContactUs), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_CONTACT_US), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: NSNotification.Name.init(NOTIFICATION.REFRESH_CART_BADGE), object: nil)
        updateCartBadge()
        
        registerCollectionView()
        if isArabic() {
            arrTabData = arrTabData.reversed()
        }
        tabCV.reloadData()
        selectTab()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().showTabBar()
    }
    
    @objc func redirectToContactUs() {
        selectedTab = getTranslate("tab_contact")
        selectTab()
    }
    
    @objc func updateCartBadge() {
        if AppModel.shared.CART_COUNT != nil && AppModel.shared.CART_COUNT > 0 {
            cartLbl.text = String(AppModel.shared.CART_COUNT)
            cartLbl.isHidden = false
        }else {
            cartLbl.text = "0"
            cartLbl.isHidden = true
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { }
    }
    
    @IBAction func clickToLogout(_ sender: Any) {
        self.view.endEditing(true)
        showAlertWithOption("logout_title", message: "logout_msg", btns: ["no_button", "yes_button"], completionConfirm: {
            AppDelegate().sharedDelegate().navigaeToLogout()
        }) {
            
        }
    }
    
    @IBAction func clickToWishList(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 3])
    }
    
    @IBAction func clickToCart(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 2])
//        let vc : ShoppingCartVC = STORYBOARD.PRODUCT.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartVC
//        self.navigationController?.pushViewController(vc, animated: true)
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

//MARK:- CollectionView Method
extension BuyerDashboardVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        tabCV.register(UINib.init(nibName: "CategoryListCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryListCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTabData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = arrTabData[indexPath.row]
        if selectedTab == label.text {
            label.font = UIFont.init(name: APP_BOLD, size: 14)
        }else{
            label.font = UIFont.init(name: APP_REGULAR, size: 14)
        }
        label.sizeToFit()
        return CGSize(width: label.frame.size.width + 10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryListCVC = tabCV.dequeueReusableCell(withReuseIdentifier: "CategoryListCVC", for: indexPath) as! CategoryListCVC
        cell.nameLbl.text = arrTabData[indexPath.row]
        if selectedTab == cell.nameLbl.text {
            cell.nameLbl.textColor = BlackColor
            cell.lineImg.isHidden = false
            cell.nameLbl.font = UIFont.init(name: APP_BOLD, size: 14)
        }else{
            cell.nameLbl.textColor = DarkTextColor
            cell.lineImg.isHidden = true
            cell.nameLbl.font = UIFont.init(name: APP_REGULAR, size: 14)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTab = arrTabData[indexPath.row]
        selectTab()
    }
    
    func selectTab() {
        tabCV.reloadData()
        
        if selectedTab == getTranslate("tab_dashboard") {
            displaySubViewtoParentView(mainContainerView, subview: dashboardTab.view)
            dashboardTab.setupDetails()
        }
        else if selectedTab == getTranslate("tab_order") {
            displaySubViewtoParentView(mainContainerView, subview: orderTab.view)
            orderTab.setupDetails()
        }
        else if selectedTab == getTranslate("tab_address") {
            displaySubViewtoParentView(mainContainerView, subview: addressTab.view)
            addressTab.setupDetails()
        }
        else if selectedTab == getTranslate("tab_account") {
            displaySubViewtoParentView(mainContainerView, subview: accountTab.view)
            accountTab.setupDetails()
        }
        else if selectedTab == getTranslate("tab_contact") {
            displaySubViewtoParentView(mainContainerView, subview: contactTab.view)
            contactTab.setupDetails()
        }
    }
    
    func resetAllTab() {
        dashboardTab.view.removeFromSuperview()
        orderTab.view.removeFromSuperview()
        addressTab.view.removeFromSuperview()
        accountTab.view.removeFromSuperview()
        contactTab.view.removeFromSuperview()
    }
}
