//
//  ProfileItemCollectionViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/11/18.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class ProfileItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    var model: ProfileElementModel? {
        didSet {
            iconView.image = UIImage(named: model?.iconName ?? "")
            newMessageView.image = UIImage(named: model?.newMessageIconName ?? "")
            titleLabel.text = model?.controllerTitle
            
            if let title = model?.controllerTitle {
                if title == L10n.myOrder {
                    newMessageView.isHidden = !(MalaUnpaidOrderCount > 0)
                }else if title == L10n.myComment {
                    newMessageView.isHidden = !(MalaToCommentCount > 0)
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
        let label = UILabel(textColor: UIColor(named: .ArticleTitle))
        label.font = FontFamily.PingFangSC.Regular.font(14)
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
            maker.width.equalTo(63)
            maker.height.equalTo(61)
        }
        newMessageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconView)
            maker.right.equalTo(contentView).offset(-10)
            maker.width.equalTo(46)
            maker.height.equalTo(19)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(contentView)
            maker.top.equalTo(iconView.snp.bottom).offset(10)
            maker.height.equalTo(15)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newMessageView.isHidden = true
    }
}
