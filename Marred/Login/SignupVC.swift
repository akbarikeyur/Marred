//
//  SignupVC.swift
//  Marred
//
//  Created by Keyur Akbari on 11/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var fnameTxt: TextField!
    @IBOutlet weak var lnameTxt: TextField!
    @IBOutlet weak var unameTxt: TextField!
    @IBOutlet weak var businessNameTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var phoneFlagImg: UIImageView!
    @IBOutlet weak var phonecodeLbl: Label!
    @IBOutlet weak var phoneTxt: TextField!
    @IBOutlet weak var pavilionFlagImg: UIImageView!
    @IBOutlet weak var pavilionTxt: TextField!
    @IBOutlet weak var categoryTxt: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToSelectPhoneCode(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToSelectPavilion(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToSelectCategory(_ sender: Any) {
        
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        
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
