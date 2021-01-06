//
//  SubCategoryVC.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SubCategoryVC: UIViewController {

    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var productCV: UICollectionView!
    
    var categoryData = CategoryModel.init([String : Any]())
    var arrSubCategory = [CategoryModel]()
    var selectedSubCat = CategoryModel.init([String : Any]())
    var page = 1
    var arrProduct = [ProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCollectionView()
        nameLbl.text = categoryData.name
        serviceCallToGetSubCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToCart(_ sender: Any) {
        
    }
    
    @IBAction func clickToFilter(_ sender: Any) {
    
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
extension SubCategoryVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        categoryCV.register(UINib.init(nibName: "CategoriesCVC", bundle: nil), forCellWithReuseIdentifier: "CategoriesCVC")
        productCV.register(UINib.init(nibName: "DisplayProductCVC", bundle: nil), forCellWithReuseIdentifier: "DisplayProductCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCV {
            return arrSubCategory.count
        }else{
            return arrProduct.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCV {
            return CGSize(width: collectionView.frame.size.width, height: 110)
        }
        else {
            return CGSize(width: collectionView.frame.size.width/2, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCV {
            let cell : CategoriesCVC = categoryCV.dequeueReusableCell(withReuseIdentifier: "CategoriesCVC", for: indexPath) as! CategoriesCVC
            cell.setupDetails(arrSubCategory[indexPath.row])
            return cell
        }else{
            let cell : DisplayProductCVC = productCV.dequeueReusableCell(withReuseIdentifier: "DisplayProductCVC", for: indexPath) as! DisplayProductCVC
            cell.setupDetails(arrProduct[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView  == productCV && page != 0 && (arrProduct.count-1) == indexPath.row {
            serviceCallToGetProductList()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCV {
            let vc : ProductDetailVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if selectedSubCat.term_id != arrSubCategory[indexPath.row].term_id {
                selectedSubCat = arrSubCategory[indexPath.row]
                page = 1
                serviceCallToGetProductList()
            }
        }
    }
}

extension SubCategoryVC {
    func serviceCallToGetSubCategory() {
        HomeAPIManager.shared.serviceCallToGetSubCategory(categoryData.term_id) { (data) in
            self.arrSubCategory = [CategoryModel]()
            for temp in data {
                self.arrSubCategory.append(CategoryModel.init(temp))
            }
            self.categoryCV.reloadData()
            if self.arrSubCategory.count > 0 {
                self.selectedSubCat = self.arrSubCategory[0]
                self.page = 1
                self.serviceCallToGetProductList()
            }
            self.nameLbl.text = self.categoryData.name + " (" + String(self.arrSubCategory.count) + " Products found)"
            self.nameLbl.attributedText = attributedStringWithColor(self.nameLbl.text!, [self.categoryData.name], color: self.nameLbl.textColor, font: UIFont(name: APP_BOLD, size: 14.0))
        }
    }
    
    func serviceCallToGetProductList() {
        var param = [String : Any]()
        param["paged"] = page
        param["cat_id"] = selectedSubCat.term_id
        printData(param)
        HomeAPIManager.shared.serviceCallToGetProductList(param) { (data, total) in
            if self.page == 1 {
                self.arrProduct = [ProductModel]()
            }
            for temp in data {
                self.arrProduct.append(ProductModel.init(temp))
            }
            if total == self.arrProduct.count {
                self.page = 0
            }else{
                self.page += 1
            }
            self.productCV.reloadData()
        }
    }
}
