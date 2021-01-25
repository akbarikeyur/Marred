//
//  WithdrawRequestTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 25/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import UIKit

class WithdrawRequestTVC: UITableViewCell {

    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var statusLbl: Label!
    @IBOutlet weak var amountLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : WithdrawModel) {
        let date = getDateFromDateString(date: dict.date, format: "yyyy-MM-dd hh:mm:ss")
        dateLbl.text = "Date: " + getDateStringFromDate(date: date, format: "dd MMM, yyyy")
        amountLbl.text = displayPriceWithCurrency(dict.amount)
        statusLbl.text = "Payment Method: " + dict.method.capitalized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
