//
//  DashboardProductTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 17/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class DashboardProductTVC: UITableViewCell {

    @IBOutlet weak var imgBtn: Button!
    @IBOutlet weak var skuLbl: Label!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var orderLbl: Label!
    @IBOutlet weak var stockLbl: Label!
    @IBOutlet weak var viewsLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var earningLbl: Label!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func setupDetails(_ dict : ProductModel) {
        setButtonBackgroundImage(imgBtn, dict.thumbnail, IMAGE.PLACEHOLDER)
        skuLbl.text = " Sku: " + dict.get_sku + " "
        nameLbl.text = dict.title
        orderLbl.text = "Order Published: " + dict.order_published
        viewsLbl.text = "Views: " + dict.view
        priceLbl.text = "Price: " + displayPriceWithCurrency(dict.price)
        earningLbl.text = "Earning: 0 AED"
        let strStock = "Stock: In stock   Status: " + dict.get_status.capitalized + "   Views: " + dict.view
        stockLbl.attributedText = attributedStringWithColor(strStock, ["Stock:", "Status:", "Views:"], color: colorFromHex(hex: "33558B"), font: UIFont(name: APP_BOLD, size: 12.0))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
