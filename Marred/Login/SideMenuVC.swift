//
//  SideMenuVC.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImgBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var emailLbl: Label!
    
    var arrMenu = [MenuModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        registerTableViewMethod()
        
        
        updateUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isUserLogin() {
            loginView.isHidden = true
            profileView.isHidden = false
        }else{
            loginView.isHidden = false
            profileView.isHidden = true
        }
    }
    
    @objc func updateUserData() {
        if isUserLogin() {
            nameLbl.text = AppModel.shared.currentUser.display_name
            emailLbl.text = AppModel.shared.currentUser.user_email
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { }
    }

    @IBAction func clickToLogin(_ sender: Any) {
        AppDelegate().sharedDelegate().navigateToLogin()
    }
    
    @IBAction func clickToSignup(_ sender: Any) {
        AppDelegate().sharedDelegate().navigateToLogin()
    }
    
    @IBAction func clickToLogout(_ sender: Any) {
        showAlertWithOption("Logout", message: "Are you sure want to logout?", btns: ["No", "Yes"], completionConfirm: {
            AppDelegate().sharedDelegate().navigaeToLogout()
        }) {
            
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
extension SideMenuVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: "SideMenuTVC", bundle: nil), forCellReuseIdentifier: "SideMenuTVC")
        arrMenu = [MenuModel]()
        for temp in getJsonFromFile("menu") {
            arrMenu.append(MenuModel.init(temp))
        }
        tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrMenu[indexPath.row].id == 5 && !isSeller() {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SideMenuTVC = tblView.dequeueReusableCell(withIdentifier: "SideMenuTVC") as! SideMenuTVC
        if arrMenu[indexPath.row].id == 5 && !isSeller() {
            cell.isHidden = true
        }else{
            cell.isHidden = false
        }
        cell.setupDetails(arrMenu[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { }
        switch arrMenu[indexPath.row].id {
            case 1:
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 0])
                break
            case 2:
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 1])
                var delayCnt = 0.1
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: CategoryVC.self) {
                        delayCnt = 0.0
                        break
                    }
                }
                delay(delayCnt) {
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.SELECT_CATEGORY_CLICK), object: ["index" : 1])
                }
                break
            case 3:
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 1])
                var delayCnt = 0.1
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: CategoryVC.self) {
                        delayCnt = 0.0
                        break
                    }
                }
                delay(delayCnt) {
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.SELECT_CATEGORY_CLICK), object: ["index" : 0])
                }
                break
            case 4:
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginAlert()
                    return
                }
                let vc : DealofDaysVC = STORYBOARD.PRODUCT.instantiateViewController(withIdentifier: "DealofDaysVC") as! DealofDaysVC
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                break
            case 5:
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginAlert()
                    return
                }
                let vc : AddYourShopVC = STORYBOARD.PRODUCT.instantiateViewController(withIdentifier: "AddYourShopVC") as! AddYourShopVC
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                break
            case 6:
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginAlert()
                    return
                }
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 4])
                delay(0.2) {
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDIRECT_CONTACT_US), object: nil)
                }
                break
            default:
                break
        }
    }
}
