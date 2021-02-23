//
//  SellerOrderTVC.swift
//  Marred
//
//  Created by Keyur on 19/02/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import UIKit

class SellerOrderTVC: UITableViewCell {

    @IBOutlet weak var imgBtn: Button!
    @IBOutlet weak var orderLbl: Label!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var customerLbl: Label!
    @IBOutlet weak var earningLbl: Label!
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
        orderLbl.text = getTranslate("order_colon") + String(dict.id) + " "
        nameLbl.text = dict.product_detail.get_name
        qtyLbl.text = "x" + String(dict.quantity)
        priceLbl.text = displayPriceWithCurrency(dict.total)
        //2021-02-17 05:15:09.000000
        let strDate = dict.date_created.components(separatedBy: ".").first!
        let date = getDateFromDateString(date: strDate, format: "yyyy-MM-dd HH:mm:ss")
        dateLbl.text = getTranslate("order_date_colon") + getDateStringFromDate(date: date, format: "MMMM dd yyyy h:mm a")
        customerLbl.text = getTranslate("customer_colon") + dict.shipping.first_name.capitalized + " " + dict.shipping.last_name
        earningLbl.text = getTranslate("earning_colon") + displayPriceWithCurrency(displayFlotingPrice(dict.total_earning))
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
