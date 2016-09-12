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
    
    
    // MARK: - Components
    private lazy var label: UILabel = {
        let label = UILabel(title: "ATPX4869")
        return label
    }()
    private lazy var arrow: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pullArrow"))
        return imageView
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        
        
        // SubViews
        addSubview(label)
        addSubview(arrow)
        
        // AutoLayout
        label.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(arrow.snp_left).offset(-5)
        }
        arrow.snp_makeConstraints { (make) in
            make.width.equalTo(8)
            make.height.equalTo(4.5)
            make.centerY.equalTo(self)
            make.right.equalTo(self)
        }
    }
}
