//
//  ShopCategoryTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 07/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit
import DropDown

class ShopCategoryTVC: UITableViewCell {

    @IBOutlet weak var categoryLbl: Label!
    @IBOutlet weak var categoryCV: UICollectionView!
    
    var arrCategory = [CategoryModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCategoryList), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CATEGORY_LIST), object: nil)
        registerCollectionView()
    }

    func setupDetails() {
        if arrCategory.count == 0 {
            arrCategory = getCategoryData()
        }
        categoryCV.reloadData()
    }
    
    @objc func refreshCategoryList() {
        arrCategory = getCategoryData()
        categoryCV.reloadData()
    }
    
    @IBAction func clickToSelectCategory(_ sender: UIButton) {
        self.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCategory {
            arrData.append(temp.name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            let vc : SubCategoryVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SubCategoryVC") as! SubCategoryVC
            vc.categoryData = self.arrCategory[index]
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        dropDown.show()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}

//MARK:- CollectionView Method
extension ShopCategoryTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        categoryCV.register(UINib.init(nibName: "TopCategoryCVC", bundle: nil), forCellWithReuseIdentifier: "TopCategoryCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : TopCategoryCVC = categoryCV.dequeueReusableCell(withReuseIdentifier: "TopCategoryCVC", for: indexPath) as! TopCategoryCVC
        cell.setupDetail(arrCategory[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc : SubCategoryVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SubCategoryVC") as! SubCategoryVC
        vc.categoryData = arrCategory[indexPath.row]
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
