//
//  ShopCategoryTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 07/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class ShopCategoryTVC: UITableViewCell {

    @IBOutlet weak var categoryLbl: Label!
    @IBOutlet weak var categoryCV: UICollectionView!
    
    var arrCategory = [CategoryModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func setupDetails() {
        registerCollectionView()
    }
    
    @IBAction func clickToSelectCategory(_ sender: UIButton) {
        
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
        categoryCV.register(UINib.init(nibName: "CategoryCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryCVC")
        
        arrCategory = [CategoryModel]()
        for temp in getJsonFromFile("category") {
            arrCategory.append(CategoryModel.init(temp))
        }
        categoryCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryCVC = categoryCV.dequeueReusableCell(withReuseIdentifier: "CategoryCVC", for: indexPath) as! CategoryCVC
        cell.setupDetail(arrCategory[indexPath.row])
        return cell
    }
}
