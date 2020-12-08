//
//  BannerImageCVC.swift
//  Marred
//
//  Created by Keyur Akbari on 08/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class BannerImageCVC: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ image : String) {
        imgView.image = UIImage(named: image)
    }
    
}
