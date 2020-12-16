//
//  DashboardVC.swift
//  Marred
//
//  Created by Keyur Akbari on 12/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var tabCV: UICollectionView!
    @IBOutlet weak var mainContainerView: UIView!
    
    var arrTabData = ["Dashboard", "Orders", "Downloads", "Addresses", "Account details"]
    var selectedTab = 0
    
    let dashboardTab : DashboardTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "DashboardTabVC") as! DashboardTabVC
    let orderTab : OrderTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "OrderTabVC") as! OrderTabVC
    let addressTab : AddressTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "AddressTabVC") as! AddressTabVC
    let accountTab : AccountDetailTabVC = STORYBOARD.DASHBOARD.instantiateViewController(withIdentifier: "AccountDetailTabVC") as! AccountDetailTabVC
    
    
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
extension DashboardVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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
        label.font = UIFont.init(name: APP_REGULAR, size: 12)
        label.sizeToFit()
        return CGSize(width: label.frame.size.width + 10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryListCVC = tabCV.dequeueReusableCell(withReuseIdentifier: "CategoryListCVC", for: indexPath) as! CategoryListCVC
        cell.nameLbl.text = arrTabData[indexPath.row]
        if selectedTab == indexPath.row {
            cell.nameLbl.textColor = BlackColor
            cell.lineImg.isHidden = false
        }else{
            cell.nameLbl.textColor = DarkTextColor
            cell.lineImg.isHidden = true
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
