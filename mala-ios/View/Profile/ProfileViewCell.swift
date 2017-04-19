//
//  ProfileViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 3/10/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit
import WZLBadge

class ProfileViewCell: UITableViewCell {

    // MARK: - Property
    /// [个人中心]Cell数据模型
    var model: ProfileElementModel = ProfileElementModel() {
        didSet {
            titleLabel.text = model.title
            infoLabel.text = model.detail
            
            // 新消息样式
            if model.title == L10n.myOrder {
                
                infoLabel.isHidden = !(MalaUnpaidOrderCount > 0)
                
                if MalaUnpaidOrderCount > 0 {
                    titleLabel.showBadge()
                    titleLabel.badgeBgColor = UIColor(named: .ThemeRed)
                    titleLabel.badge.snp.makeConstraints({ (maker) in
                        maker.top.equalTo(titleLabel).offset(-1)
                        maker.right.equalTo(titleLabel).offset(7)
                        maker.height.equalTo(7)
                        maker.width.equalTo(7)
                    })
                    infoLabel.textColor = UIColor(named: .ThemeRed)
                }
            }
        }
    }
    
    
    // MARK: - Components
    /// 标题label
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(named: .ArticleTitle)
        titleLabel.font = FontFamily.PingFangSC.Regular.font(14)
        return titleLabel
    }()
    /// 信息label
    private lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.textColor = UIColor(named: .InfoText)
        infoLabel.font = FontFamily.PingFangSC.Regular.font(13)
        return infoLabel
    }()
    /// 分割线
    lazy var separatorLine: UIView = {
        let separatorLine = UIView(UIColor(named: .SeparatorLine))
        return separatorLine
    }()
    

    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        // SubViews
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(separatorLine)
        
        // Autolayout
        titleLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(14)
            maker.centerY.equalTo(contentView)
            maker.left.equalTo(contentView).offset(13)
        }
        infoLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(13)
            maker.centerY.equalTo(contentView)
            maker.right.equalTo(contentView)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView)
            maker.left.equalTo(contentView).offset(12)
            maker.right.equalTo(contentView).offset(12)
            maker.height.equalTo(MalaScreenOnePixel)
        }
    }
    
    func hideSeparator() {
        separatorLine.isHidden = true
    }
    
    
    // MARK: - Override
    override func prepareForReuse() {
        super.prepareForReuse()
        infoLabel.textColor = UIColor(named: .InfoText)
    }
}
