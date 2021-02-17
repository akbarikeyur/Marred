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
        setButtonBackgroundImage(imgBtn, dict.product_detail.thumbnail, IMAGE.PLACEHOLDER)
        invoiceLbl.text = " Invoice#: " + String(dict.id) + " "
        nameLbl.text = dict.product_detail.get_name
        qtyLbl.text = "x" + String(dict.quantity)
        priceLbl.text = displayPriceWithCurrency(dict.total)
        //2021-02-17 05:15:09.000000
        let strDate = dict.date_created.components(separatedBy: ".").first!
        let date = getDateFromDateString(date: strDate, format: "yyyy-MM-dd HH:mm:ss")
        dateLbl.text = "Order Date: " + getDateStringFromDate(date: date, format: "MMMM dd yyyy h:mm a")
        vendorLbl.text = "Vendor: " + dict.product_detail.store_name
        statusLbl.text = dict.status.capitalized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
