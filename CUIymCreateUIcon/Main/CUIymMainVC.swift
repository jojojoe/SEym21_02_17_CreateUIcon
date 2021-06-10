//
//  CUIymMainVC.swift
//  CUIymCreateUIcon
//
//  Created by JOJO on 2021/6/3.
//

import UIKit
import DeviceKit

class CUIymMainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
 

}

extension CUIymMainVC {
    func setupView() {
        view.backgroundColor = .white
        //
        let bgImgV = UIImageView(image: UIImage(named: "home_background"))
        bgImgV.contentMode = .scaleAspectFill
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        
        var contentBgViewHeight: CGFloat = 470
        var imgWidth: CGFloat = 180
        var imgTop: CGFloat = 26
        if Device.current.diagonal == 4.7 {
            contentBgViewHeight = 430
            imgWidth = 160
            imgTop = 19
        }
        
        //
        let contentBgView = UIView()
        contentBgView.backgroundColor = .black
        contentBgView.layer.cornerRadius = 35
        contentBgView.layer.masksToBounds = true
        view.addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.width.equalTo(330)
            $0.height.equalTo(contentBgViewHeight)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
        }
        //
        let coverImgV = UIImageView(image: UIImage(named: "home_img"))
        coverImgV.contentMode = .scaleAspectFit
        contentBgView.addSubview(coverImgV)
        coverImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imgTop)
            $0.width.height.equalTo(imgWidth)
        }
        //
        let coverTitleLabel = UILabel()
        coverTitleLabel.font = UIFont(name: "Verdana-Bold", size: 32)
        coverTitleLabel.textColor = .white
        coverTitleLabel.textAlignment = .left
        coverTitleLabel.numberOfLines = 2
        coverTitleLabel.text = "Super Icon Master"
        contentBgView.addSubview(coverTitleLabel)
        coverTitleLabel.snp.makeConstraints {
            $0.top.equalTo(coverImgV.snp.bottom).offset(22)
            $0.left.equalTo(38)
            $0.width.equalTo(240)
            $0.height.greaterThanOrEqualTo(75)
        }
        //
        let coverInfoLabel = UILabel()
        coverInfoLabel.font = UIFont(name: "Verdana-Bold", size: 18)
        coverInfoLabel.textColor = .white
        coverInfoLabel.textAlignment = .left
        coverInfoLabel.numberOfLines = 2
        coverInfoLabel.text = "Stimulate Creation Enjoy Art Make Now!"
        contentBgView.addSubview(coverInfoLabel)
        coverInfoLabel.snp.makeConstraints {
            $0.top.equalTo(coverTitleLabel.snp.bottom).offset(12)
            $0.left.equalTo(38)
            $0.width.equalTo(240)
            $0.height.greaterThanOrEqualTo(46)
        }
        //
        let nowBtn = UIButton(type: .custom)
        nowBtn.setBackgroundImage(UIImage(named: "edit_button"), for: .normal)
        nowBtn.setTitle("Make It Now!", for: .normal)
        nowBtn.setTitleColor(.white, for: .normal)
        nowBtn.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 24)
        nowBtn.addTarget(self, action: #selector(nowBtnClick(sender:)), for: .touchUpInside)
        contentBgView.addSubview(nowBtn)
        nowBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(coverInfoLabel.snp.bottom).offset(22)
            $0.width.equalTo(256)
            $0.height.equalTo(54)
//            572 × 120
        }
        //
        let settingBtn = CUIymMainActionBtn(frame: .zero, iconImg: UIImage(named: "home_ic_setting")!, name: "Setting")
        view.addSubview(settingBtn)
        settingBtn.snp.makeConstraints {
            $0.left.equalTo(contentBgView)
            $0.top.equalTo(contentBgView.snp.bottom).offset(17)
            $0.width.equalTo(160)
            $0.height.equalTo(140)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender:)), for: .touchUpInside)
        
        
        
        let storeBtn = CUIymMainActionBtn(frame: .zero, iconImg: UIImage(named: "home_ic_store")!, name: "Store")
        view.addSubview(storeBtn)
        storeBtn.snp.makeConstraints {
            $0.right.equalTo(contentBgView)
            $0.top.equalTo(contentBgView.snp.bottom).offset(17)
            $0.width.equalTo(160)
            $0.height.equalTo(140)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender:)), for: .touchUpInside)
        
        
        
    }
    
    @objc func nowBtnClick(sender: UIButton) {
        let editVc = CUIymEditVC()
        self.navigationController?.pushViewController(editVc)
    }
    @objc func settingBtnClick(sender: UIButton) {
        let settingVc = CUIymSettingVC()
        self.navigationController?.pushViewController(settingVc)
    }
    @objc func storeBtnClick(sender: UIButton) {
        let storeVc = CUIymStoreVC()
        self.navigationController?.pushViewController(storeVc)
    }
    
}







class CUIymMainActionBtn: UIButton {
    
    //
    let iconImgV = UIImageView()
    let nameLabel = UILabel()
    
    var icon: UIImage
    var name: String
    
    init(frame: CGRect, iconImg: UIImage, name: String) {
        self.icon = iconImg
        self.name = name
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = UIColor.black
        layer.cornerRadius = 35
        layer.masksToBounds = true
        //
        iconImgV.image = icon
        iconImgV.contentMode = .scaleAspectFit
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(snp.centerY)
            $0.width.height.equalTo(40)
        }
        //
        nameLabel.text = name
        nameLabel.font = UIFont(name: "Verdana-Bold", size: 18)
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = .center
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(14)
            $0.height.greaterThanOrEqualTo(22)
        }
        //
    }
    
}
