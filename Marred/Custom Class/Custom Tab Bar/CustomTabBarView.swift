//
//  CustomTabBarView.swift
//  Event Project
//
//  Created by Amisha on 20/07/17.
//  Copyright © 2017 AK Infotech. All rights reserved.
//

import UIKit

protocol CustomTabBarViewDelegate
{
    func tabSelectedAtIndex(index:Int)
}

class CustomTabBarView: UIView {
    
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    @IBOutlet var btn5: UIButton!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    
    
    var delegate:CustomTabBarViewDelegate?
    var lastIndex : NSInteger!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize()
    {
        lastIndex = 0
    }
    
    @IBAction func tabBtnClicked(_ sender: UIButton)
    {
        let btn: UIButton = sender
        
        if !isUserLogin() && btn.tag >= 3 {
            AppDelegate().sharedDelegate().navigateToLogin()
            return
        }
        lastIndex = btn.tag - 1
        resetAllButton()
        selectTabButton()
        
    }
    
    func resetAllButton()
    {
        lbl1.textColor = DarkTextColor
        lbl2.textColor = DarkTextColor
        lbl3.textColor = DarkTextColor
        lbl4.textColor = DarkTextColor
        lbl5.textColor = DarkTextColor
        
        btn1.isSelected = false
        btn2.isSelected = false
        btn3.isSelected = false
        btn4.isSelected = false
        btn5.isSelected = false
    }
    
    func selectTabButton()
    {
        switch lastIndex {
        case 0:
            lbl1.textColor = BlackColor
            btn1.isSelected = true
            break
        case 1:
            lbl2.textColor = BlackColor
            btn2.isSelected = true
            break
        case 2:
            lbl3.textColor = BlackColor
            btn3.isSelected = true
            break
        case 3:
            lbl4.textColor = BlackColor
            btn4.isSelected = true
            break
        case 4:
            lbl5.textColor = BlackColor
            btn5.isSelected = true
            break
        default:
            break
        }
        delegate?.tabSelectedAtIndex(index: lastIndex)
    }
}
