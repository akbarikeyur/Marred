//
//  SellerWithdrawTabVC.swift
//  Marred
//
//  Created by Keyur Akbari on 17/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SellerWithdrawTabVC: UIViewController {

    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var tabCV: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var constraintHeightTblView: NSLayoutConstraint!
    @IBOutlet weak var withdrawView: View!
    @IBOutlet weak var noDataLbl: Label!
    
    var selectedTab = 0
    var arrTab = ["Withdraw Request", "Approved Requests", "Cancelled Requests"]
    var arrPending = [WithdrawModel]()
    var arrApproved = [WithdrawModel]()
    var arrCancelled = [WithdrawModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCollectionView()
        registerTableViewMethod()
        
        var newFrame = withdrawView.frame
        newFrame.size.width = SCREEN.WIDTH-40
        withdrawView.frame = newFrame
        withdrawView.addDashedBorder(OrangeColor)
        noDataLbl.text = "You don't have sufficient balance for a withdraw request!"
        serviceCallToGetWithdrawRequest()
    }
    
    func setupDetails() {
        
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

//MARK:- CollectionView Method
extension SellerWithdrawTabVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        tabCV.register(UINib.init(nibName: "CategoryListCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryListCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTab.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = arrTab[indexPath.row]
        if selectedTab == indexPath.row {
            label.font = UIFont.init(name: APP_BOLD, size: 14)
        }else{
            label.font = UIFont.init(name: APP_REGULAR, size: 14)
        }
        label.sizeToFit()
        return CGSize(width: label.frame.size.width + 20, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryListCVC = tabCV.dequeueReusableCell(withReuseIdentifier: "CategoryListCVC", for: indexPath) as! CategoryListCVC
        cell.nameLbl.text = arrTab[indexPath.row]
        cell.lineImg.isHidden = true
        if selectedTab == indexPath.row {
            cell.nameLbl.textColor = BlackColor
            cell.nameLbl.font = UIFont.init(name: APP_BOLD, size: 14)
        }else{
            cell.nameLbl.textColor = DarkTextColor
            cell.nameLbl.font = UIFont.init(name: APP_REGULAR, size: 14)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTab = indexPath.row
        tabCV.reloadData()
        if selectedTab == 0 {
            noDataLbl.text = "You don't have sufficient balance for a withdraw request!"
            if arrPending.count == 0 {
                serviceCallToGetWithdrawRequest()
            }else{
                updateWithdrawTableHeight()
            }
        }
        else if selectedTab == 1 {
            noDataLbl.text = "You don't have any approved request!"
            if arrApproved.count == 0 {
                serviceCallToGetWithdrawRequest()
            }else{
                updateWithdrawTableHeight()
            }
        }
        else if selectedTab == 2 {
            noDataLbl.text = "You don't have any cancelled request!"
            if arrCancelled.count == 0 {
                serviceCallToGetWithdrawRequest()
            }else{
                updateWithdrawTableHeight()
            }
        }
    }
}

//MARK:- Tableview Method
extension SellerWithdrawTabVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: "WithdrawRequestTVC", bundle: nil), forCellReuseIdentifier: "WithdrawRequestTVC")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedTab == 0 {
            return arrPending.count
        }
        else if self.selectedTab == 1 {
            return arrApproved.count
        }
        else if self.selectedTab == 2 {
            return arrCancelled.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WithdrawRequestTVC = tblView.dequeueReusableCell(withIdentifier: "WithdrawRequestTVC") as! WithdrawRequestTVC
        if self.selectedTab == 0 {
            cell.setupDetails(arrPending[indexPath.row])
        }
        else if self.selectedTab == 1 {
            cell.setupDetails(arrApproved[indexPath.row])
        }
        else if self.selectedTab == 2 {
            cell.setupDetails(arrCancelled[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateWithdrawTableHeight() {
        constraintHeightTblView.constant = CGFloat.greatestFiniteMagnitude
        tblView.reloadData()
        tblView.layoutIfNeeded()
        constraintHeightTblView.constant = tblView.contentSize.height
    }
}

extension SellerWithdrawTabVC {
    func serviceCallToGetWithdrawRequest() {
        var param = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.ID
        param["status"] = selectedTab
        DashboardAPIManager.shared.serviceCallToGetWithdrawRequest(param) { (data) in
            if self.selectedTab == 0 {
                self.arrPending = [WithdrawModel]()
                for temp in data {
                    self.arrPending.append(WithdrawModel.init(temp))
                }
                self.noDataLbl.isHidden = (self.arrPending.count > 0)
            }
            else if self.selectedTab == 1 {
                self.arrApproved = [WithdrawModel]()
                for temp in data {
                    self.arrApproved.append(WithdrawModel.init(temp))
                }
                self.noDataLbl.isHidden = (self.arrApproved.count > 0)
            }
            else if self.selectedTab == 2 {
                self.arrCancelled = [WithdrawModel]()
                for temp in data {
                    self.arrCancelled.append(WithdrawModel.init(temp))
                }
                self.noDataLbl.isHidden = (self.arrCancelled.count > 0)
            }
            self.updateWithdrawTableHeight()
        }
    }
}
