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
    @IBOutlet weak var shopCV: UICollectionView!
    
    var arrTabData = [getTranslate("shop_by_categories"), getTranslate("shop_by_pavilions")]
    
    var selectedTab = 0
    var selectedPavillion = PavilionModel.init([String : Any]())
    var arrCategory = getCategoryData()
    var arrPavilion = [PavilionModel]()
    var arrPavilionCategory = [CategoryModel]()
    var pavilionDict = [String : [CategoryModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(changeSelectedTab(_:)), name: NSNotification.Name.init(NOTIFICATION.SELECT_CATEGORY_CLICK), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCategoryList), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CATEGORY_LIST), object: nil)
        registerCollectionView()
        selectTab()
        
        if arrCategory.count == 0 {
            AppDelegate().sharedDelegate().serviceCallToGetCategory()
        }else{
            categoryCV.reloadData()
        }
        
        arrPavilion = [PavilionModel]()
        for temp in getJsonFromFile("pavilion") {
            arrPavilion.append(PavilionModel.init(temp))
        }
        pavillionCV.reloadData()
        if selectedTab == 1 {
            if arrPavilion.count > 0 {
                selectedPavillion = arrPavilion[0]
                if let data = pavilionDict[String(selectedPavillion.id)], data.count > 0 {
                    arrPavilionCategory = data
                    shopCV.reloadData()
                }else{
                    serviceCallToGetPavilionCategory()
                }
            }
        }
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
            if let tab = dict["index"] as? Int {
                selectedTab = tab
                selectTab()
            }
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { }
    }
    
    @IBAction func clickToSearch(_ sender: Any) {
        
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
extension CategoryVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        tabCV.register(UINib.init(nibName: "CategoryListCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryListCVC")
        categoryCV.register(UINib.init(nibName: "CategoriesCVC", bundle: nil), forCellWithReuseIdentifier: "CategoriesCVC")
        pavillionCV.register(UINib.init(nibName: "PavillionShopCVC", bundle: nil), forCellWithReuseIdentifier: "PavillionShopCVC")
        shopCV.register(UINib.init(nibName: "CategoriesCVC", bundle: nil), forCellWithReuseIdentifier: "CategoriesCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCV {
            return arrCategory.count
        }
        else if collectionView == tabCV {
            return arrTabData.count
        }
        else if collectionView == pavillionCV {
            return arrPavilion.count
        }
        else {
            return arrPavilionCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCV {
            return CGSize(width: collectionView.frame.size.width/3, height: 110)
        }
        else if collectionView == tabCV {
            let label = UILabel(frame: CGRect.zero)
            label.text = arrTabData[indexPath.row]
            if selectedTab == indexPath.row {
                label.font = UIFont.init(name: APP_BOLD, size: 14)
            }else{
                label.font = UIFont.init(name: APP_REGULAR, size: 14)
            }
            label.sizeToFit()
            return CGSize(width: label.frame.size.width + 10, height: collectionView.frame.size.height)
        }
        else if collectionView == pavillionCV {
            return CGSize(width: collectionView.frame.size.width, height: 90)
        }
        else{
            return CGSize(width: collectionView.frame.size.width/3, height: 110)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCV {
            let cell : CategoriesCVC = categoryCV.dequeueReusableCell(withReuseIdentifier: "CategoriesCVC", for: indexPath) as! CategoriesCVC
            cell.setupDetails(arrCategory[indexPath.row])
            return cell
        }
        else if collectionView == tabCV {
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
        else if collectionView == pavillionCV {
            let cell : PavillionShopCVC = pavillionCV.dequeueReusableCell(withReuseIdentifier: "PavillionShopCVC", for: indexPath) as! PavillionShopCVC
            if selectedPavillion.id == arrPavilion[indexPath.row].id {
                cell.arrowImg.isHidden = false
                cell.outerView.backgroundColor = BlackColor
                cell.nameLbl.textColor = WhiteColor
            }else{
                cell.arrowImg.isHidden = true
                cell.outerView.backgroundColor = WhiteColor
                cell.nameLbl.textColor = BlackColor
            }
            cell.setupDetails(arrPavilion[indexPath.row])
            return cell
        }
        else{
            let cell : CategoriesCVC = shopCV.dequeueReusableCell(withReuseIdentifier: "CategoriesCVC", for: indexPath) as! CategoriesCVC
            cell.setupDetails(arrPavilionCategory[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCV {
            selectedTab = indexPath.row
            selectTab()
        }
        else if collectionView == pavillionCV {
            selectedPavillion = arrPavilion[indexPath.row]
            pavillionCV.reloadData()
            if let data = pavilionDict[String(selectedPavillion.id)], data.count > 0 {
                arrPavilionCategory = data
                shopCV.reloadData()
            }else{
                serviceCallToGetPavilionCategory()
            }
        }
        else if collectionView == categoryCV {
            let vc : SubCategoryVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SubCategoryVC") as! SubCategoryVC
            vc.categoryData = arrCategory[indexPath.row]
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView == shopCV {
            let vc : SubCategoryVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SubCategoryVC") as! SubCategoryVC
            vc.arrSubCategory = arrPavilionCategory
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func selectTab() {
        tabCV.reloadData()
        categoryView.removeFromSuperview()
        pavillionView.removeFromSuperview()
        if selectedTab == 0 {
            displaySubViewtoParentView(mainContainerView, subview: categoryView)
            categoryCV.reloadData()
        }
        else if selectedTab == 1 {
            displaySubViewtoParentView(mainContainerView, subview: pavillionView)
            pavillionCV.reloadData()
            shopCV.reloadData()
            if arrPavilion.count > 0 {
                selectedPavillion = arrPavilion[0]
                if let data = pavilionDict[String(selectedPavillion.id)], data.count > 0 {
                    arrPavilionCategory = data
                    shopCV.reloadData()
                }else{
                    serviceCallToGetPavilionCategory()
                }
            }
        }
    }
}

extension CategoryVC {
    func serviceCallToGetPavilionCategory() {
        HomeAPIManager.shared.serviceCallToGetPavilionCategory(selectedPavillion.id) { (data) in
            self.arrPavilionCategory = [CategoryModel]()
            for temp in data {
                self.arrPavilionCategory.append(CategoryModel.init(temp))
            }
            self.shopCV.reloadData()
            self.pavilionDict[String(self.selectedPavillion.id)] = self.arrPavilionCategory
        }
    }
}
