//
//  SellerDashboardVC.swift
//  Marred
//
//  Created by Keyur Akbari on 17/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SellerDashboardVC: UIViewController {

    @IBOutlet weak var tabCV: UICollectionView!
    @IBOutlet weak var mainContainerView: UIView!
    
    var arrTabData = [getTranslate("tab_dashboard"), getTranslate("tab_product"), getTranslate("tab_order"), getTranslate("tab_contact_admin"), getTranslate("tab_withdraw")]
    var selectedTab = 0
    
    let dashboardTab : SellerDashboardTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "SellerDashboardTabVC") as! SellerDashboardTabVC
    let productTab : SellerDashboardProductTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "SellerDashboardProductTabVC") as! SellerDashboardProductTabVC
    let orderTab : SellerDashboardOrderTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "SellerDashboardOrderTabVC") as! SellerDashboardOrderTabVC
    let contactTab : SellerContactAdminTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "SellerContactAdminTabVC") as! SellerContactAdminTabVC
    let withdrawTab : SellerWithdrawTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "SellerWithdrawTabVC") as! SellerWithdrawTabVC
    let settingTab : SellerSettingTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "SellerSettingTabVC") as! SellerSettingTabVC
    let paymentTab : SellerPaymentSettingTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "SellerPaymentSettingTabVC") as! SellerPaymentSettingTabVC
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToContactUs), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_CONTACT_US), object: nil)
        registerCollectionView()
        selectTab()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().showTabBar()
    }
    
    @objc func redirectToContactUs() {
        selectedTab = 3
        selectTab()
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
extension SellerDashboardVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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
        if selectedTab == indexPath.row {
            label.font = UIFont.init(name: APP_BOLD, size: 14)
        }else{
            label.font = UIFont.init(name: APP_REGULAR, size: 14)
        }
        label.sizeToFit()
        return CGSize(width: label.frame.size.width + 20, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryListCVC = tabCV.dequeueReusableCell(withReuseIdentifier: "CategoryListCVC", for: indexPath) as! CategoryListCVC
        cell.nameLbl.text = arrTabData[indexPath.row]
        if selectedTab == indexPath.row {
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
        selectedTab = indexPath.row
        selectTab()
    }
    
    func selectTab() {
        tabCV.reloadData()
        if selectedTab == 0 {
            displaySubViewtoParentView(mainContainerView, subview: dashboardTab.view)
            dashboardTab.setupDetails()
        }
        else if selectedTab == 1 {
            displaySubViewtoParentView(mainContainerView, subview: productTab.view)
            productTab.setupDetails()
        }
        else if selectedTab == 2 {
            displaySubViewtoParentView(mainContainerView, subview: orderTab.view)
            orderTab.setupDetails()
        }
        else if selectedTab == 3 {
            displaySubViewtoParentView(mainContainerView, subview: contactTab.view)
            contactTab.setupDetails()
        }
        else if selectedTab == 4 {
            displaySubViewtoParentView(mainContainerView, subview: withdrawTab.view)
            withdrawTab.setupDetails()
        }
        else if selectedTab == 5 {
            displaySubViewtoParentView(mainContainerView, subview: settingTab.view)
            settingTab.setupDetails()
        }
        else if selectedTab == 6 {
            displaySubViewtoParentView(mainContainerView, subview: paymentTab.view)
            paymentTab.setupDetails()
        }
    }
    
    func resetAllTab() {
        dashboardTab.view.removeFromSuperview()
        productTab.view.removeFromSuperview()
        orderTab.view.removeFromSuperview()
        contactTab.view.removeFromSuperview()
        withdrawTab.view.removeFromSuperview()
        settingTab.view.removeFromSuperview()
        paymentTab.view.removeFromSuperview()
    }
}
