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
    @IBOutlet weak var languageSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        languageSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        if L102Language.currentAppleLanguage() == "en" {
            self.languageSwitch.setOn(false, animated: false)
        }
        else{
            self.languageSwitch.setOn(true, animated: false)
        }
    }
    
    func setupDetails(_ dict : MenuModel) {
        if dict.id == 8  {
            menuBtn.isHidden = true
        }else{
            menuBtn.isHidden = false
            menuBtn.setImage(UIImage(named: dict.image), for: .normal)
        }
        titleLbl.text = getTranslate(dict.name)
        languageSwitch.isHidden = (dict.id != 8)
    }

    @IBAction func changeLanguage(_ sender: Any) {
        AppDelegate().sharedDelegate().changeLanguage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
