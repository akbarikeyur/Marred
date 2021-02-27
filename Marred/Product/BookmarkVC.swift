//
//  BookmarkVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class BookmarkVC: UIViewController {

    @IBOutlet weak var productCV: UICollectionView!
    @IBOutlet weak var noDataLbl: Label!
    @IBOutlet weak var cartLbl: Label!
    
    var arrProduct = [ProductModel]()
    var refreshControl = UIRefreshControl.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(refreshSceen), name: NSNotification.Name.init(NOTIFICATION.NOTIFICATION_TAB_CLICK), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(serviceCallToGetBookmark), name: NSNotification.Name.init(NOTIFICATION.REFRESH_BOOKMARK), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: NSNotification.Name.init(NOTIFICATION.REFRESH_CART_BADGE), object: nil)
        updateCartBadge()
        
        registerCollectionView()
        
        refreshControl.addTarget(self, action: #selector(serviceCallToGetBookmark), for: .valueChanged)
        productCV.refreshControl = refreshControl
        serviceCallToGetBookmark()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().showTabBar()
    }
    
    @objc func refreshSceen() {
        if tabBarController != nil {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            if tabBar.tabBarView.lastIndex == 3 {
                serviceCallToGetBookmark()
            }
        }
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
    
    @IBAction func clickToSearch(_ sender: Any) {
        let vc : SearchProductVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SearchProductVC") as! SearchProductVC
        self.navigationController?.pushViewController(vc, animated: true)
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
extension BookmarkVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        productCV.register(UINib.init(nibName: "BookmarkCVC", bundle: nil), forCellWithReuseIdentifier: "BookmarkCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BookmarkCVC = productCV.dequeueReusableCell(withReuseIdentifier: "BookmarkCVC", for: indexPath) as! BookmarkCVC
        cell.setupDetails(arrProduct[indexPath.row])
        cell.wishBtn.tag = indexPath.row
        cell.wishBtn.addTarget(self, action: #selector(clickToWish(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func clickToWish(_ sender : UIButton) {
        var param = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.ID
        param["product_id"] = arrProduct[sender.tag].id
        ProductAPIManager.shared.serviceCallToRemoveBookmark(param) {
            self.arrProduct.remove(at: sender.tag)
            self.productCV.reloadData()
            self.noDataLbl.isHidden = (self.arrProduct.count > 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc : ProductDetailVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.product = arrProduct[indexPath.row]
        vc.isFavorite = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BookmarkVC {
    @objc func serviceCallToGetBookmark() {
        refreshControl.endRefreshing()
        ProductAPIManager.shared.serviceCallToGetBookmark(["user_id" : AppModel.shared.currentUser.ID!], (arrProduct.count == 0)) { (data) in
            self.arrProduct = [ProductModel]()
            for temp in data {
                self.arrProduct.append(ProductModel.init(temp))
            }
            self.productCV.reloadData()
            self.noDataLbl.isHidden = (self.arrProduct.count > 0)
        }
    }
}
