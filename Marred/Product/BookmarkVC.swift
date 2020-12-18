//
//  BookmarkVC.swift
//  Marred
//
//  Created by Keyur Akbari on 16/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class BookmarkVC: UIViewController {

    @IBOutlet weak var productCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCollectionView()
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
    
    @IBAction func clickToCart(_ sender: Any) {
        let vc : ShoppingCartVC = STORYBOARD.PRODUCT.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartVC
        self.navigationController?.pushViewController(vc, animated: true)
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
extension BookmarkVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        productCV.register(UINib.init(nibName: "BookmarkCVC", bundle: nil), forCellWithReuseIdentifier: "BookmarkCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BookmarkCVC = productCV.dequeueReusableCell(withReuseIdentifier: "BookmarkCVC", for: indexPath) as! BookmarkCVC
        
        return cell
    }
}
