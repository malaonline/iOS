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
        }
    }
    
    // MARK: - Components
    /// 标题label
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor = MalaColor_636363_0
        return titleLabel
    }()
    /// 分割线
    lazy var separatorLine: UIView = {
        let separatorLine = UIView.line()
        separatorLine.backgroundColor = MalaColor_E5E5E5_0
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
        selectionStyle = .None
        separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        // SubViews
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorLine)
        
        // Autolayout
        titleLabel.snp_makeConstraints { (make) in
            make.height.equalTo(14)
            make.centerY.equalTo(contentView.snp_centerY)
            make.left.equalTo(contentView.snp_left).offset(13)
        }
        separatorLine.snp_makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp_bottom)
            make.left.equalTo(contentView.snp_left).offset(12)
            make.right.equalTo(contentView.snp_right).offset(12)
            make.height.equalTo(MalaScreenOnePixel)
        }
    }
    
    func hideSeparator() {
        separatorLine.hidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        separatorLine.hidden = false
    }
}
