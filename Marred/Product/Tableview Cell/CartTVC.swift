//
//  CartTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 10/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

protocol CartDelegate {
    func updateQuantity(_ cart : CartModel)
}

class CartTVC: UITableViewCell {

    @IBOutlet weak var imgBtn: Button!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var vendorLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var quantityLbl: Label!
    @IBOutlet weak var plusBtn: Button!
    @IBOutlet weak var minusBtn: Button!
    
    var delegate : CartDelegate?
    var cart = CartModel.init([String : Any]())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : CartModel) {
        cart = dict
        setButtonBackgroundImage(imgBtn, cart.product_image, IMAGE.PLACEHOLDER)
        nameLbl.text = dict.product_name
        vendorLbl.text = "Veendor: " + dict.store_name
        priceLbl.text = dict.product_price
        quantityLbl.text = String(dict.quantity)
    }
    
    @IBAction func clickToChangeQuantity(_ sender: UIButton) {
        var value = Int(quantityLbl.text!)!
        if sender == plusBtn {
            value += 1
        }else{
            if value > 0 {
                value -= 1
            }
        }
        quantityLbl.text = String(value)
        cart.quantity = value
        delegate?.updateQuantity(cart)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
