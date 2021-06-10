//
//  CUIymCoinAlertView.swift
//  CUIymCreateUIcon
//
//  Created by JOJO on 2021/6/9.
//

import UIKit

class CUIymCoinAlertView: UIView {

    var okBtnClickBlock: (()->Void)?
    var cancelBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
//         724 × 704
        let contentBgView = UIView()
        contentBgView.backgroundColor = .clear
        addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.equalTo(724/2)
            $0.height.equalTo(704/2)
        }
        //
        let contentImgV = UIImageView(image: UIImage(named: "cpstcoin_background"))
        contentBgView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        let contentLabel = UILabel()
        contentLabel.font = UIFont(name: "Verdana-Bold", size: 18)
        contentLabel.textColor = UIColor.black
        contentLabel.text = "Using items will cost \(CoinManager.default.coinCostCount) coins."
        contentLabel.textAlignment = .center
        contentBgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-120)
            $0.left.equalToSuperview().offset(4)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let okBtn = UIButton(type: .custom)
        contentBgView.addSubview(okBtn)
        okBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-30)
            $0.width.equalTo(286)
            $0.height.equalTo(60)
            $0.centerX.equalToSuperview()
        }
        okBtn.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
        okBtn.setTitle("Continue", for: .normal)
        okBtn.setTitleColor(.white, for: .normal)
        okBtn.setBackgroundImage(UIImage(named: "home_button"), for: .normal)
        okBtn.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 24)
        //
        let cancelBtn = UIButton(type: .custom)
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints {
            $0.top.equalTo(contentBgView.snp.bottom).offset(20)
            $0.height.width.equalTo(48)
            $0.centerX.equalToSuperview()
        }
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        cancelBtn.setImage(UIImage(named: "costcoins_ic_close"), for: .normal)
        
        
    }
    
    @objc func okBtnClick(sender: UIButton) {
        okBtnClickBlock?()
    }
    @objc func cancelBtnClick(sender: UIButton) {
        cancelBtnClickBlock?()
    }
}
