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
        let imageView = UIImageView(image: UIImage(named: "pullArrow"))
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
        layoutView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(self)
        }
        regionLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(layoutView)
            make.height.equalTo(layoutView)
            make.left.equalTo(layoutView)
            make.right.equalTo(arrow.snp_left).offset(-5)
        }
        arrow.snp_makeConstraints { (make) in
            make.width.equalTo(8)
            make.height.equalTo(4.5)
            make.centerY.equalTo(layoutView)
            make.left.equalTo(regionLabel.snp_right).offset(5)
            make.right.equalTo(layoutView)
        }
    }
}
