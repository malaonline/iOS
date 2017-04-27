//
//  MAFeatureViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 24/04/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class MAFeatureViewCell: UICollectionViewCell {
    
    // MARK: - model
    var model: IntroductionModel = IntroductionModel() {
        didSet {
            imageView.image = UIImage(asset: model.image ?? .featureComment)
            titleLabel.text = model.title
            descLabel.text = model.subTitle
        }
    }
    
    // MARK: - Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(asset: .featureComment))
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            font: FontFamily.PingFangSC.Regular.font(20),
            textColor: UIColor(named: .labelBlack))
        return label
    }()
    private lazy var descLabel: UILabel = {
        let label = UILabel(
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .protocolGary))
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
    
    
    // MARK: - Private
    private func setupUserInterface() {
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        
        imageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(contentView)
            maker.top.equalTo(contentView).offset(36)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(contentView)
            maker.height.equalTo(28)
            maker.top.equalTo(imageView.snp.bottom).offset(24)
        }
        descLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(contentView)
            maker.height.equalTo(20)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
}
