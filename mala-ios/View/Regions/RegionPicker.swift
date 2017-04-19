//
//  RegionPicker.swift
//  mala-ios
//
//  Created by 王新宇 on 16/9/12.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class RegionPicker: UIView {

    // MARK: - Property
    var schoolName: String? = MalaCurrentSchool?.name {
        didSet {
            regionLabel.text = schoolName ?? "未选择"
        }
    }
    
    
    // MARK: - Components
    private lazy var layoutView: UIView = {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.alpha = 0.2
        return view
    }()
    private lazy var regionLabel: UILabel = {
        let label = UILabel(
            text: MalaCurrentSchool?.name ?? "未选择",
            fontSize: 12,
            textColor: UIColor.white
        )
        return label
    }()
    private lazy var arrow: UIImageView = {
        let imageView = UIImageView(imageName: "pullArrow")
        return imageView
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 138, height: 30))
        setupUserInterface()
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Method
    private func setupUserInterface() {
        // SubViews
        addSubview(layoutView)
        insertSubview(regionLabel, aboveSubview: layoutView)
        insertSubview(arrow, aboveSubview: layoutView)
        
        // AutoLayout
        layoutView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self)
            maker.height.equalTo(24)
        }
        regionLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(layoutView)
            maker.height.equalTo(layoutView)
            maker.left.equalTo(layoutView).offset(15)
            maker.right.equalTo(arrow.snp.left).offset(-5)
        }
        arrow.snp.makeConstraints { (maker) in
            maker.width.equalTo(8)
            maker.height.equalTo(12)
            maker.centerY.equalTo(layoutView)
            maker.left.equalTo(regionLabel.snp.right).offset(5)
            maker.right.equalTo(layoutView).offset(-15)
        }
    }
}
