//
//  PavilionProductTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 08/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit
import JXPageControl

class PavilionProductTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var adImgView: UIImageView!
    @IBOutlet weak var productCV: UICollectionView!
    @IBOutlet weak var viewAllBtn: Button!
    @IBOutlet weak var topPageControl: JXPageControlScale!
    
    var dictHome = HomeModel.init([String : Any]())
    var selectedCategory = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCollectionView()
    }

    func setupDetails() {
        nameLbl.text = dictHome.name.capitalized
        categoryCV.reloadData()
        productCV.reloadData()
        setImageBackgroundImage(adImgView, dictHome.banner, IMAGE.PLACEHOLDER)
        if (dictHome.products.count % 4) == 0 {
            topPageControl.numberOfPages = (dictHome.products.count / 4)
        }else{
            topPageControl.numberOfPages = (dictHome.products.count / 4) + 1
        }
        topPageControl.currentPage = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- CollectionView Method
extension PavilionProductTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        categoryCV.register(UINib.init(nibName: "CategoryListCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryListCVC")
        productCV.register(UINib.init(nibName: "DisplayProductCVC", bundle: nil), forCellWithReuseIdentifier: "DisplayProductCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCV {
            return dictHome.data.count
        }
        return dictHome.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCV {
            let label = UILabel(frame: CGRect.zero)
            label.text = dictHome.data[indexPath.row].name
            label.font = UIFont.init(name: APP_REGULAR, size: 12)
            label.sizeToFit()
            return CGSize(width: label.frame.size.width + 10, height: collectionView.frame.size.height)
        }else{
            return CGSize(width: collectionView.frame.size.width/2, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCV {
            let cell : CategoryListCVC = categoryCV.dequeueReusableCell(withReuseIdentifier: "CategoryListCVC", for: indexPath) as! CategoryListCVC
            cell.nameLbl.text = dictHome.data[indexPath.row].name
            if selectedCategory == indexPath.row {
                cell.nameLbl.textColor = BlackColor
                cell.lineImg.isHidden = false
            }else{
                cell.nameLbl.textColor = DarkTextColor
                cell.lineImg.isHidden = true
            }
            return cell
        }
        else{
            let cell : DisplayProductCVC = productCV.dequeueReusableCell(withReuseIdentifier: "DisplayProductCVC", for: indexPath) as! DisplayProductCVC
            cell.setupDetails(dictHome.products[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCV {
//            selectedCategory = indexPath.row
//            categoryCV.reloadData()
            let vc : SubCategoryVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SubCategoryVC") as! SubCategoryVC
            vc.categoryData = dictHome.data[indexPath.row]
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc : ProductDetailVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            vc.product = dictHome.products[indexPath.row]
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productCV {
            let visibleRect = CGRect(origin: self.productCV.contentOffset, size: self.productCV.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.productCV.indexPathForItem(at: visiblePoint) {
                self.topPageControl.currentPage = visibleIndexPath.row/4
            }
        }
    }
}
