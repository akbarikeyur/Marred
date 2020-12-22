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

    @IBOutlet weak var topCV: UICollectionView!
    @IBOutlet weak var topPageControl: JXPageControlScale!
    @IBOutlet weak var bottomCV: UICollectionView!
    @IBOutlet weak var constraintHeightBottomCV: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToSearch(_ sender: Any) {
        
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
        constraintHeightBottomCV.constant = 280 * 3
        self.topPageControl.numberOfPages = 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
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
            
            return cell
        }else{
            let cell : ProductCVC = bottomCV.dequeueReusableCell(withReuseIdentifier: "ProductCVC", for: indexPath) as! ProductCVC
            
            return cell
        }
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
