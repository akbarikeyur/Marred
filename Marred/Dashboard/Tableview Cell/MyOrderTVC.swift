//
//  MyOrderTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class MyOrderTVC: UITableViewCell {

    @IBOutlet weak var imgBtn: Button!
    @IBOutlet weak var invoiceLbl: Label!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var vendorLbl: Label!
    @IBOutlet weak var qtyLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var statusLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : OrderModel) {
        invoiceLbl.text = " Invoice#: " + String(dict.id) + " "
        if dict.line_items.count > 0 {
            nameLbl.text = dict.line_items[0].name
            qtyLbl.text = "x" + String(dict.line_items[0].quantity)
            priceLbl.text = displayPriceWithCurrency(dict.line_items[0].price)
        }
        let date = getDateFromDateString(date: dict.date_created, format: "yyyy-MM-dd'T'HH:mm:ss")
        dateLbl.text = "Order Date: " + getDateStringFromDate(date: date, format: "MMMM dd yyyy h:mm a")
        if dict.stores.count > 0 {
            vendorLbl.text = "Vendor: " + dict.stores[0].name
        }
        statusLbl.text = dict.status.capitalized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
