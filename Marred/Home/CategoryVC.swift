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
    
    var arrTabData = ["Shop by Categories", "Shop by Pavilions"]
    
    var selectedTab = 0
    var selectedPavillion = 0
    
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
    
    @IBAction func clickToSearch(_ sender: Any) {
        
    }
    
    @IBAction func clickToWishList(_ sender: Any) {
        
    }
    
    @IBAction func clickToCart(_ sender: Any) {
        
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
            return 10
        }
        else if collectionView == tabCV {
            return arrTabData.count
        }
        else if collectionView == pavillionCV {
            return 10
        }
        else {
            return 10
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
            if selectedPavillion == indexPath.row {
                cell.arrowImg.isHidden = false
                cell.outerView.backgroundColor = BlackColor
                cell.nameLbl.textColor = WhiteColor
            }else{
                cell.arrowImg.isHidden = true
                cell.outerView.backgroundColor = WhiteColor
                cell.nameLbl.textColor = BlackColor
            }
            return cell
        }
        else{
            let cell : CategoriesCVC = shopCV.dequeueReusableCell(withReuseIdentifier: "CategoriesCVC", for: indexPath) as! CategoriesCVC
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCV {
            selectedTab = indexPath.row
            selectTab()
        }
        else if collectionView == pavillionCV {
            selectedPavillion = indexPath.row
            pavillionCV.reloadData()
        }
        else if collectionView == categoryCV {
            let vc : SubCategoryVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SubCategoryVC") as! SubCategoryVC
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
        }
    }
}
