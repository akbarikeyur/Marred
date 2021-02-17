//
//  SellerDashboardProductTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 17/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SellerDashboardProductTabVC: UIViewController {

    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var categoryLbl: Label!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var typeCV: UICollectionView!
    
    var arrType = ["All"]
    var selectedType = 0
    var arrProduct = [ProductModel]()
    var arrDisplayProduct = [ProductModel]()
    var page = 1
    var refreshControl = UIRefreshControl.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableViewMethod()
        registerCollectionView()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tblView.refreshControl = refreshControl
        refreshData()
    }
    
    func setupDetails() {
        
    }
    
    @objc func refreshData() {
        refreshControl.endRefreshing()
        page = 1
        serviceCallToGetUserProduct()
    }
    
    //MARK:- Button click event
    @IBAction func clickToSelectDate(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToSelectCategory(_ sender: UIButton) {
        
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
extension SellerDashboardProductTabVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: "DashboardProductTVC", bundle: nil), forCellReuseIdentifier: "DashboardProductTVC")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType == 0 {
            return arrProduct.count
        }else{
            return arrDisplayProduct.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DashboardProductTVC = tblView.dequeueReusableCell(withIdentifier: "DashboardProductTVC") as! DashboardProductTVC
        if selectedType == 0 {
            cell.setupDetails(arrProduct[indexPath.row])
        }else {
            cell.setupDetails(arrDisplayProduct[indexPath.row])
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedType == 0 && page != 0 && (arrProduct.count-1) == indexPath.row {
            serviceCallToGetUserProduct()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK:- CollectionView Method
extension SellerDashboardProductTabVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        typeCV.register(UINib.init(nibName: "CategoryListCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryListCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = arrType[indexPath.row]
        if selectedType == indexPath.row {
            label.font = UIFont.init(name: APP_BOLD, size: 14)
        }else{
            label.font = UIFont.init(name: APP_REGULAR, size: 14)
        }
        label.sizeToFit()
        return CGSize(width: label.frame.size.width + 20, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryListCVC = typeCV.dequeueReusableCell(withReuseIdentifier: "CategoryListCVC", for: indexPath) as! CategoryListCVC
        cell.nameLbl.text = arrType[indexPath.row].capitalized
        cell.lineImg.isHidden = true
        if selectedType == indexPath.row {
            cell.nameLbl.textColor = BlackColor
            cell.nameLbl.font = UIFont.init(name: APP_BOLD, size: 14)
        }else{
            cell.nameLbl.textColor = DarkTextColor
            cell.nameLbl.font = UIFont.init(name: APP_REGULAR, size: 14)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedType = indexPath.row
        typeCV.reloadData()
        arrDisplayProduct = [ProductModel]()
        if selectedType != 0 {
            for temp in arrProduct {
                if temp.get_status.lowercased() == arrType[selectedType].lowercased() {
                    arrDisplayProduct.append(temp)
                }
            }
            tblView.reloadData()
        }
    }
}

extension SellerDashboardProductTabVC {
    func serviceCallToGetUserProduct() {
        var param = [String : Any]()
        param["author_name"] = AppModel.shared.currentUser.user_nicename
        param["paged"] = page
        printData(param)
        DashboardAPIManager.shared.serviceCallToGetUserProduct(param) { (dict) in
            self.arrType = ["All"]
            if self.page == 1 {
                self.arrProduct = [ProductModel]()
            }
            
            if let data = dict["products"] as? [[String : Any]] {
                for temp in data {
                    let product = ProductModel.init(temp)
                    if !self.arrType.contains(product.get_status) {
                        self.arrType.append(product.get_status)
                    }
                    self.arrProduct.append(product)
                }
            }
            
            if let total_products = dict["total_products"] as? Int {
                if total_products > self.arrProduct.count {
                    self.page += 1
                }
                else {
                    self.page = 0
                }
            }
            self.tblView.reloadData()
            self.typeCV.reloadData()
        }
    }
}
