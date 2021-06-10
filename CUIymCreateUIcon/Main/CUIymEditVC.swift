//
//  CUIymEditVC.swift
//  CUIymCreateUIcon
//
//  Created by JOJO on 2021/6/3.
//

import UIKit
import Photos
import DeviceKit

class CUIymEditVC: UIViewController {
    let topBar = UIView()
    let bgBtn = CUIymEditTopToolBtn(frame: .zero, titleName: "Background")
    let iconBtn = CUIymEditTopToolBtn(frame: .zero, titleName: "Icon")
    let colorBtn = CUIymEditTopToolBtn(frame: .zero, titleName: "Color")
    let editToolBarBgView = UIView()
    let bgBar = CUIymEditToolBar(frame: .zero, list1: CUIDataManager.default.bgColorSingleList(), list2: CUIDataManager.default.gridentList())
    let iconBar = CUIymEditToolBar(frame: .zero, list1: CUIDataManager.default.icon1List(), list2: CUIDataManager.default.icon2List())
    let colorBar = CUIymEditToolBar(frame: .zero, list1: CUIDataManager.default.colorSingleList(), list2: CUIDataManager.default.gridentList())
    static var canvasWidth: CGFloat = 220
    var canvasPreview = CUIymCanvasPreview(frame: CGRect(x: 0, y: 0, width: canvasWidth, height: canvasWidth))
    let cornerSlider = UISlider()
    let sizeScaleSlider = UISlider()
    let coinAlertView = CUIymCoinAlertView()
    var shouldCostCoin: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        topBgBtnClick(sender: bgBtn)
        
        let scale: CGFloat = CGFloat(sizeScaleSlider.value) - 1
        canvasPreview.updateFgImageViewTransitionScale(scale: scale)
        canvasPreview.updateCorner(corner: CGFloat(cornerSlider.value))
    }
    

    

}

extension CUIymEditVC {
    func setupView() {
        view.backgroundColor = .black
        view.clipsToBounds = true
        setupTopBar()
        setupEditToolBar()
        setupBottomBar()
        setupCoinAlertView()
    }
    
