//
//  BuyerOrderTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class BuyerOrderTabVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var arrOrder = [OrderModel]()
    var refreshControl = UIRefreshControl.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableViewMethod()
        refreshControl.addTarget(self, action: #selector(serviceCallToGetBuyerOrder), for: .valueChanged)
        tblView.refreshControl = refreshControl
    }
    
    func setupDetails() {
        if arrOrder.count == 0 {
            serviceCallToGetBuyerOrder()
        }else{
            tblView.reloadData()
        }
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
extension BuyerOrderTabVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: "MyOrderTVC", bundle: nil), forCellReuseIdentifier: "MyOrderTVC")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrder.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyOrderTVC = tblView.dequeueReusableCell(withIdentifier: "MyOrderTVC") as! MyOrderTVC
        cell.setupDetails(arrOrder[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension BuyerOrderTabVC {
    @objc func serviceCallToGetBuyerOrder() {
        refreshControl.endRefreshing()
        DashboardAPIManager.shared.serviceCallToGetBuyerOrder { (data) in
            self.arrOrder = [OrderModel]()
            for temp in data {
                var order = OrderModel.init(temp["cart_data"] as? [String : Any] ?? [String : Any]())
                order.quantity = AppModel.shared.getIntData(temp, "quantity")
                order.product_detail = OrderProductModel.init(temp["product_detail"] as? [String : Any] ?? [String : Any]())
                self.arrOrder.append(order)
            }
            self.tblView.reloadData()
        }
    }
}
