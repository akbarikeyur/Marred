//
//  HomeVC.swift
//  Marred
//
//  Created by Keyur Akbari on 07/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

struct HOME {
    static let CATEGORY_LIST = "CATEGORY_LIST"
    static let BANNER_AD = "BANNER_AD"
    static let PRODUCT_LIST = "PRODUCT_LIST"
    static let CONTACT_INFO = "CONTACT_INFO"
    
}

class HomeVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var arrData = [HomeDisplayModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerTableViewMethod()
        for temp in getJsonFromFile("Home") {
            arrData.append(HomeDisplayModel.init(temp))
        }
        tblView.reloadData()
        
        AppDelegate().sharedDelegate().serviceCallToGetCategory()
        AppDelegate().sharedDelegate().serviceCallToGetUserDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().showTabBar()
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { }
    }
    
    @IBAction func clickToSearch(_ sender: Any) {
        
    }
    
    @IBAction func clickToWishList(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 3])
    }
    
    @IBAction func clickToCart(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 2])
//        let vc : ShoppingCartVC = STORYBOARD.PRODUCT.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- Tableview Method
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: "ShopCategoryTVC", bundle: nil), forCellReuseIdentifier: "ShopCategoryTVC")
        tblView.register(UINib.init(nibName: "BannerAdTVC", bundle: nil), forCellReuseIdentifier: "BannerAdTVC")
        tblView.register(UINib.init(nibName: "PavilionProductTVC", bundle: nil), forCellReuseIdentifier: "PavilionProductTVC")
        tblView.register(UINib.init(nibName: "ContactInfoTVC", bundle: nil), forCellReuseIdentifier: "ContactInfoTVC")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = arrData[indexPath.row]
        if dict.type == HOME.CATEGORY_LIST {
            let cell : ShopCategoryTVC = tblView.dequeueReusableCell(withIdentifier: "ShopCategoryTVC") as! ShopCategoryTVC
            cell.setupDetails()
            cell.selectionStyle = .none
            return cell
        }
        else if dict.type == HOME.BANNER_AD {
            let cell : BannerAdTVC = tblView.dequeueReusableCell(withIdentifier: "BannerAdTVC") as! BannerAdTVC
            cell.setupDetails()
            cell.selectionStyle = .none
            return cell
        }
        else if dict.type == HOME.PRODUCT_LIST {
            let cell : PavilionProductTVC = tblView.dequeueReusableCell(withIdentifier: "PavilionProductTVC") as! PavilionProductTVC
            cell.setupDetails()
            cell.selectionStyle = .none
            return cell
        }
        else if dict.type == HOME.CONTACT_INFO {
            let cell : ContactInfoTVC = tblView.dequeueReusableCell(withIdentifier: "ContactInfoTVC") as! ContactInfoTVC
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