    func setupTopBar() {
        
        let topBarHeight: CGFloat = 52
        view.addSubview(topBar)
        topBar.backgroundColor = .black
        topBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(2)
            $0.height.equalTo(topBarHeight)
        }
        //
        topBar.addSubview(bgBtn)
        topBar.addSubview(iconBtn)
        topBar.addSubview(colorBtn)
        //
        let padding: CGFloat = 25
        let btnwidth: CGFloat = (UIScreen.main.bounds.size.width - (4 * padding)) / 3
        let btnheight: CGFloat = 37
        bgBtn.snp.makeConstraints {
            $0.left.equalTo(padding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnwidth)
            $0.height.equalTo(btnheight)
        }
        bgBtn.addTarget(self, action: #selector(topBgBtnClick(sender:)), for: .touchUpInside)
        //
        iconBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnwidth)
            $0.height.equalTo(btnheight)
        }
        iconBtn.addTarget(self, action: #selector(topIconBtnClick(sender:)), for: .touchUpInside)
        //
        colorBtn.snp.makeConstraints {
            $0.right.equalTo(-padding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnwidth)
            $0.height.equalTo(btnheight)
        }
        colorBtn.addTarget(self, action: #selector(topColorBtnClick(sender:)), for: .touchUpInside)
    }
    
    func setupEditToolBar() {
        
        view.addSubview(editToolBarBgView)
        editToolBarBgView.backgroundColor = .clear
        editToolBarBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topBar.snp.bottom).offset(20)
            $0.height.equalTo(135)
        }
        
        //
        bgBar.showCellLine = true
        editToolBarBgView.addSubview(bgBar)
        bgBar.currentItem = EditToolItem(thumbStr: "#000000", bigStr: "#000000")
        bgBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        bgBar.didSelectItemBlock = {
            [weak self] item, isVip in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.shouldCostCoin = isVip
                self.canvasPreview.updateBgColor(colorStr: item.bigStr)
            }
        }
        
        //
        iconBar.showCellLine = false
        iconBar.currentItem = EditToolItem(thumbStr: "icon1_2", bigStr: "icon1_2_big")
        editToolBarBgView.addSubview(iconBar)
        iconBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        iconBar.didSelectItemBlock = {
            [weak self] item, isVip in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.shouldCostCoin = isVip
                if item.bigStr == "icon1_1_big" {
                    self.canvasPreview.updateIconItem(icon: "")
                } else {
                    self.canvasPreview.updateIconItem(icon: item.bigStr)
                }
            }
        }
        
        //
        colorBar.showCellLine = true
        colorBar.currentItem = EditToolItem(thumbStr: "#FFFFFF", bigStr: "#FFFFFF")
        editToolBarBgView.addSubview(colorBar)
        colorBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        colorBar.didSelectItemBlock = {
            [weak self] item, isVip in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.shouldCostCoin = isVip
                self.canvasPreview.updateFgColor(colorStr: item.bigStr)
            }
        }
    }
    
    func setupBottomBar() {
        let bottomBgView = UIView()
        bottomBgView.backgroundColor = .white
        view.addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(editToolBarBgView.snp.bottom).offset(20)
        }
        bottomBgView.layer.cornerRadius = 35
        let bottomBgOverView = UIView()
        bottomBgOverView.backgroundColor = .white
        view.addSubview(bottomBgOverView)
        bottomBgOverView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(36)
        }
        //
        var canvasPreviewTop: CGFloat = 37
        
        if Device.current.diagonal == 4.7 || Device.current.diagonal >= 7.9 {
            canvasPreviewTop = 16
            CUIymEditVC.canvasWidth = 190
            canvasPreview = CUIymCanvasPreview(frame: CGRect(x: 0, y: 0, width: CUIymEditVC.canvasWidth, height: CUIymEditVC.canvasWidth))
            
        }
        view.addSubview(canvasPreview)
        canvasPreview.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bottomBgView).offset(canvasPreviewTop)
            $0.width.height.equalTo(CUIymEditVC.canvasWidth)
        }
        
        canvasPreview.updateIconItem(icon: "icon1_2_big")
        canvasPreview.updateBgColor(colorStr: "#000000")
        canvasPreview.updateFgColor(colorStr: "#FFFFFF")
        //

        view.addSubview(cornerSlider)
        cornerSlider.minimumValue = 0
        cornerSlider.maximumValue = Float(CUIymEditVC.canvasWidth / 2)
        cornerSlider.value = 50
        cornerSlider.isContinuous = true
        cornerSlider.setThumbImage(UIImage(named: "edit_bar"), for: .normal)
        cornerSlider.minimumTrackTintColor = UIColor(hexString: "#4AD0EF")
        cornerSlider.maximumTrackTintColor = UIColor(hexString: "#4AD0EF")
        cornerSlider.snp.makeConstraints {
            $0.top.equalTo(canvasPreview.snp.bottom).offset(30)
            $0.right.equalTo(-26)
            $0.left.equalTo(120)
            $0.height.greaterThanOrEqualTo(30)
        }
        cornerSlider.addTarget(self, action: #selector(cornerSliderChange(slider:)), for: .valueChanged)
        //
        let cornerName = UILabel()
        cornerName.font = UIFont(name: "Verdana-Bold", size: 18)
        cornerName.textColor = UIColor.black
        cornerName.text = "Corner"
        view.addSubview(cornerName)
        cornerName.snp.makeConstraints {
            $0.centerY.equalTo(cornerSlider)
            $0.left.equalTo(26)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        view.addSubview(sizeScaleSlider)
        sizeScaleSlider.minimumValue = 1.4
        sizeScaleSlider.maximumValue = 2
        sizeScaleSlider.value = 2
        sizeScaleSlider.isContinuous = true
        sizeScaleSlider.setThumbImage(UIImage(named: "edit_bar"), for: .normal)
         
        sizeScaleSlider.minimumTrackTintColor = UIColor(hexString: "#4AD0EF")
        sizeScaleSlider.maximumTrackTintColor = UIColor(hexString: "#4AD0EF")
        sizeScaleSlider.snp.makeConstraints {
            $0.top.equalTo(cornerSlider.snp.bottom).offset(22)
            $0.right.equalTo(-26)
            $0.left.equalTo(120)
            $0.height.greaterThanOrEqualTo(30)
        }
        sizeScaleSlider.addTarget(self, action: #selector(sizeScaleSliderChange(slider:)), for: .valueChanged)
        
        //
        let sizeName = UILabel()
        sizeName.font = UIFont(name: "Verdana-Bold", size: 18)
        sizeName.textColor = UIColor.black
        sizeName.text = "Size"
        view.addSubview(sizeName)
        sizeName.snp.makeConstraints {
            $0.centerY.equalTo(sizeScaleSlider)
            $0.left.equalTo(26)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let backBtn = UIButton(type: .custom)
        view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "edit_ic_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.left.equalTo(26)
            $0.width.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
        //
        let saveBtn = UIButton(type: .custom)
        view.addSubview(saveBtn)
        saveBtn.setTitle("Save Now", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 24)
        saveBtn.setBackgroundImage(UIImage(named: "edit_button"), for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender:)), for: .touchUpInside)
        saveBtn.snp.makeConstraints {
            $0.right.equalTo(-26)
            $0.left.equalTo(backBtn.snp.right).offset(16)
            $0.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    //
    func setupCoinAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if CoinManager.default.coinCount >= CoinManager.default.coinCostCount {
                DispatchQueue.main.async {
                    self.savePrepareAction()
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Not enough coins, please buy first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.navigationController?.pushViewController(CUIymStoreVC())
                        }
                    }
                }
            }
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            }
        }
        coinAlertView.cancelBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            }
        }
    }
    
}

