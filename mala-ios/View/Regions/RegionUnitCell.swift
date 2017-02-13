//
//  RegionUnitCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/9/12.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class RegionUnitCell: UITableViewCell {

    // MARK: - Property
    // 城市数据模型
    var city: BaseObjectModel = BaseObjectModel() {
        didSet {
            titleLabel.text = city.name
        }
    }
    // 校区数据模型
    var school: SchoolModel = SchoolModel() {
        didSet {
            titleLabel.text = school.name
            addressLabel.text = school.address
        }
    }
    
    
    // MARK: - Components
    /// 地点名称
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            fontSize: 14,
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    /// 地址名称
    private lazy var addressLabel: UILabel = {
        let titleLabel = UILabel(
            fontSize: 12,
            textColor: UIColor(named: .ArticleText)
        )
        return titleLabel
    }()
    /// 分割线
    lazy var separatorLine: UIView = {
        let separatorLine = UIView(UIColor(named: .SeparatorLine))
        return separatorLine
    }()
    
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        // SubViews
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(separatorLine)
        
        // Autolayout
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(13)
            maker.left.equalTo(contentView).offset(12)
            maker.height.equalTo(14)
            maker.bottom.equalTo(addressLabel.snp.top).offset(-6)
        }
        addressLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(6)
            maker.left.equalTo(contentView).offset(12)
            maker.height.equalTo(12)
            maker.bottom.equalTo(separatorLine.snp.top).offset(-13)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(addressLabel.snp.bottom).offset(13)
            maker.left.equalTo(contentView).offset(12)
            maker.right.equalTo(contentView).offset(12)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.bottom.equalTo(contentView)
        }
    }
    
    func hideSeparator() {
        separatorLine.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        separatorLine.isHidden = false
    }
}
