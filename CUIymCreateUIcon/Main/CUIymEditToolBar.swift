//
//  CUIymEditToolBar.swift
//  CUIymCreateUIcon
//
//  Created by JOJO on 2021/6/8.
//

import UIKit

class CUIymEditToolBar: UIView {
    var dataList1: [EditToolItem]
    var dataList2: [EditToolItem]
    var collection: UICollectionView!
    var collection2: UICollectionView!
    var showCellLine: Bool = false
    
    var didSelectItemBlock: ((EditToolItem, Bool)->Void)?
    var currentItem: EditToolItem?
    
    
    init(frame: CGRect, list1: [EditToolItem], list2: [EditToolItem]) {
        self.dataList1 = list1
        self.dataList2 = list2
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.clipsToBounds = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(68)
        }
        collection.register(cellWithClass: CUIymToolEditBarCell.self)
        //
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        collection2 = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout2)
        collection2.clipsToBounds = false
        collection2.showsVerticalScrollIndicator = false
        collection2.showsHorizontalScrollIndicator = false
        collection2.backgroundColor = .clear
        collection2.delegate = self
        collection2.dataSource = self
        addSubview(collection2)
        collection2.snp.makeConstraints {
            $0.bottom.right.left.equalToSuperview()
            $0.height.equalTo(68)
        }
        collection2.register(cellWithClass: CUIymToolEditBarCell.self)
        
        
    }
    
}

extension CUIymEditToolBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collection {
            let cell = collectionView.dequeueReusableCell(withClass: CUIymToolEditBarCell.self, for: indexPath)
            let item = dataList1[indexPath.item]
            if indexPath.item <= 2 {
                cell.vipProImgV.isHidden = true
            } else {
                cell.vipProImgV.isHidden = false
            }
            
            if showCellLine {
                cell.bottomLine.isHidden = false
            } else {
                cell.bottomLine.isHidden = true
                cell.contentImgV.backgroundColor = UIColor(hexString: "#303030")
            }
            if item.thumbStr.contains("#") {
                cell.contentImgV.backgroundColor = UIColor(hexString: item.thumbStr)
                cell.contentImgV.image = nil
            } else {
                cell.contentImgV.image = UIImage(named: item.thumbStr)
            }
            if let cuItem = currentItem, item.thumbStr == cuItem.thumbStr {
                cell.selectBgView.isHidden = false
            } else {
                cell.selectBgView.isHidden = true
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: CUIymToolEditBarCell.self, for: indexPath)
            let item = dataList2[indexPath.item]
            if indexPath.item <= 2 {
                cell.vipProImgV.isHidden = true
            } else {
                cell.vipProImgV.isHidden = false
            }
            cell.contentImgV.image = UIImage(named: item.thumbStr)
            if showCellLine {
                cell.bottomLine.isHidden = false
            } else {
                cell.bottomLine.isHidden = true
                cell.contentImgV.backgroundColor = UIColor(hexString: "#303030")
            }
            if item.thumbStr.contains("#") {
                cell.contentImgV.backgroundColor = UIColor(hexString: item.thumbStr)
                cell.contentImgV.image = nil
            } else {
                cell.contentImgV.image = UIImage(named: item.thumbStr)
            }
            if let cuItem = currentItem, item.thumbStr == cuItem.thumbStr {
                cell.selectBgView.isHidden = false
            } else {
                cell.selectBgView.isHidden = true
            }
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collection {
            return dataList1.count
        } else {
            return dataList2.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension CUIymEditToolBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 66, height: 66)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

extension CUIymEditToolBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collection {
            let item = dataList1[indexPath.item]
            currentItem = item
        } else {
            let item = dataList2[indexPath.item]
            currentItem = item
        }
        if let cuItem = currentItem {
            var isVip = false
            if indexPath.item <= 2 {
                isVip = false
            } else {
                isVip = true
            }
            didSelectItemBlock?(cuItem, isVip)
        }
        collection.reloadData()
        collection2.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

class CUIymToolEditBarCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let bottomLine = UIView()
    let vipProImgV = UIImageView(image: UIImage(named: "edit_ic_vip"))
    let selectBgView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.clipsToBounds = false
        clipsToBounds = false
        //
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.layer.cornerRadius = 3
        contentImgV.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(6)
            $0.right.bottom.equalToSuperview().offset(-6)
        }
        //
        contentView.addSubview(bottomLine)
        bottomLine.backgroundColor = .white
        bottomLine.layer.cornerRadius = 3
        bottomLine.snp.makeConstraints {
            $0.left.right.bottom.equalTo(contentImgV)
            $0.height.equalTo(6)
        }
        //
        
        selectBgView.backgroundColor = .clear
        selectBgView.layer.borderWidth =  2
        selectBgView.layer.borderColor = UIColor(hexString: "#01DFDE")?.cgColor
        selectBgView.layer.cornerRadius = 4
        contentView.addSubview(selectBgView)
        selectBgView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        
        contentView.addSubview(vipProImgV)
        vipProImgV.snp.makeConstraints {
            $0.top.equalTo(-2)
            $0.right.equalTo(2)
            $0.width.height.equalTo(19)
        }
        
    }
}
