//
//  ProductDetailVC.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    @IBOutlet weak var myScroll: UIScrollView!
    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var brandLbl: Label!
    @IBOutlet weak var skuLbl: Label!
    @IBOutlet weak var quantityBtn: Button!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var categoryLbl: Label!
    @IBOutlet weak var soldByLbl: Label!
    @IBOutlet weak var stockLbl: Label!
    @IBOutlet weak var wishBtn: Button!
    @IBOutlet weak var descBtn: Button!
    @IBOutlet weak var vendorBtn: Button!
    @IBOutlet weak var relatedProductView: UIView!
    @IBOutlet weak var productCV: UICollectionView!
    @IBOutlet weak var descLbl: Label!
    
    var selectedImageIndex = 0
    var product = ProductModel.init([String : Any]())
    var productDetail = ProductDetailModel.init([String : Any]())
    var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCollectionView()
        setupProduct()
        serviceCallToGetProductDetail()
        wishBtn.isSelected = isFavorite
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    func setupProduct() {
        setImageBackgroundImage(coverImgView, product.thumbnail, IMAGE.PLACEHOLDER)
        imageCV.reloadData()
        nameLbl.text = product.title
        brandLbl.text = product.brands.name
        quantityBtn.setTitle("1", for: .normal)
        priceLbl.text = product.price
        soldByLbl.text = getTranslate("sold_by_colon") + product.vendor
    }
    
    func setupProductDetail() {
        setImageBackgroundImage(coverImgView, product.thumbnail, IMAGE.PLACEHOLDER)
        imageCV.reloadData()
        nameLbl.text = productDetail.get_name
        brandLbl.text = product.brands.name
        skuLbl.text = productDetail.get_sku
        quantityBtn.setTitle("1", for: .normal)
        priceLbl.text = displayPriceWithCurrency(productDetail.get_price)
        let tempCat = getTranslate("categories_colon") + productDetail.get_categories.html2String
        categoryLbl.attributedText = attributedStringWithColor(tempCat, [getTranslate("categories_colon")], color: BlackColor, font: UIFont(name: APP_MEDIUM, size: 14.0))
        soldByLbl.attributedText = attributedStringWithColor(getTranslate("sold_by_colon") + product.vendor, [getTranslate("sold_by_colon")], color: BlackColor, font: UIFont(name: APP_MEDIUM, size: 14.0))
        stockLbl.text = getStockStatus(productDetail.get_stock_status)
        stockLbl.textColor = getStockStatusColor(productDetail.get_stock_status)
        clickToSelectTab(descBtn)
        productCV.reloadData()
        if productDetail.related_products.count == 0 {
            relatedProductView.isHidden = true
        }else{
            relatedProductView.isHidden = false
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToWishList(_ sender: UIButton) {
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginAlert()
            return
        }
        sender.isSelected = !sender.isSelected
        var param = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.ID
        param["product_id"] = product.id
        if sender.isSelected {
            ProductAPIManager.shared.serviceCallToAddBookmark(param) {
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REFRESH_BOOKMARK), object: nil)
            }
        }
        else{
            ProductAPIManager.shared.serviceCallToRemoveBookmark(param) {
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REFRESH_BOOKMARK), object: nil)
            }
        }
        
    }
    
    @IBAction func clickToCircle(_ sender: Any) {
        
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
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginAlert()
            return
        }
        if Int((quantityBtn.titleLabel?.text)!)! > 0 {
            serviceCallToAddToCart()
        }
    }
    
    @IBAction func clickToSelectTab(_ sender: UIButton) {
        descBtn.backgroundColor = ClearColor
        vendorBtn.backgroundColor = ClearColor
        descBtn.isSelected = false
        vendorBtn.isSelected = false
        sender.backgroundColor = DarkYellowColor
        sender.isSelected = true
        if sender == descBtn {
            descLbl.text = productDetail.get_description
        }
        else if sender == vendorBtn {
            descLbl.text = getTranslate("vendor_information") + product.vendor
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
            return (product.thumbnail == "") ? 0 : 1
        }
        return productDetail.related_products.count
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
            setImageBackgroundImage(cell.imgView, product.thumbnail, IMAGE.PLACEHOLDER)
            cell.outerView.setCornerRadius((imageCV.frame.size.width-10)/2)
            if selectedImageIndex == indexPath.row {
                cell.outerView.layer.borderColor = DarkYellowColor.cgColor
            }else{
                cell.outerView.layer.borderColor = WhiteColor.cgColor
            }
            return cell
        }else{
            let cell : DisplayProductCVC = productCV.dequeueReusableCell(withReuseIdentifier: "DisplayProductCVC", for: indexPath) as! DisplayProductCVC
            cell.setupDetails(productDetail.related_products[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageCV {
            selectedImageIndex = indexPath.row
            imageCV.reloadData()
        }
        else if collectionView == productCV {
            product = productDetail.related_products[indexPath.row]
            serviceCallToGetProductDetail()
        }
    }
}

extension ProductDetailVC {
    func serviceCallToGetProductDetail() {
        ProductAPIManager.shared.serviceCallToGetProductDetail(product.id) { (dict) in
            self.productDetail = ProductDetailModel.init(dict)
            self.setupProductDetail()
            self.myScroll.setContentOffset(.zero, animated: true)
        }
    }
    
    func serviceCallToAddToCart() {
        var param = [String : Any]()
        param["product_id"] = String(product.id)
        param["quantity"] = Int((quantityBtn.titleLabel?.text)!)!
        ProductAPIManager.shared.serviceCallToAddToCart(param) {
            self.quantityBtn.setTitle("1", for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REFRESH_CART), object: nil)
        }
    }
}
