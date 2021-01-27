//
//  TopCategoryCVC.swift
//  Marred
//
//  Created by Keyur Akbari on 07/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class TopCategoryCVC: UICollectionViewCell {

    @IBOutlet weak var nameLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupDetail(_ dict : CategoryModel) {
        nameLbl.text = dict.name
    }
    
}
