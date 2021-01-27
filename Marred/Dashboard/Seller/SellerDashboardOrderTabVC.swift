//
//  SellerDashboardOrderTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 17/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SellerDashboardOrderTabVC: UIViewController {

    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var categoryLbl: Label!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var typeCV: UICollectionView!
    
    var arrType = ["All"]
    var selectedType = 0
    var arrOrder = [OrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableViewMethod()
        registerCollectionView()
        serviceCallToGetSellerOrder()
    }
    
    func setupDetails() {
        
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
extension SellerDashboardOrderTabVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: "MyOrderTVC", bundle: nil), forCellReuseIdentifier: "MyOrderTVC")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrder.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
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

//MARK:- CollectionView Method
extension SellerDashboardOrderTabVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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
        return CGSize(width: label.frame.size.width + 10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryListCVC = typeCV.dequeueReusableCell(withReuseIdentifier: "CategoryListCVC", for: indexPath) as! CategoryListCVC
        cell.nameLbl.text = arrType[indexPath.row]
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
    }
}

extension SellerDashboardOrderTabVC {
    func serviceCallToGetSellerOrder() {
        var param = [String : Any]()
        param["author_name"] = AppModel.shared.currentUser.user_nicename
        param["paged"] = 1
        printData(param)
        DashboardAPIManager.shared.serviceCallToGetSellerOrder(param) { (data) in
            self.arrOrder = [OrderModel]()
            for temp in data {
                self.arrOrder.append(OrderModel.init(temp))
            }
            self.tblView.reloadData()
        }
    }
}
