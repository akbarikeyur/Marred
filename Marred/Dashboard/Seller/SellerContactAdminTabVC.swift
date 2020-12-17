//
//  SellerContactAdminTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 17/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SellerContactAdminTabVC: UIViewController {

    @IBOutlet weak var fnameTxt: TextField!
    @IBOutlet weak var lnameTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var messageTxtView: TextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupDetails() {
        
    }
    
    //MARK:- Button click event
    @IBAction func clickToSend(_ sender: Any) {
        
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
