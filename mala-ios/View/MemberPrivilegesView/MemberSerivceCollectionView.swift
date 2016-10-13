//
//  MemberSerivceCollectionView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let MemberSerivceCollectionViewCellReuseId = "MemberSerivceCollectionViewCellReuseId"
private let MemberSerivceCollectionViewSectionHeaderReuseId = "MemberSerivceCollectionViewSectionHeaderReuseId"
private let MemberSerivceCollectionViewSectionFooterReuseId = "MemberSerivceCollectionViewSectionFooterReuseId"

class MemberSerivceCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Property
    /// 会员专享服务数据
    var model: [IntroductionModel] = MalaConfig.memberServiceData() {
        didSet {
            reloadData()
        }
    }
    
    
    // MARK: - Instance Method
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        delegate = self
        dataSource = self
        backgroundColor = UIColor.white
        bounces = false
        isScrollEnabled = false
        
        register(MemberSerivceCollectionViewCell.self, forCellWithReuseIdentifier: MemberSerivceCollectionViewCellReuseId)
        register(
            MemberSerivceCollectionViewSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: MemberSerivceCollectionViewSectionHeaderReuseId
        )
        register(
            MemberSerivceCollectionViewSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
            withReuseIdentifier: MemberSerivceCollectionViewSectionFooterReuseId
        )
    }
    
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Section 头部视图
        if kind == UICollectionElementKindSectionHeader {
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: MemberSerivceCollectionViewSectionHeaderReuseId,
                for: indexPath
                ) as! MemberSerivceCollectionViewSectionHeader
            return sectionHeaderView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 所有操作结束弹栈时，取消选中项
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        NotificationCenter.default.post(name: MalaNotification_PushIntroduction, object: ((indexPath as NSIndexPath).section*4+((indexPath as NSIndexPath).row)))
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberSerivceCollectionViewCellReuseId, for: indexPath) as! MemberSerivceCollectionViewCell
        let index = (indexPath as NSIndexPath).section*4 + ((indexPath as NSIndexPath).row)
        cell.model = self.model[index]
        if (indexPath as NSIndexPath).row == 0 {
            cell.hideSeparator(true)
        }
        return cell
    }
}


// MARK: - MemberSerivceCollectionViewSectionHeader
class MemberSerivceCollectionViewSectionHeader: UICollectionReusableView {
    
    // MARK: - Contructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        backgroundColor = MalaColor_E5E5E5_0
    }
}


class MemberSerivceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    /// 会员专享模型
    var model: IntroductionModel? {
        didSet {
            iconView.image = UIImage(named: model?.image ?? "")
            titleLabel.text = model?.title
        }
    }
    /// 选中状态
    override internal var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = MalaColor_E5E5E5_0
            }else {
                contentView.backgroundColor = UIColor.white
            }
        }
    }

    
    // MARK: - Compontents
    /// 图标
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 13,
            textColor: MalaColor_636363_0
        )
        label.textAlignment = .center
        return label
    }()
    /// 侧分割线
    lazy var separator: UIView = {
        let view = UIView.separator(MalaColor_E5E5E5_0)
        return view
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        
        // SubViews
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(separator)
        
        // Autolayout
        iconView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentView.snp.top).offset(20)
            maker.centerX.equalTo(self.contentView.snp.centerX)
            maker.width.equalTo(23)
            maker.height.equalTo(23)
        }
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(self.contentView.snp.centerX)
            maker.height.equalTo(13)
            maker.top.equalTo(iconView.snp.bottom).offset(14)
        }
        separator.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left)
            maker.width.equalTo(MalaScreenOnePixel)
            maker.top.equalTo(self.contentView.snp.top).offset(15)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-15)
        }
    }
    
    func hideSeparator(_ hide: Bool) {
        separator.isHidden = hide
    }
}


class MemberSerivceFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Instance Method
    init(frame: CGRect) {
        super.init()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        scrollDirection = .vertical
        let itemWidth: CGFloat = MalaLayout_CardCellWidth / 4
        let itemHeight: CGFloat = 91
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        headerReferenceSize = CGSize(width: 300, height: MalaScreenOnePixel)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
}
