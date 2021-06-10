//
//  CUIymCanvasPreview.swift
//  CUIymCreateUIcon
//
//  Created by JOJO on 2021/6/8.
//

import UIKit

class CUIymCanvasPreview: UIView {
    let bgImageV: UIImageView = UIImageView()
    let fgImageV: UIImageView = UIImageView()
    let iconContentV: UIView = UIView()
    var currentIconStr: String = ""
    var currentBgStr: String = ""
    var currentFgStr: String = ""
    var currentCorner: CGFloat = 0
    var currentScale: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .white
        
        addSubview(bgImageV)
        addSubview(fgImageV)
        bgImageV.layer.masksToBounds = true
        fgImageV.layer.masksToBounds = true
        bgImageV.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        fgImageV.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
        iconContentV.backgroundColor = .clear
        iconContentV.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        addSubview(iconContentV)
        
        self.fgImageV.mask = iconContentV
        
    }
}

extension CUIymCanvasPreview {
    func updateBgColor(colorStr: String) {
        currentBgStr = colorStr
        if colorStr.contains("#") {
            bgImageV.image = nil
            bgImageV.backgroundColor = UIColor(hexString: colorStr)
        } else {
            bgImageV.image = UIImage(named: colorStr)
            bgImageV.backgroundColor = .clear
        }
    }
     
    
    func updateFgColor(colorStr: String) {
        currentFgStr = colorStr
        if colorStr.contains("#") {
            fgImageV.image = nil
            fgImageV.backgroundColor = UIColor(hexString: colorStr)
        } else {
            fgImageV.image = UIImage(named: colorStr)
            fgImageV.backgroundColor = .clear
        }
    }
     
    
    func updateIconItem(icon: String) {
        currentIconStr = icon
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: iconContentV.bounds.width, height: iconContentV.bounds.height))
        imageV.image = UIImage(named: icon)
        imageV.contentMode = .scaleAspectFit
        self.iconContentV.removeSubviews()
        self.iconContentV.addSubview(imageV)
    }
    
    func updateFgImageViewTransitionScale(scale: CGFloat) {
        currentScale = scale
        iconContentV.transform = CGAffineTransform.init(scaleX: scale, y: scale)
    }
    
    func updateCorner(corner: CGFloat) {
        currentCorner = corner
        bgImageV.layer.cornerRadius = corner
        fgImageV.layer.cornerRadius = corner
    }
    
}
