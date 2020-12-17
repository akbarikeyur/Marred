//
//  SellerSettingTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 17/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SellerSettingTabVC: UIViewController {

    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var uploadImg: UIImageView!
    @IBOutlet weak var profileImg: ImageView!
    @IBOutlet weak var showEmailBtn: Button!
    @IBOutlet weak var enableProductBtn: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupDetails() {
        
    }
    
    //MARK:- Button click event
    @IBAction func clickToShowEmail(_ sender: UIButton) {
        showEmailBtn.isSelected = !showEmailBtn.isSelected
    }
    
    @IBAction func clickToEnableProduct(_ sender: UIButton) {
        enableProductBtn.isSelected = !enableProductBtn.isSelected
    }
    
    @IBAction func clickToSaveChanges(_ sender: Any) {
        
    }
    
    @IBAction func clickToUploadImage(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToUploadProfilePicture(_ sender: Any) {
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
