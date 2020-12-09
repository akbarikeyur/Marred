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
    
    var arrMenu = [MenuModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableViewMethod()
        loginView.isHidden = true
        profileView.isHidden = false
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { }
    }

    @IBAction func clickToLogin(_ sender: Any) {
        
    }
    
    @IBAction func clickToSignup(_ sender: Any) {
        
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SideMenuTVC = tblView.dequeueReusableCell(withIdentifier: "SideMenuTVC") as! SideMenuTVC
        cell.setupDetails(arrMenu[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
