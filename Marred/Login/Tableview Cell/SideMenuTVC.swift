//
//  SideMenuTVC.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SideMenuTVC: UITableViewCell {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var titleLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupDetails(_ dict : MenuModel) {
        menuBtn.setImage(UIImage(named: dict.image), for: .normal)
        titleLbl.text = getTranslate(dict.name)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
