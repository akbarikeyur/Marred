//
//  PavillionShopCVC.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class PavillionShopCVC: UICollectionViewCell {

    @IBOutlet weak var outerView: View!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var arrowImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if isArabic() {
            arrowImg.image = UIImage(named: "black_arrow_previous")
        }else{
            arrowImg.image = UIImage(named: "black_arrow")
        }
    }

    func setupDetails(_ dict : PavilionModel) {
        nameLbl.text = getTranslate(dict.name)
        imgView.image = UIImage(named: dict.image)
    }
}
