//
//  DealProductCVC.swift
//  Marred
//
//  Created by Keyur Akbari on 12/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class DealProductCVC: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var soldByLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupDetails(_ dict : DealProductModel) {
        setImageBackgroundImage(imgView, dict.thumbnail, IMAGE.PLACEHOLDER)
        nameLbl.text = dict.get_name
        soldByLbl.text = dict.get_short_description
        priceLbl.text = dict.get_price
    }
}
