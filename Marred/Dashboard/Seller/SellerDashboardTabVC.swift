//
//  SellerDashboardTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 17/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SellerDashboardTabVC: UIViewController {

    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var totalSaleLbl: Label!
    @IBOutlet weak var saleDateLbl: Label!
    @IBOutlet weak var totalEarningLbl: Label!
    @IBOutlet weak var earningDateLbl: Label!
    @IBOutlet weak var totalViewLbl: Label!
    @IBOutlet weak var viewDateLbl: Label!
    @IBOutlet weak var totalOrderLbl: Label!
    @IBOutlet weak var orderDateLbl: Label!
    @IBOutlet weak var orderTbl: UITableView!
    @IBOutlet weak var constraintHeightOrderTbl: NSLayoutConstraint!
    @IBOutlet weak var productTbl: UITableView!
    @IBOutlet weak var constraintHeightProductTbl: NSLayoutConstraint!
    
    var arrOrder = [TitleValueModel]()
    var arrProduct = [TitleValueModel]()
    var sellerDict = DashboardSellerModel.init([String : Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chartView.isHidden = true
        resetData()
        registerTableViewMethod()
        serviceCallToGetSellerDashboard()
    }
    
    func setupDetails() {
        
    }
    
    func resetData() {
        totalSaleLbl.text = "0"
        saleDateLbl.text = ""
        totalEarningLbl.text = "0"
        earningDateLbl.text = ""
        totalViewLbl.text = "0"
        viewDateLbl.text = ""
        totalOrderLbl.text = "0"
        orderDateLbl.text = ""
    }
    
    func setupData() {
        resetData()
        totalSaleLbl.text = sellerDict.total_sales
        if sellerDict.order_total != "" {
            totalEarningLbl.text = sellerDict.order_total
        }else{
            totalEarningLbl.text = ""
        }
        totalViewLbl.text = sellerDict.pageviews
        totalOrderLbl.text = sellerDict.orders.total
        
        arrOrder = [TitleValueModel]()
        arrOrder.append(TitleValueModel.init(["title" : getTranslate("order_total"), "value" : sellerDict.orders.total!]))
        arrOrder.append(TitleValueModel.init(["title" : getTranslate("order_complete"), "value" : sellerDict.orders.wc_completed!]))
        arrOrder.append(TitleValueModel.init(["title" : getTranslate("order_pending"), "value" : sellerDict.orders.wc_pending!]))
        arrOrder.append(TitleValueModel.init(["title" : getTranslate("order_processing"), "value" : sellerDict.orders.wc_processing!]))
        arrOrder.append(TitleValueModel.init(["title" : getTranslate("order_cancel"), "value" : sellerDict.orders.wc_cancelled!]))
        arrOrder.append(TitleValueModel.init(["title" : getTranslate("order_refund"), "value" : sellerDict.orders.wc_failed!]))
        updateOrderTableHeight()
        
        arrProduct = [TitleValueModel]()
        arrProduct.append(TitleValueModel.init(["title" : getTranslate("order_total"), "value" : sellerDict.products.total!]))
        updateProductTableHeight()
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
extension SellerDashboardTabVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        orderTbl.register(UINib.init(nibName: "DashboardOrderTVC", bundle: nil), forCellReuseIdentifier: "DashboardOrderTVC")
        productTbl.register(UINib.init(nibName: "DashboardOrderTVC", bundle: nil), forCellReuseIdentifier: "DashboardOrderTVC")
        updateOrderTableHeight()
        updateProductTableHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderTbl {
            return arrOrder.count
        }else{
            return arrProduct.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == orderTbl {
            let cell : DashboardOrderTVC = orderTbl.dequeueReusableCell(withIdentifier: "DashboardOrderTVC") as! DashboardOrderTVC
            cell.titleLbl.text = arrOrder[indexPath.row].title
            cell.valueLbl.text = arrOrder[indexPath.row].value
            cell.selectionStyle = .none
            return cell
        }else{
            let cell : DashboardOrderTVC = productTbl.dequeueReusableCell(withIdentifier: "DashboardOrderTVC") as! DashboardOrderTVC
            cell.titleLbl.text = arrProduct[indexPath.row].title
            cell.valueLbl.text = arrProduct[indexPath.row].value
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateOrderTableHeight() {
        constraintHeightOrderTbl.constant = CGFloat.greatestFiniteMagnitude
        orderTbl.reloadData()
        orderTbl.layoutIfNeeded()
        constraintHeightOrderTbl.constant = orderTbl.contentSize.height
    }
    
    func updateProductTableHeight() {
        constraintHeightProductTbl.constant = CGFloat.greatestFiniteMagnitude
        productTbl.reloadData()
        productTbl.layoutIfNeeded()
        constraintHeightProductTbl.constant = productTbl.contentSize.height
    }
}

extension SellerDashboardTabVC {
    func serviceCallToGetSellerDashboard() {
        DashboardAPIManager.shared.serviceCallToGetSellerDashboard { (dict) in
            self.sellerDict = DashboardSellerModel.init(dict)
            self.setupData()
        }
    }
}
