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

    func setupDetails() {
        let strStock = "Stock: In stock   Status: Online   Views: 198"
        stockLbl.attributedText = attributedStringWithColor(strStock, ["Stock:", "Status:", "Views:"], color: colorFromHex(hex: "33558B"), font: UIFont(name: APP_BOLD, size: 12.0))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
