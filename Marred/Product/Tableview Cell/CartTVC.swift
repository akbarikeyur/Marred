//
//  CartTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 10/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class CartTVC: UITableViewCell {

    @IBOutlet weak var imgBtn: Button!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var vendorLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var quantityLbl: Label!
    @IBOutlet weak var plusBtn: Button!
    @IBOutlet weak var minusBtn: Button!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
