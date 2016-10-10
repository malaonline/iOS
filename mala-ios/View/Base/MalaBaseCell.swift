//
//  MalaBaseCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/27.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class MalaBaseCell: UITableViewCell {

    // MARK: - Property
    /// 标题文字
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    
    // MARK: - Components
    /// 头部视图
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = MalaColor_F6F6F6_96
        return view
    }()
    /// 标题标签
    lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 14,
            textColor: MalaColor_939393_0
        )
        return label
    }()
    /// 真正的控件容器，若有需求要添加新的子控件，请添加于此内部（注意区别于 UITableViewCell 中的 contentView）
    lazy var content: UIView = UIView()
    
    
    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    private func setupUserInterface() {
        // Style
        
        // SubViews
        contentView.addSubview(headerView)
        contentView.addSubview(content)
        headerView.addSubview(titleLabel)
        
        // Autolayout
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.height.equalTo(34)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
        content.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerView.snp.bottom).offset(15)
            make.left.equalTo(contentView.snp.left).offset(12)
            make.right.equalTo(contentView.snp.right).offset(-12)
            make.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(headerView.snp.centerY)
            make.left.equalTo(headerView.snp.left).offset(12)
            make.height.equalTo(14)
        }
    }
    
    func adjustForCourseChoosing() {
        titleLabel.textColor = MalaColor_333333_0
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        headerView.backgroundColor = UIColor.white
        
        headerView.snp.updateConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(15)
            make.height.equalTo(15)
        }
        content.snp.updateConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
        }
    }
}
