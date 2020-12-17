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
    @IBOutlet weak var withdrawView: View!
    
    var selectedTab = 0
    var arrTab = ["Withdraw Request", "Approved Requests", "Cancelled Requests"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCollectionView()
        var newFrame = withdrawView.frame
        newFrame.size.width = SCREEN.WIDTH-40
        withdrawView.frame = newFrame
        withdrawView.addDashedBorder(OrangeColor)
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
    }
}
