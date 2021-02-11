//
//  ProductDetailVC.swift
//  Marred
//
//  Created by Keyur Akbari on 09/12/20.
//  Copyright © 2020 Keyur Akbari. All rights reserved.
//

import UIKit
import DropDown

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
    @IBOutlet weak var sizeColorView: UIView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var sizeLbl: Label!
    @IBOutlet weak var colorLbl: Label!
    
    var selectedImageIndex = 0
    var product = ProductModel.init([String : Any]())
    var productDetail = ProductDetailModel.init([String : Any]())
    var isFavorite = false
    var arrDisplayImage = [String]()
    var arrSize = [VariationModel]()
    var arrColor = [VariationModel]()
    var selectedVariation = VariationModel.init([String : Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        colorLbl.text = getTranslate("select_color")
        sizeLbl.text = getTranslate("select_size")
        registerCollectionView()
        sizeColorView.isHidden = true
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
        priceLbl.text = displayPriceWithCurrency(product.price)
        soldByLbl.text = getTranslate("sold_by_colon") + product.vendor
    }
    
    func setupProductDetail() {
        setImageBackgroundImage(coverImgView, productDetail.thumbnail, IMAGE.PLACEHOLDER)
        arrDisplayImage = [String]()
        arrDisplayImage = productDetail.images
        imageCV.reloadData()
        nameLbl.text = productDetail.get_name
        brandLbl.text = productDetail.brands.name
        skuLbl.text = productDetail.get_sku
        quantityBtn.setTitle("1", for: .normal)
        priceLbl.text = displayPriceWithCurrency(productDetail.get_price)
        var strCat = ""
        for temp in productDetail.get_categories {
            if strCat != "" {
                strCat = strCat + ", " + temp.name
            }else{
                strCat = temp.name
            }
        }
        let tempCat = getTranslate("categories_colon") + strCat
        categoryLbl.attributedText = attributedStringWithColor(tempCat, [getTranslate("categories_colon")], color: BlackColor, font: UIFont(name: APP_MEDIUM, size: 14.0))
        soldByLbl.attributedText = attributedStringWithColor(getTranslate("sold_by_colon") + productDetail.vendor, [getTranslate("sold_by_colon")], color: BlackColor, font: UIFont(name: APP_MEDIUM, size: 14.0))
        stockLbl.text = getStockStatus(productDetail.get_stock_status)
        stockLbl.textColor = getStockStatusColor(productDetail.get_stock_status)
        clickToSelectTab(descBtn)
        productCV.reloadData()
        if productDetail.related_products.count == 0 {
            relatedProductView.isHidden = true
        }else{
            relatedProductView.isHidden = false
        }
        
        //Variation
        sizeColorView.isHidden = true
        sizeView.isHidden = true
        colorView.isHidden = true
        arrSize = [VariationModel].init()
        arrColor = [VariationModel].init()
        resetVariation()
    }
    
    func resetVariation() {
        selectedVariation = VariationModel.init([String : Any]())
        colorLbl.text = getTranslate("select_color")
        sizeLbl.text = getTranslate("select_size")
        arrDisplayImage = [String]()
        arrDisplayImage = productDetail.images
        imageCV.reloadData()
        if productDetail.get_available_variations.count > 0 {
            for temp in productDetail.get_available_variations {
                if temp.isForSize {
                    let index = arrSize.firstIndex { (tempV) -> Bool in
                        tempV.attribute_pa_size == temp.attribute_pa_size
                    }
                    if index == nil {
                        arrSize.append(temp)
                    }
                }
                if temp.isForColor {
                    let index = arrColor.firstIndex { (tempV) -> Bool in
                        tempV.attribute_pa_color == temp.attribute_pa_color
                    }
                    if index == nil {
                        arrColor.append(temp)
                    }
                }
            }
            if arrSize.count > 0 {
                sizeColorView.isHidden = false
                sizeView.isHidden = false
            }
            if arrColor.count > 0 {
                sizeColorView.isHidden = false
                colorView.isHidden = false
            }
        }
    }
    
    func getSizeArray() {
        arrSize = [VariationModel]()
        for temp in productDetail.get_available_variations {
            if temp.attribute_pa_color == colorLbl.text {
                let index = arrSize.firstIndex { (tmpSize) -> Bool in
                    tmpSize.attribute_pa_size == temp.attribute_pa_size
                }
                if index == nil {
                    arrSize.append(temp)
                }
            }
        }
        arrDisplayImage = [String]()
        for temp in arrColor {
            arrDisplayImage.append(temp.full_src)
        }
        imageCV.reloadData()
    }
    
    func getColorArray() {
        arrColor = [VariationModel]()
        for temp in productDetail.get_available_variations {
            if temp.attribute_pa_size == sizeLbl.text {
                let index = arrColor.firstIndex { (tmpSize) -> Bool in
                    tmpSize.attribute_pa_color == temp.attribute_pa_color
                }
                if index == nil {
                    arrColor.append(temp)
                }
            }
        }
        arrDisplayImage = [String]()
        for temp in arrColor {
            arrDisplayImage.append(temp.full_src)
        }
        imageCV.reloadData()
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
        param["product_id"] = productDetail.product_id
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
    
    @IBAction func clickToSelectSize(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.semanticContentAttribute = isArabic() ? .forceLeftToRight : .forceRightToLeft
        var arrData = [String]()
        for temp in arrSize {
            arrData.append(temp.attribute_pa_size)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.sizeLbl.text = item
            self.selectedVariation = self.arrSize[index]
            self.getColorArray()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectColor(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.semanticContentAttribute = isArabic() ? .forceLeftToRight : .forceRightToLeft
        var arrData = [String]()
        for temp in arrColor {
            arrData.append(temp.attribute_pa_color)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.colorLbl.text = item
            self.selectedVariation = self.arrColor[index]
            self.getSizeArray()
        }
        dropDown.show()
    }
    
    @IBAction func clickToClearVariation(_ sender: UIButton) {
        resetVariation()
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
            descLbl.attributedText = productDetail.get_description.html2AttributedString
        }
        else if sender == vendorBtn {
            descLbl.text = getTranslate("vendor_information") + productDetail.vendor
            descLbl.attributedText = descLbl.text?.html2AttributedString
        }
    }
    
    @IBAction func clickToSeeFullImage(_ sender: Any) {
        if productDetail.thumbnail != "" {
            displayFullScreenImage([productDetail.thumbnail], 0)
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
            return arrDisplayImage.count
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
            setImageBackgroundImage(cell.imgView,arrDisplayImage[indexPath.row], IMAGE.PLACEHOLDER)
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
            var arrData = [String]()
            for temp in arrDisplayImage {
                arrData.append(temp)
            }
            displayFullScreenImage(arrData, indexPath.row)
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
        param["product_id"] = String(productDetail.product_id)
        param["quantity"] = Int((quantityBtn.titleLabel?.text)!)!
        if selectedVariation.variation_id != 0 {
            param["variation_id"] = selectedVariation.variation_id
        }
        printData(param)
        ProductAPIManager.shared.serviceCallToAddToCart(param) {
            self.quantityBtn.setTitle("1", for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REFRESH_CART), object: nil)
        }
    }
}
