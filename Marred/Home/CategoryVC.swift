//
//  CategoryVC.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {

    @IBOutlet weak var tabCV: UICollectionView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet var categoryView: UIView!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet var pavillionView: UIView!
    @IBOutlet weak var pavillionCV: UICollectionView!
    @IBOutlet weak var cartLbl: Label!
    
    var arrTabData = [getTranslate("shop_by_categories"), getTranslate("shop_by_pavilions")]
    
    var selectedTab = getTranslate("shop_by_categories")
    var selectedPavillion = PavilionModel.init([String : Any]())
    var arrCategory = getCategoryData()
    var arrPavilion = [PavilionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(changeSelectedTab(_:)), name: NSNotification.Name.init(NOTIFICATION.SELECT_CATEGORY_CLICK), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCategoryList), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CATEGORY_LIST), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeSelectedPavilion), name: NSNotification.Name.init(NOTIFICATION.SELECT_PAVILION_CLICK), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPivilionData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_PIVILION_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: NSNotification.Name.init(NOTIFICATION.REFRESH_CART_BADGE), object: nil)
        registerCollectionView()
        updateCartBadge()
        if isArabic() {
            arrTabData = arrTabData.reversed()
        }
        
        tabCV.reloadData()
        selectTab()
        
        if arrCategory.count == 0 {
            AppDelegate().sharedDelegate().serviceCallToGetCategory()
        }else{
            categoryCV.reloadData()
        }
        self.arrPavilion = getPavilionData()
        AppDelegate().sharedDelegate().serviceCallToGetPavilionList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().showTabBar()
    }
    
    @objc func refreshCategoryList() {
        arrCategory = getCategoryData()
        categoryCV.reloadData()
    }
    
    @objc func changeSelectedTab(_ noti : Notification) {
        if let dict = noti.object as? [String : Any] {
            if let tab = dict["tab"] as? String {
                selectedTab = tab
                selectTab()
            }
        }
    }
    
    @objc func changeSelectedPavilion(_ noti : Notification) {
        
    }
    
    @objc func refreshPivilionData() {
        arrPavilion = [PavilionModel]()
        arrPavilion = getPavilionData()
        pavillionCV.reloadData()
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
    
    @IBAction func clickToWishList(_ sender: Any) {
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginAlert()
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 3])
    }
    
    @IBAction func clickToCart(_ sender: Any) {
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginAlert()
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 2])
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
extension CategoryVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        tabCV.register(UINib.init(nibName: "CategoryListCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryListCVC")
        categoryCV.register(UINib.init(nibName: "TopCategoryCVC", bundle: nil), forCellWithReuseIdentifier: "TopCategoryCVC")
        pavillionCV.register(UINib.init(nibName: "PavillionShopCVC", bundle: nil), forCellWithReuseIdentifier: "PavillionShopCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCV {
            return arrCategory.count
        }
        else if collectionView == tabCV {
            return arrTabData.count
        }
        else {
            return arrPavilion.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCV {
            return CGSize(width: collectionView.frame.size.width/3, height: 110)
        }
        else if collectionView == tabCV {
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
        else  {
            return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.width/3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCV {
            let cell : TopCategoryCVC = categoryCV.dequeueReusableCell(withReuseIdentifier: "TopCategoryCVC", for: indexPath) as! TopCategoryCVC
            cell.setupDetail(arrCategory[indexPath.row])
            return cell
        }
        else if collectionView == tabCV {
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
        else {
            let cell : PavillionShopCVC = pavillionCV.dequeueReusableCell(withReuseIdentifier: "PavillionShopCVC", for: indexPath) as! PavillionShopCVC
            cell.setupDetails(arrPavilion[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCV {
            selectedTab = arrTabData[indexPath.row]
            selectTab()
        }
        else if collectionView == pavillionCV {
            let vc : SubCategoryVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SubCategoryVC") as! SubCategoryVC
            vc.selectedPavilion = arrPavilion[indexPath.row]
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView == categoryCV {
            let vc : SubCategoryVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SubCategoryVC") as! SubCategoryVC
            vc.categoryData = arrCategory[indexPath.row]
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func selectTab() {
        tabCV.reloadData()
        categoryView.removeFromSuperview()
        pavillionView.removeFromSuperview()
        if selectedTab == getTranslate("shop_by_categories") {
            displaySubViewtoParentView(mainContainerView, subview: categoryView)
            categoryCV.reloadData()
            if arrCategory.count == 0 {
                if getCategoryData().count > 0 {
                    refreshCategoryList()
                }else{
                    AppDelegate().sharedDelegate().serviceCallToGetCategory()
                }
            }
        }
        else if selectedTab == getTranslate("shop_by_pavilions") {
            displaySubViewtoParentView(mainContainerView, subview: pavillionView)
            pavillionCV.reloadData()
            if arrPavilion.count == 0 {
                if getPavilionData().count > 0 {
                    refreshPivilionData()
                }else{
                    AppDelegate().sharedDelegate().serviceCallToGetPavilionList()
                }
            }
        }
    }
    
    
}
