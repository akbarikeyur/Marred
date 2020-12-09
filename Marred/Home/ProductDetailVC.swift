//
//  ProductDetailVC.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var brandLbl: Label!
    @IBOutlet weak var skuLbl: Label!
    @IBOutlet weak var sizeLbl: Label!
    @IBOutlet weak var quantityBtn: Button!
    @IBOutlet weak var colorView: View!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var categoryLbl: Label!
    @IBOutlet weak var soldByLbl: Label!
    @IBOutlet weak var stockLbl: Label!
    @IBOutlet weak var descBtn: Button!
    @IBOutlet weak var vendorBtn: Button!
    @IBOutlet weak var moreProductBtn: Button!
    @IBOutlet weak var productCV: UICollectionView!
    
    var selectedImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCollectionView()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToWishList(_ sender: Any) {
        
    }
    
    @IBAction func clickToCircle(_ sender: Any) {
        
    }
    
    @IBAction func clickToSelectSize(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToChangeQuantity(_ sender: UIButton) {
        var quantity : Int = Int((quantityBtn.titleLabel?.text)!)!
        if sender.tag == 1 {
            quantity += 1
        }
        else if sender.tag == 2 {
            if quantity != 0 {
                quantity -= 1
            }
        }
        quantityBtn.setTitle(String(quantity), for: .normal)
    }
    
    @IBAction func clickToAddToCart(_ sender: Any) {
        
    }
    
    @IBAction func clickToSelectColor(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToSelectTab(_ sender: UIButton) {
        descBtn.backgroundColor = ClearColor
        vendorBtn.backgroundColor = ClearColor
        moreProductBtn.backgroundColor = ClearColor
        descBtn.isSelected = false
        vendorBtn.isSelected = false
        moreProductBtn.isSelected = false
        sender.backgroundColor = DarkYellowColor
        sender.isSelected = true
        if sender == descBtn {
            
        }
        else if sender == vendorBtn {
            
        }
        else if sender == moreProductBtn {
            
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
extension ProductDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        imageCV.register(UINib.init(nibName: "ProductImageCVC", bundle: nil), forCellWithReuseIdentifier: "ProductImageCVC")
        productCV.register(UINib.init(nibName: "DisplayProductCVC", bundle: nil), forCellWithReuseIdentifier: "DisplayProductCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCV {
            return 4
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCV {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
        }else{
            return CGSize(width: collectionView.frame.size.width/3, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCV {
            let cell : ProductImageCVC = imageCV.dequeueReusableCell(withReuseIdentifier: "ProductImageCVC", for: indexPath) as! ProductImageCVC
            cell.outerView.setCornerRadius((imageCV.frame.size.width-10)/2)
            if selectedImageIndex == indexPath.row {
                cell.outerView.layer.borderColor = DarkYellowColor.cgColor
            }else{
                cell.outerView.layer.borderColor = WhiteColor.cgColor
            }
            return cell
        }else{
            let cell : DisplayProductCVC = productCV.dequeueReusableCell(withReuseIdentifier: "DisplayProductCVC", for: indexPath) as! DisplayProductCVC
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageCV {
            selectedImageIndex = indexPath.row
            imageCV.reloadData()
        }
    }
}