extension CUIymEditVC {
    func savePrepareAction() {
        let width_big: CGFloat = 1024
        let canvasScale: CGFloat = width_big / canvasPreview.bounds.width
        
        let canvasPreview_big = CUIymCanvasPreview(frame: CGRect(x: 0, y: 0, width: width_big, height: width_big))
        canvasPreview_big.updateBgColor(colorStr: self.canvasPreview.currentBgStr)
        canvasPreview_big.updateFgColor(colorStr: self.canvasPreview.currentFgStr)
        canvasPreview_big.updateIconItem(icon: self.canvasPreview.currentIconStr)
        canvasPreview_big.updateCorner(corner: self.canvasPreview.currentCorner * canvasScale)
        canvasPreview_big.updateFgImageViewTransitionScale(scale: self.canvasPreview.currentScale)
        
        if let img = canvasPreview_big.screenshot {
            saveToAlbumPhotoAction(images: [img])
        }
        
        
    }
    
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
                
                
            }) { (finish, error) in
                if finish {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.showSaveSuccessAlert()
                        if self.shouldCostCoin {
                            CoinManager.default.costCoin(coin: CoinManager.default.coinCostCount)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        if error != nil {
                            let auth = PHPhotoLibrary.authorizationStatus()
                            if auth != .authorized {
                                self.showDenideAlert()
                            }
                        }
                    }
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        HUD.success("Photo save successful.")
    }

    func showDenideAlert() {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                DispatchQueue.main.async {
                    let url = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url, options: [:])
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    }
}


extension CUIymEditVC {
    @objc func topBgBtnClick(sender: UIButton) {
        bgBtn.bottomLine.isHidden = false
        iconBtn.bottomLine.isHidden = true
        colorBtn.bottomLine.isHidden = true
        bgBar.isHidden = false
        iconBar.isHidden = true
        colorBar.isHidden = true
    }
    @objc func topIconBtnClick(sender: UIButton) {
        bgBtn.bottomLine.isHidden = true
        iconBtn.bottomLine.isHidden = false
        colorBtn.bottomLine.isHidden = true
        bgBar.isHidden = true
        iconBar.isHidden = false
        colorBar.isHidden = true
    }
    @objc func topColorBtnClick(sender: UIButton) {
        bgBtn.bottomLine.isHidden = true
        iconBtn.bottomLine.isHidden = true
        colorBtn.bottomLine.isHidden = false
        bgBar.isHidden = true
        iconBar.isHidden = true
        colorBar.isHidden = false
    }
    
    @objc func cornerSliderChange(slider: UISlider) {
        self.canvasPreview.updateCorner(corner: CGFloat(slider.value))
    }
    
    @objc func sizeScaleSliderChange(slider: UISlider) {
        let scale: CGFloat = CGFloat(slider.value) - 1
        self.canvasPreview.updateFgImageViewTransitionScale(scale: scale)
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        if shouldCostCoin {
            UIView.animate(withDuration: 0.35) {
                self.coinAlertView.alpha = 1
            }
        } else {
            savePrepareAction()
        }
    }
    
}





class CUIymEditTopToolBtn: UIButton {
    
    var nameStr: String
    var bottomLine: UIView = UIView()
    var nameLabel: UILabel = UILabel()
    
    init(frame: CGRect, titleName: String) {
        self.nameStr = titleName
        super.init(frame: frame)
        setupView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        addSubview(nameLabel)
        nameLabel.textColor = .white
        nameLabel.text = nameStr
        nameLabel.font = UIFont(name: "Verdana-Bold", size: 18)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
            $0.width.greaterThanOrEqualTo(1)
        }
        //
        addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor(hexString: "#4AD0EF")
        bottomLine.layer.cornerRadius = 2.5
        bottomLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(5)
        }
    }
    
    
    
}
