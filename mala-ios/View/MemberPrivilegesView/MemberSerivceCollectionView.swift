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
    }
    
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 所有操作结束弹栈时，取消选中项
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        NotificationCenter.default.post(name: MalaNotification_PushIntroduction, object: (indexPath.section*4+(indexPath.row)))
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
        let index = indexPath.section*4+(indexPath.row)
        cell.model = self.model[index]
        return cell
    }
}


// MARK: - MemberSerivceCollectionViewCell
class MemberSerivceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    /// 会员专享模型
    var model: IntroductionModel? {
        didSet {
            iconView.image = UIImage(asset: model?.image ?? .none)
            titleLabel.text = model?.title
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
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .ArticleText)
        )
        label.textAlignment = .center
        return label
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
        // SubViews
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        
        // Autolayout
        iconView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView).offset(20)
            maker.centerX.equalTo(contentView)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(contentView)
            maker.height.equalTo(14)
            maker.top.equalTo(iconView.snp.bottom).offset(12)
            maker.bottom.equalTo(contentView)
        }
    }
}


class MemberSerivceFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Instance Method
    init(frame: CGRect = CGRect.zero) {
        super.init()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        scrollDirection = .vertical
        let itemWidth: CGFloat = (MalaLayout_CardCellWidth - (10*2)) / 4
        let itemHeight: CGFloat = 96
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
}
