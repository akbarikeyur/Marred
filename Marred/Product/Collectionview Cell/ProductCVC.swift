//
//  ProductCVC.swift
//  Marred
//
//  Created by Keyur Akbari on 12/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class ProductCVC: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var descLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : DealProductModel) {
        setImageBackgroundImage(imgView, dict.thumbnail, IMAGE.PLACEHOLDER)
        nameLbl.text = dict.get_name
        descLbl.text = dict.get_short_description
        priceLbl.text = displayPriceWithCurrency(dict.get_price)
    }
    
}
