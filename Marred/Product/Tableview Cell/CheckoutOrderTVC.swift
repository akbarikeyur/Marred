//
//  CheckoutOrderTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 12/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class CheckoutOrderTVC: UITableViewCell {

    @IBOutlet weak var imgBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var vendorLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var quantityLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : CartModel) {
        setButtonBackgroundImage(imgBtn, dict.product_image, IMAGE.PLACEHOLDER)
        nameLbl.text = dict.product_name
        vendorLbl.text = "Veendor: " + dict.store_name
        priceLbl.text = dict.product_price
        quantityLbl.text = "x" + String(dict.quantity)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
