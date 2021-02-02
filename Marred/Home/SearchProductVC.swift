//
//  SearchProductVC.swift
//  Marred
//
//  Created by Keyur Akbari on 02/02/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import UIKit

class SearchProductVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTxt: TextField!
    @IBOutlet weak var productCV: UICollectionView!
    
    var arrProduct = [ProductModel]()
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        registerCollectionView()
        searchTxt.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if textField.text?.trimmed != "" && textField.text!.count >= 3 {
            if timer != nil {
                timer?.invalidate()
            }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(serviceCallToSearchProductList), userInfo: nil, repeats: false)
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

//MARK:- CollectionView Method
extension SearchProductVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        productCV.register(UINib.init(nibName: "DisplayProductCVC", bundle: nil), forCellWithReuseIdentifier: "DisplayProductCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : DisplayProductCVC = productCV.dequeueReusableCell(withReuseIdentifier: "DisplayProductCVC", for: indexPath) as! DisplayProductCVC
        cell.setupDetails(arrProduct[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc : ProductDetailVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.product = arrProduct[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension SearchProductVC {
    @objc func serviceCallToSearchProductList() {
        self.view.endEditing(true)
        HomeAPIManager.shared.serviceCallToSearchProductList(searchTxt.text!, true) { (data) in
            self.arrProduct = [ProductModel]()
            for temp in data {
                self.arrProduct.append(ProductModel.init(temp))
            }
            self.productCV.reloadData()
        }
    }
}
