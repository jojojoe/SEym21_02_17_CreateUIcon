//
//  CUIymStoreVC.swift
//  CUIymCreateUIcon
//
//  Created by JOJO on 2021/6/3.
//

import UIKit
import NoticeObserveKit
 
class CUIymStoreVC: UIViewController {
    private var pool = Notice.ObserverPool()
    let topCoinLabel = UILabel()
    var collection: UICollectionView!
    var backBtn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollection()
        addNotificationObserver()
    }
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = "Coins:\(CoinManager.default.coinCount)"
            }
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .pi_noti_priseFetch) { [weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
        .invalidated(by: pool)
    }

}

extension CUIymStoreVC {
    
    @objc func makeBtnBackClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func setupView() {
        view.backgroundColor = .white
        //
        let bgImgV = UIImageView(image: UIImage(named: "home_background"))
        bgImgV.contentMode = .scaleAspectFill
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        func makeBtnBack() -> UIButton {
            let btn = UIButton(type: .custom)
            btn.setImage(UIImage(named: "edit_ic_back"), for: .normal)
            btn.setTitle("", for: .normal)
            btn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
            btn.setBackgroundImage(UIImage(named: ""), for: .normal)
            btn.backgroundColor = .clear
            btn.titleLabel?.font = UIFont(name: "", size: 18)
            view.addSubview(btn)
            btn.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
                $0.left.equalTo(12)
                $0.width.equalTo(44)
                $0.height.equalTo(44)
            }
            btn.addTarget(self, action: #selector(makeBtnBackClick(sender:)), for: .touchUpInside)
            return btn
        }
        backBtn = makeBtnBack()
        
//
//        func makeLabelTopTitle() -> UILabel {
//            let label = UILabel()
//            label.font = UIFont(name: "Thonburi-Bold", size: 20)
//            label.textColor = UIColor(hexString: "#000000")
//            label.text = "Store"
//            label.textAlignment = .center
//            label.numberOfLines = 0
//            label.adjustsFontSizeToFitWidth = true
//            label.backgroundColor = .clear
//            return label
//        }
//        var topTitle = UILabel()
//        topTitle = makeLabelTopTitle()
//        view.addSubview(topTitle)
//        topTitle.snp.makeConstraints {
//            $0.centerY.equalTo(backBtn)
//            $0.centerX.equalToSuperview()
//            $0.width.greaterThanOrEqualTo(1)
//            $0.height.greaterThanOrEqualTo(1)
//        }
        
        
        topCoinLabel.textAlignment = .right
        topCoinLabel.text = "Coins:\(CoinManager.default.coinCount)"
        
        topCoinLabel.textColor = UIColor(hexString: "#FFFFFF")
        topCoinLabel.font = UIFont(name: "Verdana-Bold", size: 28)
        view.addSubview(topCoinLabel)
        topCoinLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(24)
            $0.height.greaterThanOrEqualTo(35)
            $0.width.greaterThanOrEqualTo(25)
        }
        
//        let coinImageV = UIImageView()
//        coinImageV.image = UIImage(named: "icon_vip")
//        coinImageV.contentMode = .scaleAspectFit
//        view.addSubview(coinImageV)
//        coinImageV.snp.makeConstraints {
//            $0.centerY.equalTo(topCoinLabel)
//            $0.right.equalTo(topCoinLabel.snp.left).offset(-4)
//            $0.width.height.equalTo(28)
//        }
        
        
    }
    
    func setupCollection() {
        
        //
        let bottomBgview = UIView()
        bottomBgview.backgroundColor = .white
        view.addSubview(bottomBgview)
        
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        collection.layer.cornerRadius = 35
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(topCoinLabel.snp.bottom).offset(30)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view)
        }
        collection.register(cellWithClass: IHymStoreCell.self)
        //
        bottomBgview.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    func selectCoinItem(item: StoreItem) {
        CoinManager.default.purchaseIapId(iap: item.iapId) { (success, errorString) in
            
            if success {
                CoinManager.default.addCoin(coin: item.coin)
                self.showAlert(title: "Purchase successful.", message: "")
            } else {
                self.showAlert(title: "Purchase failed.", message: errorString)
            }
        }
    }
}


extension CUIymStoreVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController()
        }
    }
}


extension CUIymStoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: IHymStoreCell.self, for: indexPath)
        let item = CoinManager.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "\(item.coin) Coins"
        cell.priceLabel.text = item.price
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoinManager.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension CUIymStoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        272 × 238
        return CGSize(width: 166, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = ((UIScreen.main.bounds.width - 166 * 2 - 1) / 3)
        return UIEdgeInsets(top: 30, left: left, bottom: 30, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let left = ((UIScreen.main.bounds.width - 166 * 2 - 1) / 3)
        return left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let left = ((UIScreen.main.bounds.width - 166 * 2 - 1) / 3)
        return left
    }
    
}

extension CUIymStoreVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = CoinManager.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}
class IHymStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var bgImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
        bgView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        //
        bgImageV.backgroundColor = UIColor(hexString: "#FFFFFF")
        bgImageV.contentMode = .scaleAspectFit
        bgImageV.image = UIImage(named: "")
//        bgImageV.layer.masksToBounds = true
//        bgImageV.layer.cornerRadius = 27
//        bgImageV.layer.borderColor = UIColor.black.cgColor
//        bgImageV.layer.borderWidth = 4
        bgView.addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel.textColor = UIColor(hexString: "#000000")
        coinCountLabel.numberOfLines = 1
        coinCountLabel.textAlignment = .center
        coinCountLabel.font = UIFont(name: "Verdana-Bold", size: 24)
        coinCountLabel.adjustsFontSizeToFitWidth = true
        bgView.addSubview(coinCountLabel)
        coinCountLabel.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(5)
            $0.height.equalTo(30)
        }
        
        //
        coverImageV.image = UIImage(named: "store_coin")
        coverImageV.contentMode = .center
        bgView.addSubview(coverImageV)
        
        //
        priceLabel.textColor = UIColor(hexString: "#FFFFFF")
        priceLabel.font = UIFont(name: "Verdana-Bold", size: 22)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
        priceLabel.backgroundColor = UIColor(hexString: "#4AD0EF")
        
        priceLabel.cornerRadius = 30
        priceLabel.adjustsFontSizeToFitWidth = true
//        priceLabel.layer.borderWidth = 2
//        priceLabel.layer.borderColor = UIColor.white.cgColor
        priceLabel.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(150)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        coverImageV.snp.makeConstraints {
            $0.bottom.equalTo(priceLabel.snp.centerY)
            $0.centerX.equalTo(priceLabel)
            $0.width.equalTo(118)
            $0.height.equalTo(118)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                
            } else {
                
            }
        }
    }
}



