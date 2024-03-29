//
//  BuyerAddressTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class BuyerAddressTabVC: UIViewController {

    @IBOutlet weak var billingTbl: UITableView!
    
    var arrAddress = [AddressModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableViewMethod()
        
        arrAddress = [AddressModel]()
//        arrAddress.append(getBillingAddress())
        arrAddress.append(getShippingAddress())
        billingTbl.reloadData()
        
        serviceCallToSetAddress()
    }
    
    func setupDetails() {
        billingTbl.reloadData()
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
extension BuyerAddressTabVC : UITableViewDelegate, UITableViewDataSource, MyAddressDelegate {
    
    func registerTableViewMethod() {
        billingTbl.register(UINib.init(nibName: "MyAddressTVC", bundle: nil), forCellReuseIdentifier: "MyAddressTVC")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyAddressTVC = billingTbl.dequeueReusableCell(withIdentifier: "MyAddressTVC") as! MyAddressTVC
        cell.index = indexPath.row
        cell.deleagate = self
        cell.setupDetails(arrAddress[indexPath.row])
//        if indexPath.row == 0 {
//            cell.titleLbl.text = getTranslate("billing_address")
//        }else{
            cell.titleLbl.text = getTranslate("shipping_address")
//        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func updateAddress(_ index: Int, _ dict: AddressModel) {
        arrAddress[index] = dict
        billingTbl.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension BuyerAddressTabVC {
    func serviceCallToSetAddress() {
        DashboardAPIManager.shared.serviceCallToGetAddress { (dict) in
            self.arrAddress = [AddressModel]()
            if let billing = dict["billing"] as? [String : Any] {
                self.arrAddress.append(AddressModel.init(billing))
                setBillingAddress(AddressModel.init(billing))
            }else{
                self.arrAddress.append(AddressModel.init([String : Any]()))
            }
            if let shipping = dict["shipping"] as? [String : Any]{
                self.arrAddress.append(AddressModel.init(shipping))
                setShippingAddress(AddressModel.init(shipping))
            }else{
                self.arrAddress.append(AddressModel.init([String : Any]()))
            }
            self.billingTbl.reloadData()
        }
    }
    
}
