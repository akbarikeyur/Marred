//
//  DealofDaysVC.swift
//  Marred
//
//  Created by Keyur Akbari on 12/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit
import JXPageControl

class DealofDaysVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topCV: UICollectionView!
    @IBOutlet weak var topPageControl: JXPageControlScale!
    @IBOutlet weak var bottomCV: UICollectionView!
    @IBOutlet weak var constraintHeightBottomCV: NSLayoutConstraint!
    @IBOutlet weak var cartLbl: Label!
    
    var arrFeatureData = [DealProductModel]()
    var arrDealData = [DealProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: NSNotification.Name.init(NOTIFICATION.REFRESH_CART_BADGE), object: nil)
        updateCartBadge()
        
        topView.isHidden = (arrFeatureData.count == 0)
        registerCollectionView()
        serviceCallToGetDealOfDay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().hideTabBar()
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
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToSearch(_ sender: Any) {
        let vc : SearchProductVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SearchProductVC") as! SearchProductVC
        self.navigationController?.pushViewController(vc, animated: true)
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
extension DealofDaysVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        topCV.register(UINib.init(nibName: "DealProductCVC", bundle: nil), forCellWithReuseIdentifier: "DealProductCVC")
        bottomCV.register(UINib.init(nibName: "ProductCVC", bundle: nil), forCellWithReuseIdentifier: "ProductCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCV {
            return arrFeatureData.count
        }else{
            return arrDealData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCV {
            return CGSize(width: 230, height: collectionView.frame.size.height)
        }else{
            return CGSize(width: collectionView.frame.size.width/2, height: 280)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCV {
            let cell : DealProductCVC = topCV.dequeueReusableCell(withReuseIdentifier: "DealProductCVC", for: indexPath) as! DealProductCVC
            cell.setupDetails(arrFeatureData[indexPath.row])
            return cell
        }else{
            let cell : ProductCVC = bottomCV.dequeueReusableCell(withReuseIdentifier: "ProductCVC", for: indexPath) as! ProductCVC
            cell.setupDetails(arrDealData[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dict = DealProductModel.init([String : Any]())
        if collectionView == topCV {
            dict = arrFeatureData[indexPath.row]
        }else{
            dict = arrDealData[indexPath.row]
        }
        var product = ProductModel.init([String : Any]())
        product.id = dict.id
        product.price = dict.get_price
        product.title = dict.get_name
        product.thumbnail = dict.thumbnail
        product.get_status = dict.get_status
        
        let vc : ProductDetailVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.product = product
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == topCV {
            let visibleRect = CGRect(origin: self.topCV.contentOffset, size: self.topCV.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.topCV.indexPathForItem(at: visiblePoint) {
                self.topPageControl.currentPage = visibleIndexPath.row
            }
        }
    }
}

extension DealofDaysVC {
    func serviceCallToGetDealOfDay() {
        ProductAPIManager.shared.serviceCallToGetDealOfDay(["user_id" : AppModel.shared.currentUser.ID!]) { (data) in
            self.arrDealData = [DealProductModel]()
            self.arrFeatureData = [DealProductModel]()
            for temp in data {
                let dict = DealProductModel.init(temp)
                if dict.get_featured {
                    self.arrFeatureData.append(dict)
                }else{
                    self.arrDealData.append(dict)
                }
            }
            self.topCV.reloadData()
            self.bottomCV.reloadData()
            self.topView.isHidden = (self.arrFeatureData.count == 0)
            self.updateHeight()
        }
    }
    
    func updateHeight() {
        if arrDealData.count % 2 == 0 {
            constraintHeightBottomCV.constant = CGFloat(280 * (arrDealData.count/2))
        }else{
            constraintHeightBottomCV.constant = CGFloat(280 * ((arrDealData.count/2) + 1))
        }
    }
}
