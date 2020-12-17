//
//  BuyerAccountDetailTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class BuyerAccountDetailTabVC: UIViewController {

    @IBOutlet weak var userImg: ImageView!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var fnameTxt: TextField!
    @IBOutlet weak var lnameTxt: TextField!
    @IBOutlet weak var displayNameTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var currentPwdTxt: TextField!
    @IBOutlet weak var newPwdTxt: TextField!
    @IBOutlet weak var confirmPwdTxt: TextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupDetails() {
        
    }
    
    //MARK:- Button click event
    @IBAction func clickToSelectImage(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToSaveChanges(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
