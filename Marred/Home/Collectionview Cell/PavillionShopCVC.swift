//
//  PavillionShopCVC.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class PavillionShopCVC: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : PavilionModel) {
        setImageBackgroundImage(imgView, dict.img, IMAGE.PLACEHOLDER)
    }
}
