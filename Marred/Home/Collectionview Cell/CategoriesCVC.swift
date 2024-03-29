//
//  CategoriesCVC.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class CategoriesCVC: UICollectionViewCell {

    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var nameLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupDetails(_ dict : CategoryModel) {
        setImageBackgroundImage(imgVIew, dict.cat_image, "")
        nameLbl.text = dict.name
    }
}
