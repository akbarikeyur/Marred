//
//  CustomTabBarController.swift
//  Event Project
//
//  Created by Amisha on 20/07/17.
//  Copyright © 2017 AK Infotech. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, CustomTabBarViewDelegate {
   
    var tabBarView : CustomTabBarView = CustomTabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToTabBar(noti:)), name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: nil)
        
        tabBarView = Bundle.main.loadNibNamed("CustomTabBarView", owner: nil, options: nil)?.last as! CustomTabBarView
        tabBarView.delegate = self
        addTabBarView()
        setup()
    }
    
    @objc func redirectToTabBar(noti : Notification)
    {
        if let dict : [String : Any] = noti.object as? [String : Any]
        {
            if let index : Int = dict["tabIndex"] as? Int
            {
                tabBarView.resetAllButton()
                tabBarView.lastIndex = index
                tabBarView.selectTabButton()
                tabSelectedAtIndex(index: index)
            }
        }
    }
    
    //MARK: - CUSTOM TABBAR SETUP
    func setup()
    {
        var viewControllers = [UINavigationController]()
        let navController1 : UINavigationController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "HomeVCNav") as! UINavigationController
        viewControllers.append(navController1)
        
        let navController2 : UINavigationController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ProductListVCNav") as! UINavigationController
        viewControllers.append(navController2)
        
        let navController3 : UINavigationController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ShoppingCartNav") as! UINavigationController
        viewControllers.append(navController3)
        
        let navController4 : UINavigationController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "HomeVCNav") as! UINavigationController
        viewControllers.append(navController4)
        
        let navController5 : UINavigationController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "DashboardVCNav") as! UINavigationController
        viewControllers.append(navController5)
        
        self.viewControllers = viewControllers;
        
        self.tabBarView.lbl1.textColor = BlackColor
        self.tabSelectedAtIndex(index: 0)
    }
    
    func tabSelectedAtIndex(index: Int) {
        setSelectedViewController(selectedViewController: (self.viewControllers?[index])!, tabIndex: index)
    }
    
    func setSelectedViewController(selectedViewController:UIViewController, tabIndex:Int)
    {
        // pop to root if tapped the same controller twice
        if self.selectedViewController == selectedViewController {
            (self.selectedViewController as! UINavigationController).popToRootViewController(animated: true)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.NOTIFICATION_TAB_CLICK), object: nil)
        }
        super.selectedViewController = selectedViewController
        
    }
    
    func addTabBarView()
    {
        self.tabBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tabBarView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 50 + ((UIScreen.main.bounds.size.height >= 812) ? 34 : 0)))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        self.view.layoutIfNeeded()
    }
    
    func tabBarHidden() -> Bool
    {
        return self.tabBarView.isHidden && self.tabBar.isHidden
    }
    
    func setTabBarHidden(tabBarHidden:Bool)
    {
        self.tabBarView.isHidden = tabBarHidden
        self.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
