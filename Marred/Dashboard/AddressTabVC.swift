//
//  AddressTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class AddressTabVC: UIViewController {

    @IBOutlet weak var billingTbl: UITableView!
    @IBOutlet weak var constraintHeightBillingTbl: NSLayoutConstraint!
    @IBOutlet weak var shippingTbl: UITableView!
    @IBOutlet weak var constraintHeightShippingTbl: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableViewMethod()
    }
    
    func setupDetails() {
        updateBillingTableHeight()
        updateShippingTableHeight()
    }
    
    @IBAction func clickToEditBilling(_ sender: Any) {
        
    }
    
    @IBAction func clickToAddMoreBilling(_ sender: Any) {
        
    }
    
    @IBAction func clickToEditShipping(_ sender: Any) {
        
    }
    
    @IBAction func clickToAddMoreShipping(_ sender: Any) {
        
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

//MARK:- Tableview Method
extension AddressTabVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        billingTbl.register(UINib.init(nibName: "MyAddressTVC", bundle: nil), forCellReuseIdentifier: "MyAddressTVC")
        shippingTbl.register(UINib.init(nibName: "MyAddressTVC", bundle: nil), forCellReuseIdentifier: "MyAddressTVC")
        updateBillingTableHeight()
        updateShippingTableHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == billingTbl {
            return 4
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == billingTbl {
            let cell : MyAddressTVC = billingTbl.dequeueReusableCell(withIdentifier: "MyAddressTVC") as! MyAddressTVC
            
            cell.selectionStyle = .none
            return cell
        }else {
            let cell : MyAddressTVC = shippingTbl.dequeueReusableCell(withIdentifier: "MyAddressTVC") as! MyAddressTVC
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateBillingTableHeight() {
        constraintHeightBillingTbl.constant = CGFloat.greatestFiniteMagnitude
        billingTbl.reloadData()
        billingTbl.layoutIfNeeded()
        constraintHeightBillingTbl.constant = billingTbl.contentSize.height
    }
    
    func updateShippingTableHeight() {
        constraintHeightShippingTbl.constant = CGFloat.greatestFiniteMagnitude
        shippingTbl.reloadData()
        shippingTbl.layoutIfNeeded()
        constraintHeightShippingTbl.constant = shippingTbl.contentSize.height
    }
}
