//
//  MAHelpViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 2017/5/22.
//  Copyright © 2017年 Mala Online. All rights reserved.
//

import UIKit

class MAHelpViewCell: UITableViewCell {
    
    var model: IntroductionModel? {
        didSet {
            guard let model = model else { return }
            
            iconView.image = UIImage(asset: model.image ?? .none)
            titleLabel.text = model.title
            descLabel.text = model.subTitle
            descLabel.textAlignment = ((model.subTitle?.characters.count ?? 0) > 15 ? .justified : .center)
        }
    }

    // MARK: - Components
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel(text: "1.课前",
                            font: FontFamily.PingFangSC.Regular.font(20),
                            textColor: UIColor(named: .labelBlack),
                            textAlignment: .center)
        return label
    }()
    private lazy var descLabel: UILabel = {
        let label = UILabel(text: "学生通过pad答题，点击提交.同步App可以根据登录手机号匹配传送给错题本，实时查看.",
                            font: FontFamily.PingFangSC.Regular.font(14),
                            textColor: UIColor(named: .protocolGary),
                            textAlignment: .justified)
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        
        iconView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(10)
            maker.centerX.equalTo(contentView)
            maker.height.equalTo(90)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconView.snp.bottom).offset(5)
            maker.centerX.equalTo(contentView)
            maker.left.equalTo(contentView).offset(37)
            maker.right.equalTo(contentView).offset(-37)
        }
        descLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
            maker.centerX.equalTo(contentView)
            maker.left.equalTo(contentView).offset(37)
            maker.right.equalTo(contentView).offset(-37)
            maker.bottom.equalTo(contentView)
        }
    }
}
