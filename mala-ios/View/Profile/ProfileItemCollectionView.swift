//
//  ProfileItemCollectionView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let ProfileItemCollectionViewCellReuseId = "ProfileItemCollectionViewCellReuseId"

class ProfileItemCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Property
    var model: [ProfileElementModel]? {
        didSet {
            self.reloadData()
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
        
        register(ProfileItemCollectionViewCell.self, forCellWithReuseIdentifier: ProfileItemCollectionViewCellReuseId)
    }
    
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 所有操作结束弹栈时，取消选中项
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
        if let model = model?[(indexPath as NSIndexPath).row] {
            NotificationCenter.default.post(name: MalaNotification_PushProfileItemController, object: model)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileItemCollectionViewCellReuseId, for: indexPath) as! ProfileItemCollectionViewCell
        cell.model = model?[(indexPath as NSIndexPath).row]
        return cell
    }
}


class ProfileItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    var model: ProfileElementModel? {
        didSet {
            iconView.image = UIImage(named: model?.iconName ?? "")
            newMessageView.image = UIImage(named: model?.newMessageIconName ?? "")
            titleLabel.text = model?.controllerTitle
            
            if let title = model?.controllerTitle {
                if title == "我的订单" {
                    newMessageView.isHidden = (MalaUnpaidOrderCount == 0)
                }else if title == "我的评价" {
                    newMessageView.isHidden = (MalaToCommentCount == 0)
                }
            }
        }
    }
    
    
    // MARK: - Components
    /// 图标
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    /// 新消息标签
    private lazy var newMessageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 14,
            textColor: MalaColor_636363_0
        )
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
        contentView.addSubview(newMessageView)
        contentView.addSubview(titleLabel)
        
        // AutoLayout
        iconView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(contentView)
            maker.top.equalTo(contentView).offset(13)
            maker.width.equalTo(53)
            maker.height.equalTo(53)
        }
        newMessageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconView)
            maker.right.equalTo(contentView).offset(-10)
            maker.width.equalTo(39)
            maker.height.equalTo(15)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(contentView)
            maker.top.equalTo(iconView.snp.bottom).offset(17)
            maker.height.equalTo(14)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newMessageView.isHidden = true
    }
}
