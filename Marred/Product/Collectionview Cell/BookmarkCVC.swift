//
//  BookmarkCVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class BookmarkCVC: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var wishBtn: UIButton!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupDetails(_ dict : ProductModel) {
        setImageBackgroundImage(imgView, dict.thumbnail, IMAGE.PLACEHOLDER)
        nameLbl.text = dict.title
        priceLbl.text = displayPriceWithCurrency(dict.price)
    }
}
