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
    @IBOutlet weak var paymentLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : OrderModel) {
        setButtonBackgroundImage(imgBtn, dict.product_detail.thumbnail, IMAGE.PLACEHOLDER)
        invoiceLbl.text = getTranslate("invoice_colon") + String(dict.id) + " "
        nameLbl.text = dict.product_detail.get_name
        qtyLbl.text = "x" + String(dict.quantity)
        priceLbl.text = displayPriceWithCurrency(dict.total)
        //2021-02-17 05:15:09.000000
        let strDate = dict.date_created.components(separatedBy: ".").first!
        let date = getDateFromDateString(date: strDate, format: "yyyy-MM-dd HH:mm:ss")
        dateLbl.text = getTranslate("order_date_colon") + getDateStringFromDate(date: date, format: "MMMM dd yyyy h:mm a")
        vendorLbl.text = getTranslate("vendor_colon") + dict.product_detail.store_name
        statusLbl.text = dict.status.capitalized
        if dict.payment_method_title != "" {
            paymentLbl.text = getTranslate("payment_method_colon") + dict.payment_method_title
        }else{
            paymentLbl.text = ""
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
