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
            regionLabel.text = String(format: "校区:%@", schoolName ?? "未选择")
        }
    }
    
    
    // MARK: - Components
    private lazy var layoutView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var regionLabel: UILabel = {
        let label = UILabel(
            text: String(format: "校区:%@", MalaCurrentSchool?.name ?? "未选择"),
            fontSize: 15,
            textColor: MalaColor_333333_0
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
        layoutView.addSubview(regionLabel)
        layoutView.addSubview(arrow)
        
        // AutoLayout
        layoutView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self)
            maker.height.equalTo(self)
        }
        regionLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(layoutView)
            maker.height.equalTo(layoutView)
            maker.left.equalTo(layoutView)
            maker.right.equalTo(arrow.snp.left).offset(-5)
        }
        arrow.snp.makeConstraints { (maker) in
            maker.width.equalTo(8)
            maker.height.equalTo(4.5)
            maker.centerY.equalTo(layoutView)
            maker.left.equalTo(regionLabel.snp.right).offset(5)
            maker.right.equalTo(layoutView)
        }
    }
}
