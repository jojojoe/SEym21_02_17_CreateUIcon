//
//  CUIymSettingVC.swift
//  CUIymCreateUIcon
//
//  Created by JOJO on 2021/6/3.
//

import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit
import DeviceKit

let AppName: String = "New Icon+"
let purchaseUrl = ""
let TermsofuseURLStr = "http://spiky-caption.surge.sh/Terms_of_use.html"
let PrivacyPolicyURLStr = "http://animated-fruit.surge.sh/Privacy_Agreement.html"

let feedbackEmail: String = "bilishjuuuny@yandex.com"
let AppAppStoreID: String = ""



class CUIymSettingVC: UIViewController {
    var backBtn = UIButton(type: .custom)
    let loginBtn = UIButton(type: .custom)
    
    
    let userNameLabel = UILabel()
    let feedbackBtn = SettingContentBtn(frame: .zero, name: "Feedback", iconImage: UIImage(named: "setting_ic_feedback")!)
    let privacyLinkBtn = SettingContentBtn(frame: .zero, name: "Privacy Policy", iconImage: UIImage(named: "setting_ic_privacy")!)
    let termsBtn = SettingContentBtn(frame: .zero, name: "Terms of use", iconImage: UIImage(named: "setting_ic_term")!)
    let logoutBtn = SettingContentBtn(frame: .zero, name: "Log out", iconImage: UIImage(named: "setting_ic_logout")!)
    let userIconImgV = UIImageView(image: UIImage(named: "setting_head"))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
         
        setupView()
        setupContentView()
        updateUserAccountStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserAccountStatus()
    }
    
    func setupView() {
        
        //
        let bgTopImgV = UIImageView(image: UIImage(named: "setting_background"))
        bgTopImgV.contentMode = .scaleAspectFill
        view.addSubview(bgTopImgV)
        bgTopImgV.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
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
                $0.width.equalTo(48)
                $0.height.equalTo(48)
            }
            btn.addTarget(self, action: #selector(makeBtnBackClick(sender:)), for: .touchUpInside)
            return btn
        }
        backBtn = makeBtnBack()
        
        //
        userIconImgV.contentMode = .scaleAspectFit
        view.addSubview(userIconImgV)
        userIconImgV.snp.makeConstraints {
            $0.width.height.equalTo(120)
            $0.right.equalTo(-58)
            $0.top.equalTo(backBtn.snp.bottom).offset(-6)
        }
        //
        //
        userNameLabel.font = UIFont(name: "Verdana-Bold", size: 18)
        userNameLabel.textColor = .white
        userNameLabel.textAlignment = .center
        userNameLabel.text = "Login"
        view.addSubview(userNameLabel)
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.snp.makeConstraints {
            $0.centerX.equalTo(userIconImgV)
            $0.top.equalTo(userIconImgV.snp.bottom).offset(20)
            $0.right.equalTo(-8)
            $0.height.equalTo(25)
        }
        //
        view.addSubview(loginBtn)
        loginBtn.setImage(UIImage(named: ""), for: .normal)
        loginBtn.snp.makeConstraints {
            $0.top.equalTo(userIconImgV.snp.top)
            $0.bottom.equalTo(userNameLabel.snp.bottom)
            $0.left.right.equalTo(userNameLabel)
        }
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        
        
    }
    @objc func makeBtnBackClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupContentView() {
        
        // feedback
        view.addSubview(feedbackBtn)
        feedbackBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.feedback()
        }
        feedbackBtn.snp.makeConstraints {
            $0.width.equalTo(357)
            $0.height.equalTo(64)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(47)
            $0.centerX.equalToSuperview()
        }
        
        // privacy link
        view.addSubview(privacyLinkBtn)
        privacyLinkBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
        }
        privacyLinkBtn.snp.makeConstraints {
             
            $0.width.equalTo(357)
            $0.height.equalTo(64)
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(27)
            $0.centerX.equalToSuperview()
        }
        // terms
        
        view.addSubview(termsBtn)
        termsBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: TermsofuseURLStr)
        }
        termsBtn.snp.makeConstraints {
            $0.width.equalTo(357)
            $0.height.equalTo(64)
            $0.top.equalTo(privacyLinkBtn.snp.bottom).offset(27)
            $0.centerX.equalToSuperview()
        }
        // logout
        
        view.addSubview(logoutBtn)
        logoutBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            LoginManage.shared.logout()
            self.updateUserAccountStatus()
        }
        logoutBtn.snp.makeConstraints {
            
            $0.width.equalTo(357)
            $0.height.equalTo(64)
            $0.top.equalTo(termsBtn.snp.bottom).offset(27)
            $0.centerX.equalToSuperview()
        }
         
    }
     
}

extension CUIymSettingVC {
 
    @objc func loginBtnClick(sender: UIButton) {
        self.showLoginVC()
        
    }
    
    func showLoginVC() {
        if LoginManage.currentLoginUser() == nil {
            let loginVC = LoginManage.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    func updateUserAccountStatus() {
        if let userModel = LoginManage.currentLoginUser() {
            let userName  = userModel.userName
            userNameLabel.text = (userName?.count ?? 0) > 0 ? userName : AppName
            logoutBtn.isHidden = false
            loginBtn.isUserInteractionEnabled = false
            
        } else {
            userNameLabel.text = "Login"
            logoutBtn.isHidden = true
            loginBtn.isUserInteractionEnabled = true
            
        }
    }
}

extension CUIymSettingVC: MFMailComposeViewControllerDelegate {
    func feedback() {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            //获取系统版本号
            let systemVersion = UIDevice.current.systemVersion
            let modelName = UIDevice.current.modelName
            
            let infoDic = Bundle.main.infoDictionary
            // 获取App的版本号
            let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
            // 获取App的名称
            let appName = "\(AppName)"

            
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("\(appName) Feedback")
            //设置收件人
            // FIXME: feed back email
            controller.setToRecipients([feedbackEmail])
            //设置邮件正文内容（支持html）
         controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
            
            //打开界面
         self.present(controller, animated: true, completion: nil)
        }else{
            HUD.error("The device doesn't support email")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
 }


class SettingContentBtn: UIButton {
    var clickBlock: (()->Void)?
    var nameTitle: String
    var iconImage: UIImage
    init(frame: CGRect, name: String, iconImage: UIImage) {
        self.nameTitle = name
        self.iconImage = iconImage
        super.init(frame: frame)
        setupView()
        addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
    }
    
    @objc func clickAction(sender: UIButton) {
        clickBlock?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = UIColor(hexString: "#000000")
//        self.layer.cornerRadius = 17
//        self.layer.borderWidth = 4
//        self.layer.borderColor = UIColor.black.cgColor
        //
        let iconImgV = UIImageView(image: iconImage)
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(33)
        }
        //
        func makeLabel() -> UILabel {
            let label = UILabel()
            label.font = UIFont(name: "Verdana-Bold", size: 20)
            label.textColor = UIColor(hexString: "#FFFFFF")
            label.text = nameTitle
            label.textAlignment = .center
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.backgroundColor = .clear
            return label
        }
        var label = UILabel()
        label = makeLabel()
        addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconImgV.snp.right).offset(25)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        let arrowImgV = UIImageView(image: UIImage(named: "setting_ic_select"))
        addSubview(arrowImgV)
        arrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-32)
            $0.width.equalTo(10)
            $0.height.equalTo(18)
        }
        
    }
    
}
