//
//  BannerAdTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 08/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class BannerAdTVC: UITableViewCell {

    @IBOutlet weak var bannerCV: UICollectionView!
    
    var arrImage = ["banner_yellow_1", "banner_yellow_2"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCollectionView()
    }

    func setupDetails() {
        bannerCV.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- CollectionView Method
extension BannerAdTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        bannerCV.register(UINib.init(nibName: "BannerImageCVC", bundle: nil), forCellWithReuseIdentifier: "BannerImageCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 210, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BannerImageCVC = bannerCV.dequeueReusableCell(withReuseIdentifier: "BannerImageCVC", for: indexPath) as! BannerImageCVC
        cell.setupDetails(arrImage[indexPath.row])
        return cell
    }
}
