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
    
    var arrTabData = ["Dashboard", "Orders", "Downloads", "Addresses", "Account details"]
    var selectedTab = 0
    
    let dashboardTab : BuyerDashboardTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "BuyerDashboardTabVC") as! BuyerDashboardTabVC
    let orderTab : BuyerOrderTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "BuyerOrderTabVC") as! BuyerOrderTabVC
    let addressTab : BuyerAddressTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "BuyerAddressTabVC") as! BuyerAddressTabVC
    let accountTab : BuyerAccountDetailTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "BuyerAccountDetailTabVC") as! BuyerAccountDetailTabVC
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCollectionView()
        selectTab()
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { }
    }
    
    @IBAction func clickToLogout(_ sender: Any) {
        
    }
    
    @IBAction func clickToWishList(_ sender: Any) {
        
    }
    
    @IBAction func clickToCart(_ sender: Any) {
        let vc : ShoppingCartVC = STORYBOARD.PRODUCT.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartVC
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
        if selectedTab == indexPath.row {
            label.font = UIFont.init(name: APP_REGULAR, size: 14)
        }else{
            label.font = UIFont.init(name: APP_BOLD, size: 14)
        }
        label.sizeToFit()
        return CGSize(width: label.frame.size.width + 10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryListCVC = tabCV.dequeueReusableCell(withReuseIdentifier: "CategoryListCVC", for: indexPath) as! CategoryListCVC
        cell.nameLbl.text = arrTabData[indexPath.row]
        if selectedTab == indexPath.row {
            cell.nameLbl.textColor = BlackColor
            cell.lineImg.isHidden = false
            cell.nameLbl.font = UIFont.init(name: APP_REGULAR, size: 14)
        }else{
            cell.nameLbl.textColor = DarkTextColor
            cell.lineImg.isHidden = true
            cell.nameLbl.font = UIFont.init(name: APP_BOLD, size: 14)
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
            displaySubViewtoParentView(mainContainerView, subview: orderTab.view)
            orderTab.setupDetails()
        }
        else if selectedTab == 3 {
            displaySubViewtoParentView(mainContainerView, subview: addressTab.view)
            addressTab.setupDetails()
        }
        else if selectedTab == 4 {
            displaySubViewtoParentView(mainContainerView, subview: accountTab.view)
            accountTab.setupDetails()
        }
    }
    
    func resetAllTab() {
        dashboardTab.view.removeFromSuperview()
        orderTab.view.removeFromSuperview()
        addressTab.view.removeFromSuperview()
        accountTab.view.removeFromSuperview()
    }
}
